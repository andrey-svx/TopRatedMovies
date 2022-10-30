//
//  Coordinator.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 30.10.2022.
//

import UIKit.UINavigationController

protocol Completable {
    
    associatedtype T
    
    var onComplete: ((T) -> Void)? { get set }
}

open class Coordinator: NSObject {
        
    let navigationController: UINavigationController
    
    var id: Int { hashValue }
    
    var childCoordinators: [Int: Coordinator] = [:]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func retain(_ coordinator: Coordinator) {
        childCoordinators[coordinator.id] = coordinator
    }

    func release(_ coordinator: Coordinator) {
        childCoordinators[coordinator.id] = nil
    }

    func releaseAll() {
        childCoordinators.removeAll()
    }
    
    func start() { }
}
