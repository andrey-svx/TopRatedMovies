//
//  AccountInfoViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Moya

final class AccountInfoViewModel {
    
    private let isAuthorizedRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let authorizeTapped: Signal<Void>
        let logoutTapped: Signal<Void>
    }
    
    struct Output {
        
        let authorizeIsVisible: Driver<Bool>
        let logoutIsVisible: Driver<Bool>
    }
    
    private let sessionProvider: SessionProvider
    
    init(_ sessionProvider: SessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
