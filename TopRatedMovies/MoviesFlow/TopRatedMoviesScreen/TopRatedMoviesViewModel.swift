//
//  TopRatedMoviesViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit.UIImage
import RxSwift
import RxCocoa
import Moya
import RxMoya

final class TopRatedMoviesViewModel {
    
    private let getTopRatedMovies: GetTopRatedMoviesUseCase
    
    init(_ getTopRatedMovies: GetTopRatedMoviesUseCase) {
        self.getTopRatedMovies = getTopRatedMovies
    }
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let didPullCollectionView: Signal<Void>
    }
    
    struct Output {
        
        let isLoading: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let items: Driver<[TopRatedMoviesCell.Model]>
    }
    
    func transform(_ input: Input) -> Output {
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let didPullCollectionViewObservable = input.didPullCollectionView
            .asObservable()
        
        let itemsObservable = Observable
            .merge(viewWillAppearObservable, didPullCollectionViewObservable)
            .flatMap { [getTopRatedMovies] in getTopRatedMovies() }
            .map { domainModels -> [TopRatedMoviesCell.Model] in
                domainModels.map { $0.cellModel() }
            }
            .asObservable()
            .share()
        
        let isLoading = Observable
            .merge(
                viewWillAppearObservable.map { _ in true },
                itemsObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let isRefreshing = input.didPullCollectionView
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        let items = itemsObservable
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            isLoading: isLoading,
            isRefreshing: isRefreshing,
            items: items
        )
    }
}

fileprivate extension TopRatedMovieModel {
    
    func cellModel() -> TopRatedMoviesCell.Model {
        .init(
            image: poster,
            title: title,
            year: String(Calendar.current.component(.year, from: releaseDate)),
            rating: percentAverage
        )
    }
}
