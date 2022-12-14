//
//  TopRatedMovieModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 04.11.2022.
//

import Foundation
import UIKit.UIImage

struct TopRatedMovieModel {
    
    let id: Int
    let poster: UIImage
    let releaseDate: Date
    let title: String
    let percentAverage: Int
}
