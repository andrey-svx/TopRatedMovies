//
//  MoviesFlowAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import Swinject
import UIKit.UINavigationController

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
            TopRatedMoviesViewModel()
        }
    }
}
