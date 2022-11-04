//
//  ImagesAPI.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 02.11.2022.
//

import Foundation
import Moya

enum ImagesAPI {
    
    case w200(String)
    case w500(String)
}

extension ImagesAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIConfigProvider.shared.imagesHost)!
    }
    
    var path: String {
        switch self {
        case .w200(let poster):
            return "/w200" + poster
        case .w500(let poster):
            return "/w500" + poster
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        nil
    }
}
