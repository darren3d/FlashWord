//
//  DYFailLoader.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYFailLoder: DYLoader {
    var crossLayer : CAShapeLayer?
    var circleLayer : CAShapeLayer?
    
    override init(para:DYLineProgressPara) {
        super.init(para: para)
    }
    
    override func show(onView:UIView, block:(() -> Void)? = nil) {
        if !canShow(onView) {
            return
        }
        
        let superView = onView
        
        let backgroundViewBounds = superView.bounds
        let backgroundViewLayer = superView.layer
        let outerCircleWidth = CGRectGetWidth(backgroundViewBounds)
        let outerCircleHeight = CGRectGetHeight(backgroundViewBounds)
        
        let crossPath = UIBezierPath()
        crossPath.moveToPoint(CGPointMake(outerCircleWidth * 0.67, outerCircleHeight * 0.32))
        crossPath.addLineToPoint(CGPointMake(outerCircleWidth * 0.32, outerCircleHeight * 0.67))
        crossPath.moveToPoint(CGPointMake(outerCircleWidth * 0.32, outerCircleHeight * 0.32))
        crossPath.addLineToPoint(CGPointMake(outerCircleWidth * 0.67, outerCircleHeight * 0.67))
        crossPath.lineCapStyle = .Square
        
        let cross = CAShapeLayer()
        cross.path = crossPath.CGPath
        cross.fillColor = nil
        cross.strokeColor = para.failCrossColor
        cross.lineWidth = para.failCrossLineWidth
        cross.frame = backgroundViewBounds
        backgroundViewLayer.addSublayer(cross)
        crossLayer = cross
        
        let failCircleArcCenter = CGPointMake(CGRectGetMidX(backgroundViewBounds), CGRectGetMidY(backgroundViewBounds))
        let failCircle = CAShapeLayer()
        failCircle.path = UIBezierPath(arcCenter: failCircleArcCenter,
                                       radius: para.circleRadiusOuter,
                                       startAngle: -CGFloat(M_PI_2),
                                       endAngle: CGFloat(M_PI) / 180 * 270,
                                       clockwise: true).CGPath
        failCircle.fillColor = nil
        failCircle.strokeColor = para.failCircleColor
        failCircle.lineWidth = para.failCircleLineWidth
        backgroundViewLayer.addSublayer(failCircle)
        circleLayer = failCircle
        
        let animationCross = CABasicAnimation(keyPath: "strokeEnd")
        animationCross.removedOnCompletion = false
        animationCross.fromValue = 0
        animationCross.toValue = 1
        animationCross.duration = para.failCrossAnimationDrawDuration
        animationCross.fillMode = kCAFillModeBoth
        animationCross.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        cross.addAnimation(animationCross, forKey: nil)
        
        let animationCircle = CABasicAnimation(keyPath: "opacity")
        animationCircle.removedOnCompletion = true
        animationCircle.fromValue = 0
        animationCircle.toValue = 1
        animationCircle.fillMode = kCAFillModeBoth
        animationCircle.duration = para.failCircleAnimationDrawDuration
        animationCircle.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        failCircle.addAnimation(animationCircle, forKey: nil)
        
        super.show(onView, block: block)
    }
    
    override func hide(block: (() -> Void)? = nil) {
        crossLayer?.removeFromSuperlayer()
        crossLayer = nil
        
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil
        
        super.hide(block)
    }
    
}
