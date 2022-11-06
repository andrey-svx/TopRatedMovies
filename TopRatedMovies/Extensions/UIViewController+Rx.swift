//
//  UIViewController+Rx.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { _ in () }
        return ControlEvent(events: source)
    }
    
    var isLoading: Binder<Bool> {
        Binder(self.base) { viewController, value in
            value
            ? viewController.startBusyAnimation()
            : viewController.stopBusyAnimation()
        }
    }
}

fileprivate extension UIViewController {
    
    func startBusyAnimation() {
        let fader = UIView(frame: view.bounds)
        fader.tag = 1000
        fader.backgroundColor = .black
        fader.alpha = 0.15
        view.addSubview(fader)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tag = 1001
        spinner.startAnimating()
        let x = view.bounds.size.width / 2.0
        let y = view.bounds.size.height / 2.0
        spinner.center = CGPoint(x: x, y: y)
        view.addSubview(spinner)
    }

    func stopBusyAnimation() {
        view.subviews
            .filter { $0.tag == 1000 || $0.tag == 1001 }
            .forEach { $0.removeFromSuperview() }
    }
}
