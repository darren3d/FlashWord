//
//  DYLineProgress.swift
//  FlashWord
//
//  Created by darren on 16/6/20.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

public enum DYLoaderStatus {
    case Success
    case Fail
    case TextOnly
}

public enum DYLoaderType {
    case None
    case Loading
    case Status(DYLoaderStatus)
    
    func hasLoader() -> Bool {
        switch self {
        case .None:
            return false
        case .Loading: 
            return true
        case .Status(let status):
            return status  != .TextOnly
        }
        return false
    }
}

public enum DYProgressStatus {
    case Hidden
    case FadeIn
    case Shown
    case FadeOut
}

public class DYLineProgressPara {
    public var showSuccessCheckmark = true
    
    public var maxContentViewWidth: CGFloat = 200.0
    public var contentViewInsets: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
    public var contentViewCornerRadius: CGFloat = 13.0
    public var loaderViewSideLength: CGFloat = 80.0
    public var backgroundViewPresentAnimationDuration: CFTimeInterval = 0.3
    public var backgroundViewDismissAnimationDuration: CFTimeInterval = 0.3
    
    public var blurStyle: UIBlurEffectStyle = .Dark
    public var circleColorOuter: CGColor = UIColor.dy_color(130, green: 149, blue: 173, alpha: 1.0).CGColor
    public var circleColorMiddle: CGColor = UIColor.dy_color(82, green: 124, blue: 194, alpha: 1.0).CGColor
    public var circleColorInner: CGColor = UIColor.dy_color(60, green: 132, blue: 196, alpha: 1.0).CGColor
    public var circleRadiusOuter: CGFloat = 40
    public var circleRadiusMiddle: CGFloat = 30
    public var circleRadiusInner: CGFloat = 20
    public var circleLineWidth: CGFloat = 2
    public var circleStartAngle: CGFloat = -CGFloat(M_PI+M_PI_4)//-CGFloat(M_PI_2+M_PI)*0.5
    public var circleEndAngle: CGFloat = 0.0
    
    public var circleRotationDurationOuter: CFTimeInterval = 3.0
    public var circleRotationDurationMiddle: CFTimeInterval = 1.5
    public var circleRotationDurationInner: CFTimeInterval = 0.75
    
    public var checkmarkAnimationDrawDuration: CFTimeInterval = 0.4
    public var checkmarkLineWidth: CGFloat = 2.0
    public var checkmarkColor: CGColor = UIColor.dy_color(130, green: 149, blue: 173, alpha: 1.0).CGColor
    
    public var successCircleAnimationDrawDuration: CFTimeInterval = 0.7
    public var successCircleLineWidth: CGFloat = 2.0
    public var successCircleColor: CGColor = UIColor.dy_color(130, green: 149, blue: 173, alpha: 1.0).CGColor
    
    public var failCrossAnimationDrawDuration: CFTimeInterval = 0.4
    public var failCrossLineWidth: CGFloat = 2.0
    public var failCrossColor: CGColor = UIColor.dy_color(130, green: 149, blue: 173, alpha: 1.0).CGColor
    
    public var failCircleAnimationDrawDuration: CFTimeInterval = 0.7
    public var failCircleLineWidth: CGFloat = 2.0
    public var failCircleColor: CGColor = UIColor.dy_color(130, green: 149, blue: 173, alpha: 1.0).CGColor
    
    private static var kDefaultLineProgressPara:DYLineProgressPara? = nil
    class func defaultPara() -> DYLineProgressPara {
        if kDefaultLineProgressPara != nil {
            return kDefaultLineProgressPara!;
        }
        
        let para = DYLineProgressPara()
        kDefaultLineProgressPara = para
        return para
    }
}

public class DYLineProgress {
    let para:DYLineProgressPara 
    
    // add DYLineProgress to superView
    weak var superView: UIView?
    
    //rootView of DYLineProgress, also background。superView of contentView
    var rootView = UIView()
    //superView of loaderView and textView
    var contentView:UIVisualEffectView
    var loaderView = UIView()
    var textLabel = UILabel()
    
    var text : String? = nil
    var loadingCount : Int64 = 0
    var fadeOutTimer : NSTimer? {
        willSet{
            guard let oldTimer = fadeOutTimer else {
                return
            }
            oldTimer.invalidate()
        }
    }
    
    var status = DYProgressStatus.Hidden
    var topType = DYLoaderType.None
    var loadingCache : [Int64:DYLoaderType] = [Int64:DYLoaderType]()
    
