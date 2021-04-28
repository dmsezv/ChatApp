//
//  CustomWindow.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 26.04.2021.
//

import UIKit

class CustomWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        event.allTouches?.forEach({ (touch) in
            animate(in: touch.location(in: self))

            if touch.phase == .began {
                print("touch.phase == .began")
                print("\(touch.location(in: self))")
                //animate(in: touch.location(in: self))
                
                
            }
            
            
            if touch.phase == .ended {
                print("touch.phase == .ended")
                print("\(touch.location(in: self))")
                stop()
            }
        })
        
    }
    
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
     
//    let image = UIImage(named: "logo")!.cgImage
//
//    var emitterLayer: CAEmitterLayer {
//        let emitterLayer = CAEmitterLayer()
//        emitterLayer.emitterPosition = CGPoint(x: 512, y: 512)
//        emitterLayer.emitterCells = [fireworkCell]
//        return emitterLayer
//    }
//
//    var fireworkCell: CAEmitterCell {
//        let fireworkCell = CAEmitterCell()
//        fireworkCell.color = UIColor.red.cgColor
//        fireworkCell.birthRate = 3
//        fireworkCell.lifetime = 10
//        fireworkCell.velocity = 100
//        fireworkCell.scale = 0.05
//        fireworkCell.emissionLongitude = -CGFloat.pi * 0.5
//        fireworkCell.emissionRange = -CGFloat.pi * 0.25
//        fireworkCell.contents = image
//        fireworkCell.emitterCells = [trailCell]
//        return fireworkCell
//    }
//
//    var trailCell: CAEmitterCell {
//        let trailCell = CAEmitterCell()
//        trailCell.yAcceleration = 20
//        trailCell.birthRate = 10
//        trailCell.lifetime = 3
//        trailCell.contents = image
//        return trailCell
//    }
        
    
    
    
    func animate(in location: CGPoint) {
        let layer1 = emitterLayer
        layer1.name = "emitterLayer"
        layer1.position = location
        //emitterLayer.birthRate = 5
        //emitterLayer.position = location
        layer.addSublayer(layer1)
    }
    
    func stop() {
        layer.sublayers?.forEach({ (sub) in
            if sub.name == "emitterLayer" {
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
