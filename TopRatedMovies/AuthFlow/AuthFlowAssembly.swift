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
        
        container.register(AccountInfoViewController.self) { resolver in
            let viewModel = resolver.resolve(AccountInfoViewModel.self)!
            return AccountInfoViewController(viewModel: viewModel)
        }
        
        container.register(AccountInfoViewModel.self) { resolver in
            let sessionProvider = SessionProvider()
            let authProvider = resolver.resolve(MoyaProvider<AuthAPI>.self)!
            return AccountInfoViewModel(sessionProvider, authProvider)
        }
    }
}
