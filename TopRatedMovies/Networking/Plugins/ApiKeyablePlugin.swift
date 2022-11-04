//
//  ApiKeyPlugin.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 04.11.2022.
//

import Foundation
import Moya

protocol ApiKeyable: TargetType { }

struct ApiKeyablePlugin: PluginType {
    
    private let apiKeyClosure: () -> String?
    
    init(_ apiKeyClosure: @escaping () -> String?) {
        self.apiKeyClosure = apiKeyClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard target is ApiKeyable else {
            return request
        }
        
        var components = request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }
        let item = URLQueryItem(name: "api_key", value: apiKeyClosure())
        components?.queryItems?.append(item)
        
        var request = request
        request.url = components?.url
        
        return request
    }
}
