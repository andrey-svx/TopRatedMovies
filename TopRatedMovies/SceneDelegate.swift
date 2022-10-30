//
//  SceneDelegate.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 30.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)
        self.appCoordinator = AppCoordinator(window)
        self.appCoordinator?.start()
    }
}

