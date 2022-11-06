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
    private let ratingRelay = ReplayRelay<Float>.create(bufferSize: 1)
    
    private let rateMovie: RateMovieUseCase
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let ratingSelected: Signal<Float>
        let submitTapped: Signal<Void>
    }
    
    struct Output {

        let ratingValue: Driver<Float>
        let ratingLabel: Driver<String?>
        let isLoading: Driver<Bool>
        let coordinate: Driver<RateMovieViewController.Output>
    }
    
    init(_ id: Int, _ moviesProvider: MoyaProvider<MoviesAPI>) {
        self.idRelay.accept(id)
        self.ratingRelay.accept(0.0)
        self.rateMovie = .init(moviesProvider)
    }
    
    func transform(_ input: Input) -> Output {
        
        let ratingValue = input.viewWillAppear
            .asObservable()
            .withLatestFrom(ratingRelay.asObservable()) { (_, rating) in rating }
            .asDriver(onErrorJustReturn: 0.0)
        
        let ratingLabel = input.ratingSelected
            .map { $0 / 10.0 }
            .do(onNext: { [weak self] in self?.ratingRelay.accept($0) })
            .map { Int($0 * 10.0) }
            .map { "\($0)%" }
            .asDriver(onErrorJustReturn: nil)
        
        let submitTappedObservable = Observable.combineLatest(
                input.submitTapped.asObservable(),
                idRelay.asObservable(),
                ratingRelay.asObservable()
            )
            .share()
        
        let coordinateObservable = submitTappedObservable
            .flatMap { [rateMovie] (_, id, rating) in
                rateMovie(id: id, rating: rating)
            }
            .map { success -> RateMovieViewController.Output in
                success ? .success : .failure("You need to get authorized to rate movie.")
            }
            .share()
                
        let isLoading = Observable.merge(
                submitTappedObservable.map { _, _, _ in true },
                coordinateObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let coordinate = coordinateObservable
            .asDriver(onErrorJustReturn: .failure("Something went wrong"))
        
        return Output(
            ratingValue: ratingValue,
            ratingLabel: ratingLabel,
            isLoading: isLoading,
            coordinate: coordinate
        )
    }
}
