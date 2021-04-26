//
//  CustomWindow.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 26.04.2021.
//

import UIKit

class CustomWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        
        event.allTouches?.forEach({ (touch) in
            animate(in: touch.location(in: self))

            if touch.phase == .began {
                print("touch.phase == .began")
                print("\(touch.location(in: self))")
                
                
            }
            
            
            if touch.phase == .ended {
                print("touch.phase == .ended")
                print("\(touch.location(in: self))")
            }
        })
        super.sendEvent(event)
    }
    
    private let emitterCell: CAEmitterCell = {
        var emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "logo-rounded")?.cgImage
        emitterCell.scale = 0.02
        emitterCell.scaleRange = 0.1
        emitterCell.birthRate = 5
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
        layer1.position = location
        layer.addSublayer(layer1)
    }
}
