//
//  AuthAPI.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import Moya

enum AuthAPI {
    
    case createRequestToken
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIConfigProvider.shared.mainHost)!
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "/4/auth/request_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRequestToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createRequestToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension AuthAPI: AccessTokenAuthorizable {

    var authorizationType: AuthorizationType? {
        .bearer
    }
}
