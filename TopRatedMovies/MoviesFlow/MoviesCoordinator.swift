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
        viewController.onCoordinated = { [weak self ]signal in
            switch signal {
            case .rate(let id):
                break
            case .error(let message):
                self?.showErrorMessage(message)
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Clear",
            style: .default,
            handler: nil
        )
        alertController.addAction(action)
        navigationController.topViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}
