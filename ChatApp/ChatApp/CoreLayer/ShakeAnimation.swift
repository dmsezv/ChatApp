//
//  ShakeAnimation.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 28.04.2021.
//

import UIKit

protocol ShakeAnimationProtocol {
    var isAnimating: Bool { get }
    
    func animateStart()
    func animateStop()
}
class ShakeAnimation: NSObject, CAAnimationDelegate, ShakeAnimationProtocol {
    public var isAnimating: Bool
    
    private let view: UIView
    private var startPosition: CGPoint = .zero
    
    private let animationGroupKey = "shakeAnimation"
    private let transformRotationKey = "transform.rotation"
    private let positionKeyPath = "position"
    
    init(_ view: UIView) {
        self.view = view
        self.isAnimating = false
    }
    
    func animateStart() {
        startPosition = view.layer.position
        isAnimating = true
        
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    
        let rotationAnim = CAKeyframeAnimation(keyPath: transformRotationKey)
        rotationAnim.values = [
            0,
            -CGFloat(Double.pi / 10),
            0,
            CGFloat(Double.pi / 10),
            0
        ]
        rotationAnim.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        ]
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.beginTime = .zero
        
        let posAnim = CAKeyframeAnimation(keyPath: positionKeyPath)
        posAnim.values = [
            startPosition,
            CGPoint(x: startPosition.x, y: startPosition.y - 5),
            CGPoint(x: startPosition.x, y: startPosition.y + 5),
            CGPoint(x: startPosition.x + 5, y: startPosition.y),
            CGPoint(x: startPosition.x - 5, y: startPosition.y)
        ]
        posAnim.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        ]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.animations = [rotationAnim, posAnim]
        
        view.layer.add(group, forKey: animationGroupKey)
    }
    
    func animateStop() {
        if !isAnimating { return }
        isAnimating = false

        let rotationAnim = CABasicAnimation(keyPath: transformRotationKey)
        rotationAnim.fromValue = view.layer.presentation()?.value(forKeyPath: transformRotationKey)
        rotationAnim.toValue = 0
        
        let posAnim = CABasicAnimation(keyPath: positionKeyPath)
        posAnim.fromValue = view.layer.presentation()?.value(forKeyPath: positionKeyPath)
        posAnim.toValue = startPosition
                
        let group = CAAnimationGroup()
        group.delegate = self
        group.duration = 0.3
        group.animations = [rotationAnim, posAnim]
        view.layer.add(group, forKey: animationGroupKey)
    }
}
