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
        .just(true)
    }
    
    func logout() -> Single<Void> {
        .just(())
    }
}
