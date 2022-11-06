//
//  DashboardFlowAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit.UINavigationController
import Swinject

final class DashboardFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(DashboardCoordinator.self) { (resolver, navigationController: UINavigationController) in
            DashboardCoordinator(navigationController, resolver: resolver)
        }
    }
}
