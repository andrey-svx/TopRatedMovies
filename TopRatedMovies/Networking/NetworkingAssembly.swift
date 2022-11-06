//
//  NetworkingAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 07.11.2022.
//

import Foundation
import Swinject
import Moya

final class NetworkingAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<MoviesAPI>.self) { _ in
            MoyaProvider<MoviesAPI>.instantiate()
        }
        
        container.register(MoyaProvider<ImagesAPI>.self) { _ in
            MoyaProvider<ImagesAPI>.instantiate()
        }
        
        container.register(MoyaProvider<AuthAPI>.self) { _ in
            MoyaProvider<AuthAPI>.instantiate { target in
                switch target {
                case .createRequestToken, .createAccessToken:
                    return APIConfigProvider.shared.initialAccessToken
                case .createSession:
                    return KeychainWrapper.string(forKey: "access_token") ?? ""
                }
            }
        }
    }
}
