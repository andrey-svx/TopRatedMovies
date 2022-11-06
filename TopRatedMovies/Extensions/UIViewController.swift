//
//  UIViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit

extension UIViewController {
    
    func showError(_ message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Clear",
            style: .default,
            handler: nil
        )
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
