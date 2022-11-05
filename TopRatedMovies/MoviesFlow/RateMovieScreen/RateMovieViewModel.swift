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
    private let ratingRelay = PublishRelay<Float>()
    
    private let moviesProvider: MoyaProvider<MoviesAPI>
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let ratingSelected: Signal<Float>
        let submitTapped: Signal<Void>
    }
    
    struct Output {

        let rating: Driver<String?>
//        let coordinate: Driver<MovieDetailsViewController.Output>
    }
    
    init(_ id: Int, _ moviesProvider: MoyaProvider<MoviesAPI>) {
        self.idRelay.accept(id)
        self.moviesProvider = moviesProvider
    }
    
    func transform(_ input: Input) -> Output {
        
        let rating = input.ratingSelected
            .map { $0 / 10.0 }
            .do(onNext: { [weak self] in self?.ratingRelay.accept($0) })
            .map { Int($0 * 10.0) }
            .map { "\($0)%" }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            rating: rating
        )
    }
}
