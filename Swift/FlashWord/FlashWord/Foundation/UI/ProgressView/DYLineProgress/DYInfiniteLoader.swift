//
//  DYInfiniteLoader.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYInfiniteLoader: DYLoader {
    var outerCircle : CAShapeLayer? {
        willSet {
            guard let outerCircle = outerCircle else {
                return
            }
            
            outerCircle.removeAllAnimations()
            outerCircle.removeFromSuperlayer()
        }
    }
    
    var middleCircle : CAShapeLayer? {
        willSet {
            guard let middleCircle = middleCircle else {
                return
            }
            
            middleCircle.removeAllAnimations()
            middleCircle.removeFromSuperlayer()
        }
    }
    
    var innerCircle : CAShapeLayer? {
        willSet {
            guard let innerCircle = innerCircle else {
                return
            }
            
            innerCircle.removeAllAnimations()
            innerCircle.removeFromSuperlayer()
        }
    }
    
    override func show(onView:UIView, block:(() -> Void)? = nil) {
        if !canShow(onView) {
            return
        }
        
        let superView = onView as? UIVisualEffectView
        if superView == nil {
            createCircles(onView: onView)
        } else {
            createCircles(onView: superView!.contentView)
        }
        
        animateCircles()
        
        super.show(onView, block: block)
    }
    
    override func hide(block: (() -> Void)? = nil) {
        outerCircle?.removeFromSuperlayer()
        outerCircle = nil
        
        middleCircle?.removeFromSuperlayer()
        middleCircle = nil
        
        innerCircle?.removeFromSuperlayer()
        innerCircle = nil
        
        super.hide(block)
    }
    
    private func createCircles(onView view: UIView) {
        let circleRadiusOuter = para.circleRadiusOuter
        let circleRadiusMiddle = para.circleRadiusMiddle
        let circleRadiusInner = para.circleRadiusInner
        let viewBounds = view.bounds
        let arcCenter = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds))
        var path: UIBezierPath = UIBezierPath(arcCenter: arcCenter,
                                              radius: circleRadiusOuter,
                                              startAngle: para.circleStartAngle,
                                              endAngle: para.circleEndAngle,
                                              clockwise: true)
        
        self.outerCircle = CAShapeLayer()
        configureLayer(self.outerCircle!, forView: view, withPath: path.CGPath, withBounds: viewBounds, withColor: para.circleColorOuter)
        
        path = UIBezierPath(arcCenter: arcCenter,
                            radius: circleRadiusMiddle,
                            startAngle: para.circleStartAngle,
                            endAngle: para.circleEndAngle,
                            clockwise: true)
        
        self.middleCircle = CAShapeLayer()
        configureLayer(self.middleCircle!, forView: view, withPath: path.CGPath, withBounds: viewBounds, withColor: para.circleColorMiddle)
        
        path = UIBezierPath(arcCenter: arcCenter,
                            radius: circleRadiusInner,
                            startAngle: para.circleStartAngle,
                            endAngle: para.circleEndAngle,
                            clockwise: true)
        
        self.innerCircle = CAShapeLayer()
        configureLayer(self.innerCircle!, forView: view, withPath: path.CGPath, withBounds: viewBounds, withColor: para.circleColorInner)
    }
    
    private func configureLayer(layer: CAShapeLayer, forView view: UIView, withPath path: CGPath, withBounds bounds: CGRect, withColor color: CGColor) {
        layer.path = path
        layer.frame = bounds
        layer.lineWidth = para.circleLineWidth
        layer.strokeColor = color
        layer.fillColor = UIColor.clearColor().CGColor
        layer.opaque = true
        view.layer.addSublayer(layer)
    }
    
    private func animateCircles() {
        let outerAnimation = CABasicAnimation(keyPath: "transform.rotation")
        outerAnimation.toValue = 2 * CGFloat(M_PI)
        outerAnimation.duration = para.circleRotationDurationOuter
        outerAnimation.repeatCount = Float(UINT64_MAX)
        outerCircle?.addAnimation(outerAnimation, forKey: "outerCircleRotation")
        
        let middleAnimation = outerAnimation.copy() as! CABasicAnimation
        middleAnimation.duration = para.circleRotationDurationMiddle
        middleCircle?.addAnimation(middleAnimation, forKey: "middleCircleRotation")
        
        let innerAnimation = middleAnimation.copy() as! CABasicAnimation
        innerAnimation.duration = para.circleRotationDurationInner
        innerCircle?.addAnimation(innerAnimation, forKey: "middleCircleRotation")
    }
}
