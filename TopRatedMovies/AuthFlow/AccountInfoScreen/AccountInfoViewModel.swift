//
//  AccountInfoViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import UIKit.UIImage
import RxSwift
import RxRelay
import RxCocoa
import Moya

final class AccountInfoViewModel {
    
    private let sessionProvider: SessionProvider
    private let authProvider: MoyaProvider<AuthAPI>

    private let isAuthorizedRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    private let requestTokenRelay = ReplayRelay<String?>.create(bufferSize: 1)
    private let refreshTrigger = PublishRelay<Void>()
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let buttonTapped: Signal<Void>
    }
    
    struct Output {
        
        let authButtonTitle: Driver<String?>
        let authButtonImage: Driver<UIImage?>
        let coordinate: Driver<AccountInfoViewController.Output>
        let ground: Driver<Void>
    }

    init(_ sessionProvider: SessionProvider, _ authProvider: MoyaProvider<AuthAPI>) {
        self.sessionProvider = sessionProvider
        self.authProvider = authProvider
        self.requestTokenRelay.accept(nil)
    }
    
    func transform(_ input: Input) -> Output {
        
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let refreshTriggerObservable = refreshTrigger
            .asObservable()
            .share()
        
        let authButtonTitle: Driver<String?> = Observable.merge(
                viewWillAppearObservable,
                refreshTriggerObservable
            )
            .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
            .map { $0 ? "log-out" : "log-in" }
            .asDriver(onErrorJustReturn: nil)
        
        let authButtonImage: Driver<UIImage?> = Observable.merge(
                viewWillAppearObservable,
                refreshTriggerObservable
            )
            .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
            .map { $0 ? "square.and.arrow.up" : "square.and.arrow.down" }
            .map { UIImage(systemName: $0) }
            .asDriver(onErrorJustReturn: nil)
        
        let buttonTappedObservable = input.buttonTapped
            .asObservable()
            .share()
        
        let coordinate = buttonTappedObservable
            .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
            .filter { !$0 }
            .flatMapLatest { [authProvider] _ -> Single<String?> in
                authProvider.rx.request(.createRequestToken, callbackQueue: .main)
                    .mapString(atKeyPath: "request_token")
                    .map { token -> String? in token }
                    .catchAndReturn(nil)
                    .do(onSuccess: { [weak self] in
                        self?.requestTokenRelay.accept($0)
                    })
            }
            .compactMap { $0 }
            .map { AccountInfoViewController.Output.approve($0) }
            .asDriver(onErrorJustReturn: .failure("Something went wrong"))
        
        let logoutObservbale = buttonTappedObservable
            .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
            .filter { $0 }
            .do(onNext: { [weak self] _ in
                self?.sessionProvider.logout()
                self?.requestTokenRelay.accept(nil)
                self?.refreshTrigger.accept(())
            })
            .map { _ in () }
        
        let createSessionObservable = viewWillAppearObservable
            .withLatestFrom(requestTokenRelay.asObservable()) { (_, token) in
                token
            }
            .compactMap { $0 }
            .flatMap { [authProvider] token -> Single<String?> in
                authProvider.rx.request(.createAccessToken(token), callbackQueue: .main)
                    .mapString(atKeyPath: "access_token")
                    .map { token -> String? in token }
                    .catchAndReturn(nil)
                    .do(onSuccess: { [weak self] in
                        self?.sessionProvider.save(accessToken: $0)
                    })
            }
            .compactMap { $0 }
            .flatMap { [authProvider] token -> Single<String?> in
                authProvider.rx.request(.createSession(token), callbackQueue: .main)
                    .mapString(atKeyPath: "session_id")
                    .map { id -> String? in id }
                    .catchAndReturn(nil)
                    .do(onSuccess: { [weak self] in
                        self?.sessionProvider.save(sessionId: $0)
                        self?.requestTokenRelay.accept(nil)
                        self?.refreshTrigger.accept(())
                    })
            }
            .map { _ in () }
            .share()
        
        let ground = Observable.merge(
            logoutObservbale,
            createSessionObservable
        )
        .asDriver(onErrorJustReturn: ())
        
        return Output(
            authButtonTitle: authButtonTitle,
            authButtonImage: authButtonImage,
            coordinate: coordinate,
            ground: ground
        )
    }
}
