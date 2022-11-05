//
//  MovieDetailsModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import UIKit.UIImage

struct MovieDetailsModel {
    
    let id: Int
    let overview: String
    let poster: UIImage
    let releaseDate: Date
    let title: String
    let percentAverage: Int
}
