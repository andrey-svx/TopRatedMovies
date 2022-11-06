//
//  AuthCoordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import SafariServices
import Swinject

final class AuthCoordinator: Coordinator {
    
    private let resolver: Resolver
    
    init(_ navigationController: UINavigationController, resolver: Resolver) {
        self.resolver = resolver
        super.init(navigationController)
    }
    
    override func start() {
        let viewController = resolver.resolve(AccountInfoViewController.self)!
        viewController.onCoordinated = { [weak self, weak viewController] signal in
            switch signal {
            case .approve(let token):
                self?.showApproveTokenScreen(token)
            case .failure(let message):
                viewController?.showError(message)
            }
        }
        navigationController.viewControllers = [viewController]
    }
    
    private func showApproveTokenScreen(_ token: String) {
        let urlString = "https://www.themoviedb.org/auth/access?request_token=\(token)"
        let url = URL(string: urlString)!
        let viewController = SFSafariViewController(url: url)
        navigationController.topViewController?.present(
            viewController,
            animated: true,
            completion: nil
        )
    }
}
