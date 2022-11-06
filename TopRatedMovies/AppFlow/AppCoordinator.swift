//
//  AppCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit
import Swinject

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow?
    private let resolver: Resolver
    
    init(_ window: UIWindow?, resolver: Resolver) {
        self.window = window
        self.resolver = resolver
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        super.init(navigationController)
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let dashboardCoorinator = resolver.resolve(
            DashboardCoordinator.self,
            argument: navigationController
        )!
        retain(dashboardCoorinator)
        dashboardCoorinator.start()
    }
}
