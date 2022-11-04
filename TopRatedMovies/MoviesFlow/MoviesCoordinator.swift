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
                break
            }
        }
        navigationController.viewControllers = [viewController]
    }
}
