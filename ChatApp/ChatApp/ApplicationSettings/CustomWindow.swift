//
//  CustomWindow.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 26.04.2021.
//

import UIKit

class CustomWindow: UIWindow {
    private let emmitetLayerName = "emitterLayer"
    
    private let emitterCell: CAEmitterCell = {
        var emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "logo-rounded")?.cgImage
        emitterCell.scale = 0.02
        emitterCell.scaleRange = 0.07
        emitterCell.birthRate = 10
        emitterCell.lifetime = 2
        emitterCell.velocity = -10
        emitterCell.velocityRange = 30
        emitterCell.emissionRange = CGFloat.pi * 2
        emitterCell.spin = -3.0
        emitterCell.spinRange = 3.0
        return emitterCell
    }()
    
    private var emitterLayer: CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        event.allTouches?.forEach({ (touch) in
            animate(in: touch.location(in: self))

            if touch.phase == .ended {
                stopAnimate()
            }
        })
    }
        
    func animate(in location: CGPoint) {
        let animateLayer = emitterLayer
        animateLayer.name = emmitetLayerName
        animateLayer.position = location
        layer.addSublayer(animateLayer)
    }
    
    func stopAnimate() {
        layer.sublayers?.forEach({ (sub) in
            if sub.name == emmitetLayerName {
                CATransaction.begin()
                
                    CATransaction.setAnimationDuration(2)
                    CATransaction.setCompletionBlock {
                        sub.removeFromSuperlayer()
                    }
                    sub.opacity = 0
                    
                    CATransaction.begin()
                    
                        CATransaction.setAnimationDuration(1)
                        sub.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                    
                    CATransaction.commit()
                CATransaction.commit()
                return
            }
        })
    }
}