    init(superView:UIView? = nil, para:DYLineProgressPara? = nil) {
        if superView == nil {
            self.superView = DYLineProgress.appWindow()
        } else {
            self.superView = superView!
        }
        
        if para == nil {
            self.para = DYLineProgressPara() 
        } else {
            self.para = para!
        }
        
        let blur = UIBlurEffect(style: self.para.blurStyle)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.clipsToBounds = true
        contentView = effectView
        
        textLabel.textAlignment = NSTextAlignment.Center;
        textLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
        textLabel.numberOfLines = 0;
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textColor = UIColor.whiteColor()
        
        rootView.addSubview(contentView)
        contentView.addSubview(loaderView)
        contentView.addSubview(textLabel)
        
        contentView.layer.cornerRadius = self.para.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(DYLineProgress.orientationChanged(_:)),
                                                         name: UIDeviceOrientationDidChangeNotification,
                                                         object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIDeviceOrientationDidChangeNotification,
                                                            object: nil)
    }
    
    @objc
    func orientationChanged(notification: NSNotification) {
        if let superView = self.superView {
            adjustFrameForBackgroundView(onView: superView)
        } else {
            adjustFrameForBackgroundView(onView: nil)
        }
    }
    
    func setupConstraints(type : DYLoaderType) {
        //rootView添加约束
        guard let superview = rootView.superview 
            else {
                return
        }
        rootView.snp_remakeConstraints { make in
            make.edges.equalTo(superview)
        }
        
        //contentView添加约束
        contentView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(rootView)
            make.centerY.equalTo(rootView)
            make.width.lessThanOrEqualTo(para.maxContentViewWidth)
        }
        
        let hasLoader = type.hasLoader()
        let hasText = text != nil && text!.characters.count > 0
        
        //loaderView添加约束
        if hasLoader {
            loaderView.snp_remakeConstraints { (make) in
                make.top.equalTo(contentView).offset(para.contentViewInsets.top)
                make.width.equalTo(para.loaderViewSideLength)
                make.height.equalTo(para.loaderViewSideLength)
                
                make.centerX.equalTo(contentView)
                make.leading.greaterThanOrEqualTo(contentView).offset(para.contentViewInsets.left)
                make.trailing.lessThanOrEqualTo(contentView).offset(-para.contentViewInsets.right)
                
                if !hasText {
                    make.bottom.equalTo(contentView).offset(-para.contentViewInsets.bottom)
                }
            }
        } else {
            loaderView.snp_removeConstraints()
        }
        
        
        //textLabel添加约束
        if hasText {
            textLabel.snp_remakeConstraints { (make) in
                make.leading.equalTo(contentView).offset(para.contentViewInsets.left)
                make.trailing.equalTo(contentView).offset(-para.contentViewInsets.right)
                make.bottom.equalTo(contentView).offset(-para.contentViewInsets.bottom)
                
                if hasLoader {
                    make.top.equalTo(loaderView.snp_bottom).offset(6)
                } else {
                    make.top.equalTo(contentView).offset(para.contentViewInsets.top)
                }
            }
        } else {
            textLabel.snp_removeConstraints()
        }
    }
    
    func adjustFrameForBackgroundView(onView view: UIView?) -> Bool {
        rootView.layoutIfNeeded()
        return true
    }
    
    final class func appWindow() -> UIWindow? {
        var targetWindow: UIWindow?
        let windows = UIApplication.sharedApplication().windows
        for window in windows {
            if window.screen != UIScreen.mainScreen() { continue }
            if !window.hidden && window.alpha == 0 { continue }
            if window.windowLevel != UIWindowLevelNormal { continue }
            
            targetWindow = window
            break
        }
        
        return targetWindow
    }
    
    
    public func show(type:DYLoaderType, text:String?) {
        guard let superView = self.superView else {
            return
        }
        
        switch type {
        case .None:
            return
        case .Loading: 
            if case let DYLoaderType.Status(status) = topType {
                DYLog.info("DYLoaderType: .\(status)")
                return
            }
        case .Status(let status):
            if status  == .TextOnly && (text == nil || text!.characters.count <= 0) {
                return
            }
        }
        topType = type
        
        if rootView.superview == nil {
            superView.addSubview(rootView)
        }
        superView.bringSubviewToFront(rootView)
        
        self.text = text
        textLabel.text = text
        
        setupConstraints(type)
        rootView.layoutIfNeeded()
        
        let duration = DYLineProgress.durationForText(text)
        var loader : DYLoader? = nil
        switch type {
        case .Loading:
            loader = DYInfiniteLoader(para: para)
            break
        case .Status(let status):
            if status == .Success {
                loader = DYSucceedLoder(para: para)
            } else if status == .Fail{
                loader = DYFailLoder(para: para)
            }
            
            self.fadeOutTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(DYLineProgress.fadeOut(_:)), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.fadeOutTimer!, forMode: NSRunLoopCommonModes)
            break
        default:
            break
        }
        
        loader?.show(loaderView, block: nil)
    }
    
    public func hide(block: (() -> Void)? = nil) {
        rootView.removeFromSuperview()
        
        
    }
    
    private func reset () {
        rootView.removeFromSuperview()
        loadingCache = [Int64:DYLoaderType]()
        topType = DYLoaderType.None
        self.fadeOutTimer = nil
    }
    
    @objc
    private func fadeOut(sender:AnyObject) {
        let duration = para.backgroundViewDismissAnimationDuration
        Async.main { [weak self] in
            UIView.animateWithDuration(duration, delay: 0.0, options: .CurveEaseOut, animations: {
                self?.rootView.alpha = 0.0
                self?.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }, completion: { _ in
                    self?.reset()
            })
        }
    }
    
    class private func durationForText(text:String?) -> NSTimeInterval {
        let minD = 1.5
        let maxD = 4.0
        
        guard let text = text else {
            return minD
        }
        
        let duration = NSTimeInterval(text.characters.count) * 0.1 + 1.0
        return min(maxD, max(minD, duration))
    }
}