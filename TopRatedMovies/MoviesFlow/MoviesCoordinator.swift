//
//  MoviesCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit
import Swinject

final class MoviesCoordinator: Coordinator {
    
    private let resolver: Resolver
    
    init(_ navigationController: UINavigationController, resolver: Resolver) {
        self.resolver = resolver
        super.init(navigationController)
    }
    
    override func start() {
        let viewController = resolver.resolve(TopRatedMoviesViewController.self)!
        viewController.onCoordinated = { [weak self] signal in
            switch signal {
            case .empty:
                break
            case .details(let model):
                self?.showMovieDetailsScreen(model)
            }
        }
        navigationController.viewControllers = [viewController]
    }
    
    private func showMovieDetailsScreen(_ model: MovieDetailsModel) {
        let viewController = resolver.resolve(MovieDetailsViewController.self, argument: model)!
        viewController.onCoordinated = { [weak self] signal in
            switch signal {
            case .rate(let id):
                self?.showRateMovieScreen(id)
            case .error(let message):
                self?.navigationController.topViewController?.showError(
                    message
                )
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showRateMovieScreen(_ id: Int) {
        let viewController = resolver.resolve(RateMovieViewController.self, argument: id)!
        viewController.onCoordinated = { [weak viewController] signal in
            switch signal {
            case .success:
                viewController?.dismiss(animated: true, completion: nil)
            case .failure(let message):
                viewController?.showError(message) {
                    viewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
        navigationController.topViewController?.present(viewController, animated: true, completion: nil)
    }
}
