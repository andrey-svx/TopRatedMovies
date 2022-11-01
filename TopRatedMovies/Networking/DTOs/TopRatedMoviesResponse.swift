//
//  TopRatedMoviesResponse.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 02.11.2022.
//

import Foundation

struct TopRatedMoviesResponse: Decodable {
    
    let results: [Result]
    
    struct Result: Decodable {
        
        let popularity: Double
        let posterPath: String
        let releaseDate: String
        let title: String
        
        private enum CodingKeys: String, CodingKey {
            
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
        }
    }
}
