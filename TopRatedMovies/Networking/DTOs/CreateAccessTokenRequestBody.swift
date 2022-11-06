//
//  CreateAccessTokenRequestBody.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation

struct CreateAccessTokenRequestBody: Encodable {
    
    let requestToken: String
    
    private enum CodingKeys: String, CodingKey {
        
        case requestToken = "request_token"
    }
}
