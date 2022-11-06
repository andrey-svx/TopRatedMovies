//
//  SsessionProvider.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import RxSwift

struct SessionProvider {
    
    func isAuthorized() -> Single<Bool> {
        .just(KeychainWrapper.string(forKey: "session_id") != nil)
    }
    
    func logout() -> Single<Void> {
        KeychainWrapper.set(nil, forKey: "session_id")
        return .just(())
    }
}
