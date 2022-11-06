//
//  DashboardCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import Swinject

final class DashboardCoordinator: Coordinator {
    
    private let resolver: Resolver
    
    init(_ navigationController: UINavigationController, resolver: Resolver) {
        self.resolver = resolver
        super.init(navigationController)
    }
    
    override func start() {
        let viewController = UITabBarController()
        navigationController.viewControllers = [viewController]
        
        let moviesNavigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "tv"),
            tag: 0
        )
        moviesNavigationController.tabBarItem = tabBarItem
        let moviesCoordinator = resolver.resolve(
            MoviesCoordinator.self,
            argument: moviesNavigationController
        )!
        retain(moviesCoordinator)
        
        viewController.viewControllers = [
            moviesCoordinator.navigationController
        ]
        
        moviesCoordinator.start()
    }
}
