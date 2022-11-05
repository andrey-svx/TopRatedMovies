//
//  MovieDetailsViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import UIKit.UIImage
import RxSwift
import RxRelay
import RxCocoa

final class MovieDetailsViewModel {
    
    private let stateRelay = PublishRelay<MovieDetailsModel>()
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        
//        let isLoading: Driver<Bool>
        let poster: Driver<UIImage?>
        let title: Driver<String?>
        let year: Driver<String?>
        let overview: Driver<String?>
//        let coordinate: Driver<TopRatedMoviesViewController.Output>
    }
    
    init(_ model: MovieDetailsModel) {
        self.stateRelay.accept(model)
    }
    
    func transform(_ input: Input) -> Output {
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let poster = viewWillAppearObservable
            .withLatestFrom(stateRelay.asObservable()) { (_, state) in state.poster }
            .asDriver(onErrorJustReturn: nil)
        
        let title = viewWillAppearObservable
            .withLatestFrom(stateRelay.asObservable()) { (_, state) in state.title }
            .asDriver(onErrorJustReturn: nil)
        
        let year = viewWillAppearObservable
            .withLatestFrom(stateRelay.asObservable()) { (_, state) in state.releaseDate }
            .map { Calendar.current.component(.year, from: $0) }
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: nil)
        
        let overview = viewWillAppearObservable
            .withLatestFrom(stateRelay.asObservable()) { (_, state) in state.overview }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            poster: poster,
            title: title,
            year: year,
            overview: overview
        )
    }
}
