//
//  GetMovieDetailsUseCase.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct GetMovieDetailsUseCase {

    private let moviesProvider: MoyaProvider<MoviesAPI>
    private let imagesProvider: MoyaProvider<ImagesAPI>
    
    init(
        _ moviesProvider: MoyaProvider<MoviesAPI>,
        _ imagesProvider: MoyaProvider<ImagesAPI>
    ) {
        self.moviesProvider = moviesProvider
        self.imagesProvider = imagesProvider
    }
    
    func callAsFunction(id: Int) -> Single<MovieDetailsModel?> {
        moviesProvider.rx.request(.details(id), callbackQueue: .main)
            .map(MovieDetailsResponse.self)
            .flatMap { [imagesProvider] response in
                imagesProvider.rx.request(.w500(response.posterPath), callbackQueue: .main)
                    .mapImage()
                    .map { image in (response, image) }
                    .map { (response, image) in response.domainModel(image) }
            }
            .catchAndReturn(nil)
    }
}

extension MovieDetailsResponse {
    
    func domainModel(_ image: Image) -> MovieDetailsModel? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: releaseDate) else {
            return nil
        }
        
        let percentAverage = Int((voteAverage * 10).rounded())
        return .init(
            id: id,
            overview: overview,
            poster: image,
            releaseDate: date,
            title: title,
            percentAverage: percentAverage
        )
    }
}
