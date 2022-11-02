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
    private let imagesProvider: MoyaProvider<ImagesAPI> = .init()
    
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
            .flatMap { [moviesProvider, imagesProvider] in
                moviesProvider.rx.request(.topRated, callbackQueue: .main)
                    .map(TopRatedMoviesResponse.self)
                    .map { $0.results }
                    .map { results in results.sorted(by: { $0.popularity > $1.popularity }) }
                    .flatMap { results -> Single<[(TopRatedMoviesResponse.Result, Image)]> in
                        Observable.from(results.map(\.posterPath))
                            .flatMap { path in
                                imagesProvider.rx.request(.w200(path), callbackQueue: .main)
                                    .mapImage()
                                    .map { image in (image, path) }
                            }
                            .toArray()
                            .map { imagePairs -> [(TopRatedMoviesResponse.Result, Image)] in
                                let resultPairs = results.map { result in (result, result.posterPath) }
                                return matching(resultPairs, imagePairs)
                            }
                    }
            }
            .map { pairs -> [TopRatedMoviesCell.Model] in
                pairs.map { (result, image) in
                    .init(
                        image: image,
                        name: result.title,
                        year: result.releaseDate,
                        rating: Int(result.popularity)
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
    
fileprivate func matching<A, B, H: Hashable>(_ a: [(A, H)], _ b: [(B, H)]) -> [(A, B)] {
    
    guard a.count == b.count else {
        fatalError("Arrays have different length")
    }
    
    var result: [(A, B)] = []
    
    for (elementA, hash) in a {
        guard let elementB = b.first(where: { $0.1 == hash })?.0 else {
            fatalError("Could not find element of array a in array b")
        }
        result.append((elementA, elementB))
    }
    
    return result
}
