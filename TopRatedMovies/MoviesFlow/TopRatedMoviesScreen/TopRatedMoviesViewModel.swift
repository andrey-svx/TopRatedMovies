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
    private let getMovieDetails: GetMovieDetailsUseCase
    
    private struct State {
        let models: [TopRatedMovieModel]
    }
    
    private let stateRelay = PublishRelay<State>()
    
    init(
        _ moviesProvider: MoyaProvider<MoviesAPI>,
        _ imagesProvider: MoyaProvider<ImagesAPI>
    ) {
        self.getTopRatedMovies = .init(moviesProvider, imagesProvider)
        self.getMovieDetails = .init(moviesProvider, imagesProvider)
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
        
        let viewWillAppearFirstTimeObservable = input.viewWillAppear
            .asObservable()
            .take(1)
            .share()
        
        let didPullCollectionViewObservable = input.didPullCollectionView
            .asObservable()
        
        let itemsObservable = Observable.merge(
                viewWillAppearFirstTimeObservable,
                didPullCollectionViewObservable
            )
            .flatMap { [getTopRatedMovies] in getTopRatedMovies() }
            .do(onNext: { [weak self] in self?.stateRelay.accept(.init(models: $0)) })
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
            .withLatestFrom(stateRelay.asObservable()) { index, state in state.models[index] }
            .map { $0.id }
            .flatMapLatest { [getMovieDetails] id in getMovieDetails(id: id) }
            .compactMap { $0 }
            .share()
        
        let isLoading = Observable
            .merge(
                viewWillAppearFirstTimeObservable.map { _ in true },
                didSelectItemObservable.map { _ in true },
                itemsObservable.map { _ in false },
                movieDetailsObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let coordinate = movieDetailsObservable
            .map { TopRatedMoviesViewController.Output.details($0) }
            .asDriver(onErrorJustReturn: TopRatedMoviesViewController.Output.empty)
        
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
