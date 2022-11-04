//
//  UICollectionView.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import UIKit

protocol ReuseIdentifiable where Self: UICollectionViewCell {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String { "\(Self.self)" }
}

extension UICollectionView {
    
    func register<T: ReuseIdentifiable>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: ReuseIdentifiable>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
