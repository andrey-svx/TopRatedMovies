//
//  UIRefreshControl+Rx.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIRefreshControl {
    
    var pull: ControlEvent<Void> {
        controlEvent(.valueChanged)
    }
}
