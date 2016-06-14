//
//  ViewControllerUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

let kViewControllerProgressView = "dy.key.controller.progressview"

extension UIViewController {
    
    private var progressView : NVActivityIndicatorView {
        if let progressView = objc_getAssociatedObject(self, kViewControllerProgressView) as? NVActivityIndicatorView {
            return progressView;
        }
        
        let progressView =  NVActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 60, height: 60), type:NVActivityIndicatorType.BallClipRotate)
        objc_setAssociatedObject(self, kViewControllerProgressView, progressView, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        return progressView;
    }
    
    
    func showProgressView(title:String = "") -> Void {
        let progressView = self.progressView
        
        if progressView.animating {
            return
        }
        
        if progressView.superview == nil {
            self.view.addSubview(progressView)
        }
        
        progressView.frame.origin.x = (self.view.frame.size.width - progressView.frame.size.width) * 0.5
        progressView.frame.origin.y = (self.view.frame.size.height - progressView.frame.size.height) * 0.5
        
        progressView.startAnimation()
    }
    
    func dismissProgressView() -> Void {
        
    }
}