//
//  ViewControllerUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

let dynUIViewControllerProgressView = "dyn.key.viewcontroller.progressview"

extension UIViewController {
    
    private var progressView : DYProgressView {
        if let progressView = objc_getAssociatedObject(self, dynUIViewControllerProgressView) as? DYProgressView {
            return progressView;
        }
        
        let progressView =  DYProgressView(frame:self.view.frame)
        progressView.backgroundColor = UIColor.flat(FlatColors.MidnightBlue)
        objc_setAssociatedObject(self, dynUIViewControllerProgressView, progressView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return progressView;
    }
    
    
    func showProgressView(title:String = "") -> Void {
        let progressView = self.progressView
        
        if progressView.isAnimating() {
            return
        }
        
        if progressView.superview == nil {
            self.view.addSubview(progressView)
        }
        
        progressView.frame = self.view.frame
        
        progressView.startAnimation()
    }
    
    func dismissProgressView() -> Void {
        
    }
}