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
import RxMoya

final class AccountInfoViewModel {

    private let sessionProvider: SessionProvider
    
    private let createRequestToken: CreateRequestTokenUseCase
    private let createAccessToken: CreateAccessTokenUseCase
    private let createSession: CreateSessionUseCase

    private let isAuthorizedRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    private let requestTokenRelay = ReplayRelay<String?>.create(bufferSize: 1)
    private let refreshTrigger = PublishRelay<Void>()
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let buttonTapped: Signal<Void>
    }
    
    struct Output {
        
        let statusMessage: Driver<String?>
        let authButtonTitle: Driver<String?>
        let authButtonImage: Driver<UIImage?>
        let isLoading: Driver<Bool>
        let coordinate: Driver<AccountInfoViewController.Output>
        let ground: Driver<Void>
    }

    init(_ sessionProvider: SessionProvider, _ authProvider: MoyaProvider<AuthAPI>) {
        self.sessionProvider = sessionProvider
        self.createRequestToken = .init(authProvider)
        self.createAccessToken = .init(authProvider)
        self.createSession = .init(authProvider)
        self.requestTokenRelay.accept(nil)
    }
    
    func transform(_ input: Input) -> Output {
        
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let refreshTriggerObservable = refreshTrigger
            .asObservable()
            .share()
        
        let statusMessage: Driver<String?> = Observable.merge(
            viewWillAppearObservable,
            refreshTriggerObservable
        )
        .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
        .map { $0 ? "You are logged-in" : "You are logged-out" }
        .asDriver(onErrorJustReturn: nil)
        
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
        
        let requestTokenInitObservable = buttonTappedObservable
            .flatMap { [sessionProvider] in sessionProvider.isAuthorized() }
            .filter { !$0 }
            .map { _ in () }
            .share()
        
        let requestTokenCompleteObservable = requestTokenInitObservable
            .flatMapLatest { [createRequestToken] _ -> Single<String?> in
                createRequestToken()
                    .do(onSuccess: { [weak self] in
                        self?.requestTokenRelay.accept($0)
                    })
            }
            .share()
        
        let coordinate = requestTokenCompleteObservable
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
        
        let createSessionInitObservable = viewWillAppearObservable
            .withLatestFrom(requestTokenRelay.asObservable()) { (_, token) in
                token
            }
            .compactMap { $0 }
            .share()
        
        let createSessionCompleteObservable = createSessionInitObservable
            .flatMap { [createAccessToken] token -> Single<String?> in
                createAccessToken(token: token)
                    .do(onSuccess: { [weak self] in
                        self?.sessionProvider.save(accessToken: $0)
                    })
            }
            .compactMap { $0 }
            .flatMap { [createSession] token -> Single<String?> in
                createSession(token: token)
                    .do(onSuccess: { [weak self] in
                        self?.sessionProvider.save(sessionId: $0)
                        self?.requestTokenRelay.accept(nil)
                        self?.refreshTrigger.accept(())
                    })
            }
            .map { _ in () }
            .share()
        
        let isLoading = Observable.merge(
                requestTokenInitObservable.map { _ in true },
                createSessionInitObservable.map { _ in true },
                requestTokenCompleteObservable.map { _ in false },
                createSessionCompleteObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let ground = Observable.merge(
                logoutObservbale,
                createSessionCompleteObservable
            )
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            statusMessage: statusMessage,
            authButtonTitle: authButtonTitle,
            authButtonImage: authButtonImage,
            isLoading: isLoading,
            coordinate: coordinate,
            ground: ground
        )
    }
}
