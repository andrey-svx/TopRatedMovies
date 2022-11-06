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
        
        let authButtonTitle: Driver<String?> = viewWillAppearObservable
            .withLatestFrom(sessionProvider.isAuthorized()) { (_, isAuthorized) in
                isAuthorized
            }
            .map { $0 ? "log-out" : "log-in" }
            .asDriver(onErrorJustReturn: nil)
        
        let authButtonImage: Driver<UIImage?> = viewWillAppearObservable
            .withLatestFrom(sessionProvider.isAuthorized()) { (_, isAuthorized) in
                isAuthorized
            }
            .map { $0 ? "square.and.arrow.up" : "square.and.arrow.down" }
            .map { UIImage(systemName: $0) }
            .asDriver(onErrorJustReturn: nil)
        
        let coordinate = input.buttonTapped
            .asObservable()
            .withLatestFrom(sessionProvider.isAuthorized()) { (_, isAuthorized) in
                isAuthorized
            }
            .filter { !$0 }
            .flatMapLatest { [authProvider] _ -> Single<String?> in
                authProvider.rx.request(.createRequestToken, callbackQueue: .main)
                    .mapString(atKeyPath: "request_token")
                    .map { token -> String? in token }
                    .catchAndReturn(nil)
                    .do(onSuccess: { [weak self] in self?.requestTokenRelay.accept($0) })
            }
            .compactMap { $0 }
            .map { AccountInfoViewController.Output.approve($0) }
            .asDriver(onErrorJustReturn: .failure("Something went wrong"))
        
        let ground = viewWillAppearObservable
            .withLatestFrom(requestTokenRelay.asObservable()) { (_, token) in
                token
            }
            .compactMap { $0 }
            .flatMap { [authProvider] token -> Single<String?> in
                authProvider.rx.request(.createAccessToken(token), callbackQueue: .main)
                    .mapString(atKeyPath: "access_token")
                    .map { token -> String? in token }
                    .catchAndReturn(nil)
                    .do(onSuccess: { [weak self] in self?.sessionProvider.save(accessToken: $0) })
            }
            .compactMap { $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            authButtonTitle: authButtonTitle,
            authButtonImage: authButtonImage,
            coordinate: coordinate,
            ground: ground
        )
    }
}
