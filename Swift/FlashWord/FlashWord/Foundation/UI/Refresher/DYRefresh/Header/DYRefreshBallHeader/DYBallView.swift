//
//  DYBallView.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYBallView: UIView {
    var moveUpDuration: Double = 0.35
    var circleSize: CGFloat = 20
    var circleSpace: CGFloat = 8.0
    var circleColor = UIColor.lightGrayColor()
    private var circleLayers : [CircleLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        for layer in circleLayers {
            layer.removeFromSuperlayer()
        }
        circleLayers.removeAll()
        
        for i in 3.stride(through: 0, by: -1) {
            let circleLayer = CircleLayer(
                layer: self.layer,
                size: circleSize,
                moveUpDist: self.bounds.size.height*0.5,
                superViewFrame: frame,
                color: circleColor
            )
            circleLayer.layerTag = i
            circleLayers.append(circleLayer)
            self.layer.addSublayer(circleLayer)
        }
    }
    
    func startAnimation() {
        let layers = circleLayers.reverse()
        for layer in layers {
            layer.startAnimationUp(moveUpDuration,
                                   circleSize: circleSize,
                                   circleSpace: circleSpace,
                                   viewWidth: bounds.size.width)
        }
    }
    
    func stopAnimation() {
        let layers = circleLayers
        for layer in layers {
            layer.stopFloatAnimation()
        }
    }
    
    func resetAnimation() {
        let layers = circleLayers
        for layer in layers {
            layer.resetAnimation()
        }
    }
    
    func setBallColors(colors: [UIColor]) {
        let countColor = colors.count
        let countLayer = circleLayers.count
        let count = min(countColor, countLayer)
        for i in 0 ..< count {
            let layer = circleLayers[i]
            layer.fillColor = colors[i].CGColor
            layer.strokeColor = colors[i].CGColor
        }
    }
}

class CircleLayer :CAShapeLayer,CAAnimationDelegate {
    var moveUpDist: CGFloat!
    var layerTag: Int = 0
    var didEndAnimation: (()->())?
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    init(layer: AnyObject, size:CGFloat, moveUpDist:CGFloat, superViewFrame:CGRect, color:UIColor) {
        super.init(layer: layer)
        
        self.moveUpDist = moveUpDist
        let selfFrame = CGRect(x: 0, y: 0, width: superViewFrame.size.width, height: superViewFrame.size.height)
        
        let radius:CGFloat = size / 2
        self.frame = selfFrame
        let center = CGPoint(x: superViewFrame.size.width / 2, y: superViewFrame.size.height)
        let startAngle = 0 - M_PI_2
        let endAngle = M_PI * 2 - M_PI_2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        self.fillColor = color.colorWithAlphaComponent(1).CGColor
        self.strokeColor = self.fillColor
        self.lineWidth = 0
        self.strokeEnd = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimationUp(duration:NSTimeInterval, circleSize:CGFloat, circleSpace:CGFloat, viewWidth: CGFloat) {
        let distance_left = (circleSize + circleSpace) * (1.5 - CGFloat(layerTag))
        self.moveUp(duration, up: moveUpDist, left: distance_left, viewWidth: viewWidth)
    }
    
    func endAnimation(complition:(()->())? = nil) {
        didEndAnimation = complition
    }
    
    func moveUp(duration:NSTimeInterval, up: CGFloat,left: CGFloat, viewWidth: CGFloat) {
        self.hidden = false
        let move = CAKeyframeAnimation(keyPath: "position")
        let angle_1 = atan(Double(abs(left)) / Double(up))
        let angle_2 = M_PI -  angle_1 * 2
        let radii: Double = pow((pow(Double(left), 2)) + pow(Double(up), 2), 1 / 2) / (cos(angle_1) * 2)
        let centerPoint: CGPoint = CGPoint(x: viewWidth/2 - left, y: CGFloat(radii))
        var endAngle: CGFloat = CGFloat(3 * M_PI_2)
        var startAngle: CGFloat = CGFloat(3 / 2 * M_PI - angle_2)
        var bezierPath = UIBezierPath()
        var clockwise:Bool = true
        
        if left > 0 {
            clockwise = false
            startAngle =  CGFloat(3 / 2 * M_PI + angle_2)
            endAngle = CGFloat(3 * M_PI_2)
        }
        
        bezierPath = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(radii), startAngle: startAngle , endAngle: endAngle, clockwise: clockwise)
        move.path = bezierPath.CGPath
        move.duration = duration
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        move.delegate = self
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    func floatUpOrDown() {
        self.removeAnimationForKey("position.y")
        let move = CAKeyframeAnimation(keyPath: "position.y")
        move.values = [0,1,2,3,4,5,4,3,2,1,0,-1,-2,-3,-4,-5,-4,-3,-2,-1,0]
        move.duration = 1
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        move.additive = true
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    func stopFloatAnimation() {
        
    }
    
    func resetAnimation() {
        self.hidden = true
        self.removeAllAnimations()
        
        let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
        self.position = center
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        let animation:CAKeyframeAnimation = anim as! CAKeyframeAnimation
        if animation.keyPath == "position" {
            var timeDelay : Double = Double(UInt64(layerTag) * NSEC_PER_SEC)
            timeDelay *= 0.1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeDelay)), dispatch_get_main_queue(), { () -> Void in
                self.floatUpOrDown()
            })
//            timer = Timer.schedule(delay: timeDelay, repeatInterval: 1, handler: { (timer) -> Void in
//                self.floatUpOrDown()
//            })
        }
    }
}
