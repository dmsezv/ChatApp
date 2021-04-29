//
//  ProfileViewCotntrollerTransition.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 28.04.2021.
//

import UIKit

class ProfileViewControllerTransition: NSObject {
    
    var isPresenting = true
    
    // MARK: - Constants
    
    let animationDelay: TimeInterval = 0.0
    let animationDuration: TimeInterval = 1.0
    let usingSpringWithDamping: CGFloat = 0.49
    let initialSpringVelocity: CGFloat = 0.81
    let initialPosition = CGPoint(x: 0, y: 0)
}

extension ProfileViewControllerTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else { return }
        
        toView.transform = rotatingView()
        
        toView.layer.anchorPoint = initialPosition
        fromView.layer.anchorPoint = initialPosition
        
        toView.layer.position = initialPosition
        fromView.layer.position = initialPosition
        
        container.addSubview(toView)
        //container.addSubview(fromView)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: animationDelay,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: []) {
            //fromView.transform = self.rotatingView()
            toView.transform = .identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func rotatingView() -> CGAffineTransform {
        
        let offScreenRotateIn = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        let offScreenRotateOut = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        return isPresenting ? offScreenRotateIn : offScreenRotateOut
    }
}

extension ProfileViewControllerTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
