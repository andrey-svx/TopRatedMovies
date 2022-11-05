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
    case details(Int)
    case rate(id: Int, rating: Double)
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
            return "/3/movie/\(id)"
        case .rate(id: let id, rating: _):
            return "/3/movie/\(id)/rating"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topRated:
            return .get
        case .details:
            return .get
        case .rate:
            return .post
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
        case .rate(id: _, rating: let rating):
            let body = RateMovieRequestBody(value: rating)
            let data = (try? JSONEncoder().encode(body)) ?? .init()
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension MoviesAPI: ApiKeyable { }

extension MoviesAPI: SessionIdentifiable {
    
    var sessionIdentifier: SessionIdentifier? {
        switch self {
        case .topRated:
            return nil
        case .details:
            return nil
        case .rate:
            return .sessionId
        }
    }
}
