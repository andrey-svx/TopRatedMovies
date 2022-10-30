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
        navigationController.isNavigationBarHidden = true
        super.init(navigationController)
    }
    
    override func start() {
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        let viewController = ViewController()
        self.navigationController.viewControllers = [viewController]
    }
}
