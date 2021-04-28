//
//  ProfileViewCotntrollerTransition.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 28.04.2021.
//

import UIKit

class ProfileViewControllerTransition: NSObject {
    
    // MARK: - Constants
    
    let animationDelay: TimeInterval = 0.0
    let animationDuration: TimeInterval = 0.6
    let usingSpringWithDamping: CGFloat = 0.49
    let initialSpringVelocity: CGFloat = 0.81
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
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = offScreenRight
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: animationDelay,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: []) {
            fromView.transform = offScreenLeft
            toView.transform = .identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}

extension ProfileViewControllerTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}
