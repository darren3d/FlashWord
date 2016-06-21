//
//  DYSatelliteLoader.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYSatelliteLoader: DYLoader {
    let duration: CFTimeInterval = 1.9
    let distanceIncrement: CGFloat = 25
    let satelliteIncrement: CGFloat = 5
    let coreIncrement: CGFloat = 25
    
    var satelliteSize: CGFloat = 0
    var coreSize: CGFloat = 0
    
    func setUpAnimationInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        satelliteSize = size.width / 15 + satelliteIncrement
        coreSize = size.width / 5 + coreIncrement
        
        ring1InLayer(layer, size: size, color: color)
        ring2InLayer(layer, size: size, color: color)
        coreInLayer(layer, size: size, color: color)
        satelliteInLayer(layer, size: size, color: color)
    }
    
    func ring1InLayer(layer: CALayer, size: CGSize, color: UIColor) {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.45, 0.45, 1]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        scaleAnimation.values = [0, 0, 1.3, 2]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        
        opacityAnimation.keyTimes = [0, 0.45, 1]
        scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), timingFunction]
        opacityAnimation.values = [0.8, 0.8, 0]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.removedOnCompletion = false
        
        // Draw circle
        let circle = NVActivityIndicatorShape.Circle.createLayerWith(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRectMake((layer.bounds.size.width - coreSize) / 2,
                               (layer.bounds.size.height - coreSize) / 2,
                               coreSize,
                               coreSize)
        
        circle.frame = frame
        circle.addAnimation(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func ring2InLayer(layer: CALayer, size: CGSize, color: UIColor) {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.55, 0.55, 1]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        scaleAnimation.values = [0, 0, 1.3, 2.1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        
        opacityAnimation.keyTimes = [0, 0.55, 0.65, 1]
        scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), timingFunction]
        opacityAnimation.values = [0.7, 0.7, 0, 0]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.removedOnCompletion = false
        
        // Draw circle
        let circle = NVActivityIndicatorShape.Circle.createLayerWith(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRectMake((layer.bounds.size.width - coreSize) / 2,
                               (layer.bounds.size.height - coreSize) / 2,
                               coreSize,
                               coreSize)
        
        circle.frame = frame
        circle.addAnimation(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func coreInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        let inTimingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0, 1, 0.5)
        let outTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0.7, 0.5, 1)
        let standByTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.45, 0.55, 1]
        scaleAnimation.timingFunctions = [inTimingFunction, standByTimingFunction, outTimingFunction];
        scaleAnimation.values = [1, 1.3, 1.3, 1]
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.removedOnCompletion = false
        
        // Draw circle
        let circle = NVActivityIndicatorShape.Circle.createLayerWith(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRectMake((layer.bounds.size.width - coreSize) / 2,
                               (layer.bounds.size.height - coreSize) / 2,
                               coreSize,
                               coreSize)
        
        circle.frame = frame
        circle.addAnimation(scaleAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func satelliteInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "position")
        
        rotateAnimation.path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(layer.bounds), y: CGRectGetMidY(layer.bounds)), radius: (size.width - satelliteSize) / 2 + distanceIncrement, startAngle: 3 * CGFloat(M_PI) * 0.5, endAngle: 3 * CGFloat(M_PI) * 0.5 + 4 * CGFloat(M_PI), clockwise: true).CGPath
        rotateAnimation.duration = duration * 2
        rotateAnimation.repeatCount = HUGE
        rotateAnimation.removedOnCompletion = false
        
        // Draw circle
        let circle = NVActivityIndicatorShape.Circle.createLayerWith(size: CGSize(width: satelliteSize, height: satelliteSize), color: color)
        let frame = CGRectMake(0, 0, satelliteSize, satelliteSize)
        
        circle.frame = frame
        circle.addAnimation(rotateAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
