//
//  RateMovieUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct RateMovieUseCase {
        
    private let provider: MoyaProvider<MoviesAPI>
    
    init(_ provider: MoyaProvider<MoviesAPI>) {
        self.provider = provider
    }
    
    func callAsFunction(id: Int, rating: Float) -> Single<Bool> {
        provider.rx.request(.rate(id: id, rating: rating), callbackQueue: .main)
            .map(Bool.self, atKeyPath: "success")
    }
}
