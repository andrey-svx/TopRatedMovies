//
//  CreateAccessTokenUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 07.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct CreateAccessTokenUseCase {
        
    private let provider: MoyaProvider<AuthAPI>
    
    init(_ provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }
    
    func callAsFunction(token: String) -> Single<String?> {
        provider.rx.request(.createAccessToken(token), callbackQueue: .main)
            .mapString(atKeyPath: "access_token")
            .map { token -> String? in token }
            .catchAndReturn(nil)
    }
}
