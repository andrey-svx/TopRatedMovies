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
    
    private let moviesProvider: MoyaProvider<MoviesAPI> = .init()
    
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
            .flatMap { [moviesProvider] in
                moviesProvider.rx.request(.topRated, callbackQueue: .main)
                    .map(TopRatedMoviesResponse.self)
                    .map { $0.results }
            }
            .map { $0.sorted(by: { $0.popularity > $1.popularity }) }
            .map { results -> [TopRatedMoviesCell.Model] in
                results.map {
                    .init(
                        image: UIImage(named: "dark-knight"),
                        name: $0.title,
                        year: $0.releaseDate,
                        rating: Int($0.popularity.rounded())
                    )
                }
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
