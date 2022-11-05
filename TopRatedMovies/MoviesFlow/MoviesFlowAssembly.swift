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
        
        container.register(TopRatedMoviesViewModel.self) { _ in
            TopRatedMoviesViewModel(.instantiate(), .instantiate())
        }
        
        container.register(MovieDetailsViewController.self) { (resolver, model: MovieDetailsModel) in
            let viewModel = resolver.resolve(MovieDetailsViewModel.self, argument: model)!
            return MovieDetailsViewController(viewModel: viewModel)
        }
        
        container.register(MovieDetailsViewModel.self) { (_, model: MovieDetailsModel) in
            MovieDetailsViewModel(model)
        }
    }
}
