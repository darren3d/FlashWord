//
//  DYTransitionAnimator.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYTransitionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration = 0.45
    var para : [String:String] = [String:String]()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                DYLog.error("animateTransition: fromViewController ,toViewController or containerView is nil")
                return
        }
        
        let duration = transitionDuration(transitionContext)
        containerView.addSubview(fromViewController.view);
        containerView.addSubview(toViewController.view);
        
        //alpha变化
        //        UIView.animateWithDuration(duration,
        //                                   animations: { 
        //                                    fromViewController.view.alpha = 0;
        //        }) { (finished) in
        //            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        //            fromViewController.view.alpha = 1;
        //        }
        
        //位移变化
        let direction = para["direction"]
        var fromTransform : CGAffineTransform
        var toTransform : CGAffineTransform
        if direction == "left" {
            fromTransform = CGAffineTransformMakeTranslation(-fromViewController.view.bounds.size.width*0.666, 0)
            toTransform = CGAffineTransformMakeTranslation(toViewController.view.bounds.size.width, 0)
        } else if direction == "right"{
            fromTransform = CGAffineTransformMakeTranslation(fromViewController.view.bounds.size.width*0.666, 0)
            toTransform = CGAffineTransformMakeTranslation(-toViewController.view.bounds.size.width, 0)
        } else {
            fromTransform = CGAffineTransformMakeTranslation(0, -fromViewController.view.bounds.size.height*0.666)
            toTransform = CGAffineTransformMakeTranslation(0, toViewController.view.bounds.size.height)
        }
        
        
        toViewController.view.transform = toTransform
        UIView.animateWithDuration(duration,
                                   animations: { 
                                    fromViewController.view.transform = fromTransform
                                    toViewController.view.transform = CGAffineTransformIdentity
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            fromViewController.view.transform = CGAffineTransformIdentity;
        }
    }
}