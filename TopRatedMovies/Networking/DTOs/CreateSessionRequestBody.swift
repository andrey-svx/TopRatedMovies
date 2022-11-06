//
//  CreateSessionRequestBody.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation

struct CreateSessionRequestBody: Encodable {
    
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        
        case accessToken = "access_token"
    }
}
