//
//  MoviesAPI.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 02.11.2022.
//

import Foundation
import Moya

enum MoviesAPI {
    case topRated
}

extension MoviesAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIConfigProvider.shared.mainHost)!
    }
    
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topRated:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .topRated:
            return .requestParameters(
                parameters: [
                    "api_key": APIConfigProvider.shared.apiKey,
                    "page": 1,
                    "region": "kz"
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
