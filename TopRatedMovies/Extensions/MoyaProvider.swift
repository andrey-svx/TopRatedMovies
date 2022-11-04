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
            ApiKeyablePlugin { APIConfigProvider.shared.apiKey },
            SessionIdentifiablePlugin { _ in fatalError("Not implemented yet") }
        ]
        let provider: MoyaProvider<Target> = .init(plugins: plugins)
        return provider
    }
    
    static func instantiate(
        _ prepareClosure: @escaping (_ request: URLRequest, _ target: TargetType) -> URLRequest,
        _ didReceiveClosure: @escaping (_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void
    ) -> MoyaProvider<Target> {
        let plugins: [PluginType] = [
            CustomPlugin(prepareClosure, didReceiveClosure)
        ]
        return .init(plugins: plugins)
    }
    
}
