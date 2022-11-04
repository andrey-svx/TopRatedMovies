//
//  MovieDetailsResponse.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation

struct MovieDetailsResponse: Decodable {
    
    let id: Int
    let overview: String
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
