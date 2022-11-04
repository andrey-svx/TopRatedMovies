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
    case details(String)
}

extension MoviesAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIConfigProvider.shared.mainHost)!
    }
    
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .details(let id):
            return "/3/movie/" + id
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topRated:
            return .get
        case .details:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .topRated:
            return .requestParameters(
                parameters: [
                    "page": 1,
                    "region": "kz"
                ],
                encoding: URLEncoding.default
            )
        case .details:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension MoviesAPI: ApiKeyable { }
