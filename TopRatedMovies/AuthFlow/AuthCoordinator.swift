//
//  AuthCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import Swinject

final class AuthCoordinator: Coordinator {
    
    private let resolver: Resolver
    
    init(_ navigationController: UINavigationController, resolver: Resolver) {
        self.resolver = resolver
        super.init(navigationController)
    }
    
    override func start() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = "Authorization"
        navigationController.viewControllers = [viewController]
    }
}
