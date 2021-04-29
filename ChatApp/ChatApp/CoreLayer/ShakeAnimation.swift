//
//  ShakeAnimation.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 28.04.2021.
//

import UIKit

class ShakeAnimation: NSObject, CAAnimationDelegate {
    private let view: UIView
    private var startPosition: CGPoint = .zero
    
    public var isAnimating: Bool
    
    init(_ view: UIView) {
        self.view = view
        self.isAnimating = false
    }
    
    func animateStart() {
        startPosition = view.layer.position
        isAnimating = true
        
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    
        let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnim.values = [
            0,
            -CGFloat(Double.pi / 10),
            0,
            CGFloat(Double.pi / 10),
            0
        ]
        
        let posAnim = CAKeyframeAnimation(keyPath: "position")
        
        posAnim.values = [
            startPosition,
            CGPoint(x: startPosition.x, y: startPosition.y - 5),
            CGPoint(x: startPosition.x, y: startPosition.y + 5),
            CGPoint(x: startPosition.x + 5, y: startPosition.y),
            CGPoint(x: startPosition.x - 5, y: startPosition.y)
        ]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.animations = [rotationAnim, posAnim]
        view.layer.add(group, forKey: "shakeAnimation")
    }
    
    func animateStop() {
        isAnimating = false
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = view.layer.presentation()?.value(forKey: "transform.rotation.z")
        rotationAnim.toValue = 0
        
        let posAnim = CABasicAnimation(keyPath: "position")
        posAnim.fromValue = view.layer.presentation()?.value(forKey: "position")
        posAnim.toValue = startPosition
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.animations = [rotationAnim, posAnim]
        group.delegate = self
        
        view.layer.add(group, forKey: "shakeAnimation")
    }
}
