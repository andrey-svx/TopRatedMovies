//
//  MoviesFlowAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import Swinject
import UIKit.UINavigationController
import Moya

final class MoviesFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoviesCoordinator.self) { (resolver, navigationController: UINavigationController) in
            MoviesCoordinator(navigationController, resolver: resolver)
        }
        
        container.register(TopRatedMoviesViewController.self) { resolver in
            let viewModel = resolver.resolve(TopRatedMoviesViewModel.self)!
            return TopRatedMoviesViewController(viewModel: viewModel)
        }
        
        container.register(TopRatedMoviesViewModel.self) { resolver in
            let moviesProvider = resolver.resolve(MoyaProvider<MoviesAPI>.self)!
            let imagesProvider = resolver.resolve(MoyaProvider<ImagesAPI>.self)!
            return TopRatedMoviesViewModel(
                moviesProvider,
                imagesProvider
            )
        }
        
        container.register(MovieDetailsViewController.self) { (resolver, model: MovieDetailsModel) in
            let viewModel = resolver.resolve(MovieDetailsViewModel.self, argument: model)!
            return MovieDetailsViewController(viewModel: viewModel)
        }
        
        container.register(MovieDetailsViewModel.self) { (_, model: MovieDetailsModel) in
            MovieDetailsViewModel(model)
        }
        
        container.register(RateMovieViewController.self) { (resolver, id: Int) in
            let viewModel = resolver.resolve(RateMovieViewModel.self, argument: id)!
            return RateMovieViewController(viewModel: viewModel)
        }
        
        container.register(RateMovieViewModel.self) { (resolver, id: Int) in
            let moviesProvider = resolver.resolve(MoyaProvider<MoviesAPI>.self)!
            return RateMovieViewModel(id, moviesProvider)
        }
    }
}
