//
//  MoviesCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit


final class MoviesCoordinator: Coordinator {
    
    override func start() {
        let viewModel = TopRatedMoviesViewModel()
        let topRatedMoviesViewController = TopRatedMoviesViewController(viewModel: viewModel)
        navigationController.viewControllers = [topRatedMoviesViewController]
    }
}
