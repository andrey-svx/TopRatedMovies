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
        
        container.register(AccountInfoViewModel.self) { _ in
            let sessionProvider = SessionProvider()
            let authProvider = MoyaProvider<AuthAPI>.instantiate { target in
                switch target {
                case .createRequestToken, .createAccessToken:
                    return APIConfigProvider.shared.initialAccessToken
                }
            }
            return AccountInfoViewModel(sessionProvider, authProvider)
        }
    }
}
