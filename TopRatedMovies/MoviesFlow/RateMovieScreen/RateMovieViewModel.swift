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
        
        let ratingSelected: Signal<Float>
        let submitTapped: Signal<Void>
    }
    
    struct Output {

        let rating: Driver<String?>
        let isLoading: Driver<Bool>
        let coordinate: Driver<RateMovieViewController.Output>
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
        
        let submitTappedObservable = Observable
            .combineLatest(
                input.submitTapped.asObservable(),
                idRelay.asObservable(),
                ratingRelay.asObservable()
            )
            .share()
        
        let isLoading = Observable.merge(submitTappedObservable.map { _, _, _ in true })
            .asDriver(onErrorJustReturn: false)
        
        let coordinate = submitTappedObservable
            .flatMap { [moviesProvider] (_, id, rating) in
                moviesProvider.rx.request(.rate(id: id, rating: rating), callbackQueue: .main)
                    .map(Bool.self, atKeyPath: "success")
            }
            .map { success -> RateMovieViewController.Output in
                success ? .success : .failure("Something went wrong")
            }
            .asDriver(onErrorJustReturn: .failure("Something went wrong"))
        
        return Output(
            rating: rating,
            isLoading: isLoading,
            coordinate: coordinate
        )
    }
}
