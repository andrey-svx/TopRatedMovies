//
//  SceneDelegate.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 30.10.2022.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let assembler = Assembler([
        AppFlowAssembly(),
        DashboardFlowAssembly(),
        MoviesFlowAssembly(),
        AuthFlowAssembly()
    ])
    
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        appCoordinator = assembler.resolver.resolve(
            AppCoordinator.self,
            argument: window
        )
        appCoordinator?.start()
    }
}

