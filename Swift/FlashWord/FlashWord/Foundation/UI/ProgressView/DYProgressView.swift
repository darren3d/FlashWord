//
//  DYProgressView.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYProgressView: UIView {
    private struct DYProgressViewKey {
        static var dynProgressView = "dyn.key.DYProgressView.progressView"
    }
    
    private var progressView : NVActivityIndicatorView {
        get {
            if let progressView = objc_getAssociatedObject(self, &DYProgressViewKey.dynProgressView) as? NVActivityIndicatorView {
                return progressView;
            }
            
            let progressView =  NVActivityIndicatorView(frame:CGRect(x: 120, y: 120, width: 60, height: 60), type:NVActivityIndicatorType.BallClipRotate)
            progressView.backgroundColor = UIColor.flat(FlatColors.Orange)
            objc_setAssociatedObject(self, &DYProgressViewKey.dynProgressView, progressView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return progressView;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let progressView = self.progressView
        
        if progressView.superview == nil {
            self.addSubview(progressView)
        }
        
        adjustProgressView()
    }
    
    private func adjustProgressView() {
        let progressView = self.progressView
        var frame = progressView.frame
        frame.origin.x = (self.frame.size.width - progressView.frame.size.width) * 0.5
        frame.origin.y = (self.frame.size.height - progressView.frame.size.height) * 0.5
        
        progressView.frame = frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let progressView = self.progressView
        DYLog.info("frame : .\(progressView.frame)")
        
        adjustProgressView()
        
        if progressView.animating {
            progressView.startAnimation()
        }
        
        DYLog.info("frame : .\(progressView.frame)")
    }
    
    
    func isAnimating() -> Bool {
        return self.progressView.animating
    }
    
    func startAnimation() {
        self.progressView.startAnimation()
    }
}
