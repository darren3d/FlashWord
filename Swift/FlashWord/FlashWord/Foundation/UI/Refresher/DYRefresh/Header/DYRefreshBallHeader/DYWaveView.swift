//
//  DYWaveView.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/20.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYWaveView: UIView {
    lazy var waveLayer:CAShapeLayer = {
        let layer = CAShapeLayer(layer: self.layer)
        layer.lineWidth = 0
        self.layer.addSublayer(layer)
        return layer
    }()
    var bounceDuration:CFTimeInterval = 0.2
    var didEndPull: (()->())?
    
    var waveColor: UIColor? {
        get {
            if let cgColor = self.waveLayer.fillColor {
                return UIColor(CGColor: cgColor)
            }
            return nil
        }
        set {
            self.waveLayer.strokeColor = newValue?.CGColor
            self.waveLayer.fillColor = newValue?.CGColor
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    func wave(y:CGFloat) {
        self.waveLayer.path = self.wavePath(y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func boundAnimation(bendDist: CGFloat) {
        let bounce = CAKeyframeAnimation(keyPath: "path")
        bounce.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let values = [
            self.wavePath(bendDist),
            self.wavePath(bendDist * 0.8),
            self.wavePath(bendDist * 0.6),
            self.wavePath(bendDist * 0.4),
            self.wavePath(bendDist * 0.2),
            self.wavePath(0)
        ]
        bounce.values = values
        bounce.duration = bounceDuration
        bounce.removedOnCompletion = false
        bounce.fillMode = kCAFillModeForwards
        //        bounce.delegate = self
        self.waveLayer.addAnimation(bounce, forKey: "return")
    }
    
    func wavePath(bendDist:CGFloat) -> CGPath {
        let width = self.frame.width
        let height = self.frame.height
        
        print("height:\(height)    y: \(-bendDist)")
        
        let bottomLeftPoint = CGPoint(x: 0, y: height)
        let topMidPoint = CGPoint(x: width / 2,  y: height-bendDist)
        let bottomRightPoint = CGPoint(x: width, y: height)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(bottomLeftPoint)
        bezierPath.addQuadCurveToPoint(bottomRightPoint, controlPoint: topMidPoint)
        bezierPath.addLineToPoint(bottomLeftPoint)
        return bezierPath.CGPath
    }
    
    func didRelease(bendDist: CGFloat) {
        self.boundAnimation(bendDist)
        didEndPull?()
        
        var duration = bounceDuration
        if duration <= 0 {
            duration = 0.1
        }
        duration *= CFTimeInterval(NSEC_PER_SEC)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration)), dispatch_get_main_queue(), { () -> Void in
            self.endAnimation()
        })
    }
    
    func endAnimation() {
        self.waveLayer.removeAllAnimations()
        self.wave(0)
    }
}
