//
//  AppCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private var window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        
        let navigationController = UINavigationController()
        super.init(navigationController)
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let moviesCoordinator = MoviesCoordinator(navigationController)
        retain(moviesCoordinator)
        moviesCoordinator.start()
    }
}
