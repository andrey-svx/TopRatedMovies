//
//  CreateSessionUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 07.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct CreateSessionUseCase {
        
    private let provider: MoyaProvider<AuthAPI>
    
    init(_ provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }
    
    func callAsFunction(token: String) -> Single<String?> {
        provider.rx.request(.createSession(token), callbackQueue: .main)
            .mapString(atKeyPath: "session_id")
            .map { id -> String? in id }
            .catchAndReturn(nil)
    }
}
