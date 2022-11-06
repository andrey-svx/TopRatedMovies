//
//  CreateRequestTokenUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 07.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct CreateRequestTokenUseCase {
        
    private let provider: MoyaProvider<AuthAPI>
    
    init(_ provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }
    
    func callAsFunction() -> Single<String?> {
        provider.rx.request(.createRequestToken, callbackQueue: .main)
            .mapString(atKeyPath: "request_token")
            .map { token -> String? in token }
            .catchAndReturn(nil)
    }
}
