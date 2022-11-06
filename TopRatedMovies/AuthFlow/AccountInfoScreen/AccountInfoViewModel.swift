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
    
    private let isAuthorizedRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let buttonTapped: Signal<Void>
    }
    
    struct Output {
        
        let authButtonTitle: Driver<String?>
        let authButtonImage: Driver<UIImage?>
    }
    
    private let sessionProvider: SessionProvider
    
    init(_ sessionProvider: SessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func transform(_ input: Input) -> Output {
        
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let authButtonTitle: Driver<String?> = viewWillAppearObservable
            .withLatestFrom(sessionProvider.isAuthorized().asObservable()) { (_, isAuthorized) in
                isAuthorized
            }
            .map { $0 ? "log-out" : "log-in" }
            .asDriver(onErrorJustReturn: nil)
        
        let authButtonImage: Driver<UIImage?> = viewWillAppearObservable
            .withLatestFrom(sessionProvider.isAuthorized().asObservable()) { (_, isAuthorized) in
                isAuthorized
            }
            .map { $0 ? "square.and.arrow.up" : "square.and.arrow.down" }
            .map { UIImage(systemName: $0) }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            authButtonTitle: authButtonTitle,
            authButtonImage: authButtonImage
        )
    }
}
