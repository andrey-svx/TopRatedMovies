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
        super.init(navigationController)
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let moviesCoordinator = resolver.resolve(
            MoviesCoordinator.self,
            argument: navigationController
        )!
        retain(moviesCoordinator)
        moviesCoordinator.start()
    }
}
