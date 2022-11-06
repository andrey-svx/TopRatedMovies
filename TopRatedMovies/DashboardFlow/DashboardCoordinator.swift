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
        viewController.viewControllers = [
            instantiateMoviesCoordinator(),
            instantiateAuthCoordinator()
        ].map { $0.navigationController }
        navigationController.viewControllers = [viewController]
        childCoordinators.forEach { _, coordinator in coordinator.start() }
    }
    
    private func instantiateMoviesCoordinator() -> MoviesCoordinator {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "tv"),
            tag: 0
        )
        navigationController.tabBarItem = tabBarItem
        let coordinator = resolver.resolve(MoviesCoordinator.self, argument: navigationController)!
        retain(coordinator)
        
        return coordinator
    }
    
    private func instantiateAuthCoordinator() -> AuthCoordinator {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: "Authorization",
            image: UIImage(systemName: "person"),
            tag: 0
        )
        navigationController.tabBarItem = tabBarItem
        let coordinator = resolver.resolve(AuthCoordinator.self, argument: navigationController)!
        retain(coordinator)
        
        return coordinator
    }
}
