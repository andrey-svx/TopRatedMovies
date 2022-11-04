//
//  GetTopRatedMoviesUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 04.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct GetTopRatedMoviesUseCase {

    private let moviesProvider: MoyaProvider<MoviesAPI>
    private let imagesProvider: MoyaProvider<ImagesAPI>
    
    init(
        _ moviesProvider: MoyaProvider<MoviesAPI>,
        _ imagesProvider: MoyaProvider<ImagesAPI>
    ) {
        self.moviesProvider = moviesProvider
        self.imagesProvider = imagesProvider
    }
    
//    func callAsFunction() -> Single<[(TopRatedMoviesResponse.Result, Image)]> {
    func callAsFunction() -> Single<[TopRatedMovieModel]> {
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
            .map { pairs -> [TopRatedMovieModel] in
                pairs.compactMap { (result, image) in result.domainModel(image) }
            }
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

extension TopRatedMoviesResponse.Result {
    
    func domainModel(_ image: Image) -> TopRatedMovieModel? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: releaseDate) else {
            return nil
        }
        
        let percentVerage = Int(voteAverage * 10)
        return .init(
            id: id,
            poster: image,
            releaseDate: date,
            title: title,
            percentAverage: percentVerage
        )
    }
}
