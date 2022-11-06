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
    
    func logout() {
        KeychainWrapper.set(nil, forKey: "access_token")
        KeychainWrapper.set(nil, forKey: "session_id")
    }
    
    func save(accessToken token: String?) {
        KeychainWrapper.set(token, forKey: "access_token")
    }
    
    func save(sessionId id: String?) {
        KeychainWrapper.set(id, forKey: "session_id")
    }
}
