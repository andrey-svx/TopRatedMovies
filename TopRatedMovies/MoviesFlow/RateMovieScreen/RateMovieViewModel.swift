//
//  RateMovieViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Moya
import RxMoya

final class RateMovieViewModel {
    
    private let idRelay = ReplayRelay<Int>.create(bufferSize: 1)
    private let ratingRelay = PublishRelay<Double>()
    
    private let moviesProvider: MoyaProvider<MoviesAPI>
    
    init(_ id: Int, _ moviesProvider: MoyaProvider<MoviesAPI>) {
        self.idRelay.accept(id)
        self.moviesProvider = moviesProvider
    }
}
