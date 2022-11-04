//
//  AppFlowAssembly.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import Swinject
import UIKit.UIWindow

final class AppFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AppCoordinator.self) { (resolver, window: UIWindow?) in
            AppCoordinator(window, resolver: resolver)
        }
    }
}
