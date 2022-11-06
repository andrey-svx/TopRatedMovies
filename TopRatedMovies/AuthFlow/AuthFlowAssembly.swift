//
//  AuthFlowAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Swinject
import UIKit.UINavigationController
import Moya

final class AuthFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthCoordinator.self) { (resolver, navigationController: UINavigationController) in
            AuthCoordinator(navigationController, resolver: resolver)
        }
    }
}
