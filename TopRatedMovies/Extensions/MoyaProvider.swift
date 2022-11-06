//
//  MoyaProvider.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 04.11.2022.
//

import Foundation
import Moya

extension MoyaProvider {
    
    static func instantiate() -> MoyaProvider<Target> {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin.default,
            ApiKeyablePlugin({ APIConfigProvider.shared.apiKey }),
            SessionIdentifiablePlugin({ _ in KeychainWrapper.string(forKey: "session_id") }),
            AccessTokenPlugin(tokenClosure: { _ in KeychainWrapper.string(forKey: "access_token") ?? "" })
        ]
        let provider: MoyaProvider<Target> = .init(plugins: plugins)
        return provider
    }
    
    static func instantiate(tokenClosure: @escaping (Target) -> String) -> MoyaProvider<Target> {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin.default,
            ApiKeyablePlugin({ APIConfigProvider.shared.apiKey }),
            SessionIdentifiablePlugin({ _ in KeychainWrapper.string(forKey: "session_id") }),
            AccessTokenPlugin(tokenClosure: { targetType in
                guard let target = targetType as? Target else {
                    return ""
                }
                
                return tokenClosure(target)
            })
        ]
        let provider: MoyaProvider<Target> = .init(plugins: plugins)
        return provider
    }
}
