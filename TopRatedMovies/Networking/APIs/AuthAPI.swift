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
    case createAccessToken(String)
    case createSession(String)
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIConfigProvider.shared.mainHost)!
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "/4/auth/request_token"
        case .createAccessToken:
            return "/4/auth/access_token"
        case .createSession:
            return "/3/authentication/session/convert/4"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRequestToken:
            return .post
        case .createAccessToken:
            return .post
        case .createSession:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createRequestToken:
            return .requestPlain
        case .createAccessToken(let token):
            let body = CreateAccessTokenRequestBody(requestToken: token)
            return .requestJSONEncodable(body)
        case .createSession(let token):
            let body = CreateSessionRequestBody(accessToken: token)
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension AuthAPI: AccessTokenAuthorizable {

    var authorizationType: AuthorizationType? {
        switch self {
        case .createRequestToken:
            return .bearer
        case .createAccessToken:
            return .bearer
        case .createSession:
            return nil
        }
    }
}

extension AuthAPI: ApiKeyable { }
