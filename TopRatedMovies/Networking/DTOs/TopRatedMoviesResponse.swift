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
        
        let id: Int
        let popularity: Double
        let posterPath: String
        let releaseDate: String
        let title: String
        let voteAverage: Double
        
        private enum CodingKeys: String, CodingKey {
            
            case id
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case voteAverage = "vote_average"
        }
    }
}
