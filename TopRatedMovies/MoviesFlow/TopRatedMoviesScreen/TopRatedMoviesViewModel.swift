//
//  TopRatedMoviesViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit.UIImage
import RxSwift
import RxRelay
import RxCocoa
import Moya
import RxMoya

final class TopRatedMoviesViewModel {
    
    private let getTopRatedMovies: GetTopRatedMoviesUseCase
    private let moviesProvider = MoyaProvider<MoviesAPI>.instantiate()
    private let imagesProvider = MoyaProvider<ImagesAPI>.instantiate()
    
    private struct State {
        let models: [TopRatedMovieModel]
    }
    
    private let state = PublishRelay<State>()
    
    init(_ getTopRatedMovies: GetTopRatedMoviesUseCase) {
        self.getTopRatedMovies = getTopRatedMovies
    }
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let didPullCollectionView: Signal<Void>
        let didSelectItem: Signal<IndexPath>
    }
    
    struct Output {
        
        let isLoading: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let items: Driver<[TopRatedMoviesCell.Model]>
        let coordinate: Driver<TopRatedMoviesViewController.Output>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let didPullCollectionViewObservable = input.didPullCollectionView
            .asObservable()
        
        let itemsObservable = Observable
            .merge(viewWillAppearObservable, didPullCollectionViewObservable)
            .flatMap { [getTopRatedMovies] in getTopRatedMovies() }
            .do(onNext: { [weak self] in self?.state.accept(.init(models: $0)) })
            .map { domainModels -> [TopRatedMoviesCell.Model] in
                domainModels.map { $0.cellModel() }
            }
            .asObservable()
            .share()
        
        let isRefreshing = input.didPullCollectionView
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        let items = itemsObservable
            .asDriver(onErrorJustReturn: [])
        
        let didSelectItemObservable = input.didSelectItem
            .asObservable()
            .share()
        
        let movieDetailsObservable = didSelectItemObservable
            .map { $0.item }
            .withLatestFrom(state.asObservable()) { index, state in state.models[index] }
            .map { $0.id }
            .flatMapLatest { [moviesProvider, imagesProvider] id in
                moviesProvider.rx.request(.details(id), callbackQueue: .main)
                    .map(MovieDetailsResponse.self)
                    .flatMap { response in
                        imagesProvider.rx.request(.w500(response.posterPath), callbackQueue: .main)
                            .mapImage()
                            .map { image in (response, image) }
                    }
            }
            .share()
        
        let isLoading = Observable
            .merge(
                viewWillAppearObservable.map { _ in true },
                didSelectItemObservable.map { _ in true },
                itemsObservable.map { _ in false },
                movieDetailsObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let coordinate = movieDetailsObservable
            .map { _ in TopRatedMoviesViewController.Output.details }
            .asDriver(onErrorJustReturn: .empty)
        
        return Output(
            isLoading: isLoading,
            isRefreshing: isRefreshing,
            items: items,
            coordinate: coordinate
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
