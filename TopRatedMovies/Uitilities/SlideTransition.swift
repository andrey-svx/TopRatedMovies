//
//  SlideTransition.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit

final class SlideTransition: NSObject {
    
    var onDismissed: (() -> Void)?
    
    private var isPresenting = true
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(recognizer)
        return view
    }()
    
    private lazy var recognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return recognizer
    }()
}
    
extension SlideTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

extension SlideTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.20
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let animatedView = transitionContext.view(
            forKey: isPresenting ? .to : .from
        ) else {
            transitionContext.completeTransition(false)
            return
        }

        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView

        let bottomLeftCorner = CGPoint(x: .zero, y: containerView.bounds.height)
        let width = containerView.bounds.width
        let height = containerView.bounds.height / 4.0
        let size = CGSize(width: width, height: height)
            
        let offScreenFrame = CGRect(
            origin: bottomLeftCorner,
            size: size
        )
        let onScreenFrame = offScreenFrame.offsetBy(dx: .zero, dy: -size.height)

        let startFrame = isPresenting ? offScreenFrame : onScreenFrame
        let finalFrame = isPresenting ? onScreenFrame : offScreenFrame

        animatedView.frame = startFrame
        animatedView.layer.cornerRadius = 16.0
        animatedView.clipsToBounds = true
        
        if isPresenting {
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            containerView.addSubview(animatedView)
        }

        dimmingView.alpha = isPresenting ? 0.0 : 0.5


        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.dimmingView.alpha = self.isPresenting ? 0.5 : 0.0
                animatedView.frame = finalFrame
            },
            completion: { isCompleted in
                if !self.isPresenting {
                    self.dimmingView.removeFromSuperview()
                    animatedView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
            }
        )
    }
    
    @objc private func handleTap() {
        onDismissed?()
    }
}
