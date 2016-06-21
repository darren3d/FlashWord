//
//  DYSucceedLoader.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYSucceedLoder: DYLoader {
    var checkLayer : CAShapeLayer?
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
        let backgroundLayer = superView.layer
        let outerCircleHeight = CGRectGetHeight(backgroundViewBounds)
        let outerCircleWidth = CGRectGetWidth(backgroundViewBounds)
        
        let checkmarkPath = UIBezierPath()
        checkmarkPath.moveToPoint(CGPointMake(outerCircleWidth * 0.28, outerCircleHeight * 0.53))
        checkmarkPath.addLineToPoint(CGPointMake(outerCircleWidth * 0.42, outerCircleHeight * 0.66))
        checkmarkPath.addLineToPoint(CGPointMake(outerCircleWidth * 0.72, outerCircleHeight * 0.36))
        checkmarkPath.lineCapStyle = .Square
        
        let checkmark = CAShapeLayer()
        checkmark.path = checkmarkPath.CGPath
        checkmark.fillColor = nil
        checkmark.strokeColor = para.checkmarkColor
        checkmark.lineWidth = para.checkmarkLineWidth
        backgroundLayer.addSublayer(checkmark)
        checkLayer = checkmark
        
        let successCircleArcCenter = CGPointMake(CGRectGetMidX(backgroundViewBounds), CGRectGetMidY(backgroundViewBounds))
        let successCircle = CAShapeLayer()
        successCircle.path = UIBezierPath(arcCenter: successCircleArcCenter,
                                          radius: para.circleRadiusOuter,
                                          startAngle: -CGFloat(M_PI_2),
                                          endAngle: CGFloat(M_PI) / 180 * 270,
                                          clockwise: true).CGPath
        successCircle.fillColor = nil
        successCircle.strokeColor = para.successCircleColor
        successCircle.lineWidth = para.successCircleLineWidth
        backgroundLayer.addSublayer(successCircle)
        circleLayer = successCircle
        
        let animationCheckmark = CABasicAnimation(keyPath: "strokeEnd")
        animationCheckmark.removedOnCompletion = true
        animationCheckmark.fromValue = 0
        animationCheckmark.toValue = 1
        animationCheckmark.fillMode = kCAFillModeBoth
        animationCheckmark.duration = para.checkmarkAnimationDrawDuration
        animationCheckmark.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        checkmark.addAnimation(animationCheckmark, forKey: nil)
        
        let animationCircle = CABasicAnimation(keyPath: "strokeEnd")
        animationCircle.removedOnCompletion = true
        animationCircle.fromValue = 0
        animationCircle.toValue = 1
        animationCircle.fillMode = kCAFillModeBoth
        animationCircle.duration = para.successCircleAnimationDrawDuration
        animationCircle.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        successCircle.addAnimation(animationCircle, forKey: nil)
        
        super.show(onView, block: block)
    }
    
    override func hide(block: (() -> Void)? = nil) {
        checkLayer?.removeFromSuperlayer()
        checkLayer = nil
        
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil
        
        super.hide(block)
    }
    
}
