//
//  DYLineProgress.swift
//  FlashWord
//
//  Created by darren on 16/6/20.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

public enum DYProgressType {
    case None
    case Loading
    case Success
    case Fail
    case TextOnly
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
    var topType = DYProgressType.None
    var loadingCache : [Int64:DYProgressType] = [Int64:DYProgressType]()
    
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
    
    func setupConstraints(type : DYProgressType) {
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
        
        let hasLoader = type != DYProgressType.TextOnly
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
    
    //MARK: public API
    public func show(type:DYProgressType, text:String?) {
        guard let superView = self.superView else {
            return
        }
        
        if type == DYProgressType.None ||
            (type == DYProgressType.TextOnly && (text == nil || text!.characters.count <= 0)) {
            return
        }
        
        if type == DYProgressType.Loading &&
            (topType == DYProgressType.Success || topType == DYProgressType.Fail || topType == DYProgressType.TextOnly) {
            return
        }
        topType = type
        
        var isFirstShow = false
        if rootView.superview == nil {
            isFirstShow = true
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
            loadingCount += 1
            break
        case .Success:
            loadingCount += 1
            loader = DYSucceedLoder(para: para)
            self.fadeOutTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(DYLineProgress.fadeOut(_:)), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.fadeOutTimer!, forMode: NSRunLoopCommonModes)
            break
        case .Fail:
            loadingCount += 1
            loader = DYFailLoder(para: para)
            self.fadeOutTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(DYLineProgress.fadeOut(_:)), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.fadeOutTimer!, forMode: NSRunLoopCommonModes)
            break
        case .TextOnly:
            loadingCount += 1
            self.fadeOutTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(DYLineProgress.fadeOut(_:)), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.fadeOutTimer!, forMode: NSRunLoopCommonModes)
            break
        default: break
        }
        
        loader?.show(loaderView, block: nil)
        
        if isFirstShow {
            fadeIn()
        }
    }
    
    public func dismissProgress() {
        if loadingCount <= 0 {
            return
        } else {
            loadingCount -= 1
            if loadingCount <= 0{
                fadeOut(nil)
            }
        }
    }
    
    private func reset() {
        rootView.removeFromSuperview()
        loadingCount = 0
        topType = DYProgressType.None
        
        self.fadeOutTimer = nil
    }
    
    private func fadeIn() {
        let duration = para.backgroundViewDismissAnimationDuration
        self.rootView.alpha = 0.45
        self.contentView.transform = CGAffineTransformMakeScale(0.75, 0.75)
        Async.main { [weak self] in
            UIView.animateWithDuration(duration, delay: 0.0, options: .CurveEaseOut, animations: {
                self?.rootView.alpha = 1
                self?.contentView.transform = CGAffineTransformIdentity
                }, completion: { _ in
            })
        }
    }
    
    @objc
    private func fadeOut(sender:AnyObject?) {
        let duration = para.backgroundViewDismissAnimationDuration
        Async.main { [weak self] in
            UIView.animateWithDuration(duration, delay: 0.0, options: .CurveEaseOut, animations: {
                self?.rootView.alpha = 0.0
                self?.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5)
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
    
    //    // MARK: Show Statuses
    //    public func showSuccess() {
    //        if !statusShown { ARSStatus.show(.Success) }
    //    }
    //    
    //    /**
    //     Will interrupt the current .Infinite loader progress and show fail animation instead.
    //     */
    //    public func showFail() {
    //        if !statusShown { ARSStatus.show(.Fail) }
    //    }
    //    
    //    
    //    // MARK: Show Infinite Loader
    //    
    //    
    //    public func show() {
    //        if !shown { ARSInfiniteLoader().showOnView(nil, completionBlock: nil) }
    //    }
    //    
    //    public func showWithPresentCompetionBlock(block: () -> Void) {
    //        if !shown { ARSInfiniteLoader().showOnView(nil, completionBlock: block) }
    //    }
    //    
    //    public func showOnView(view: UIView) {
    //        if !shown { ARSInfiniteLoader().showOnView(view, completionBlock: nil) }
    //    }
    //    
    //    public func showOnView(view: UIView, completionBlock: () -> Void) {
    //        if !shown { ARSInfiniteLoader().showOnView(view, completionBlock: completionBlock) }
    //    }
    //    
    //    
    //    // MARK: Show Progress Loader
    //    
    //    
    //    /**
    //     Note: initialValue should be from 0 to 100
    //     */
    //    public func showWithProgress(initialValue value: CGFloat) {
    //        if !shown { ARSProgressLoader().showWithValue(value, onView: nil, progress: nil, completionBlock: nil) }
    //    }
    //    
    //    /**
    //     Note: initialValue should be from 0 to 100
    //     */
    //    public func showWithProgress(initialValue value: CGFloat, onView: UIView) {
    //        if !shown { ARSProgressLoader().showWithValue(value, onView: onView, progress: nil, completionBlock: nil) }
    //    }
    //    
    //    /**
    //     Note: initialValue should be from 0 to 100
    //     */
    //    public func showWithProgress(initialValue value: CGFloat, completionBlock: (() -> Void)?) {
    //        if !shown { ARSProgressLoader().showWithValue(value, onView: nil, progress: nil, completionBlock: completionBlock) }
    //    }
    //    
    //    /**
    //     Note: initialValue should be from 0 to 100
    //     */
    //    public func showWithProgress(initialValue value: CGFloat, onView: UIView, completionBlock: (() -> Void)?) {
    //        if !shown { ARSProgressLoader().showWithValue(value, onView: onView, progress: nil, completionBlock: completionBlock) }
    //    }
    //    
    //    public func showWithProgressObject(progress: NSProgress) {
    //        if !shown { ARSProgressLoader().showWithValue(0.0, onView: nil, progress: progress, completionBlock: nil) }
    //    }
    //    
    //    public func showWithProgressObject(progress: NSProgress, completionBlock: (() -> Void)?) {
    //        if !shown { ARSProgressLoader().showWithValue(0.0, onView: nil, progress: progress, completionBlock: completionBlock) }
    //    }
    //    
    //    public func showWithProgressObject(progress: NSProgress, onView: UIView) {
    //        if !shown { ARSProgressLoader().showWithValue(0.0, onView: onView, progress: progress, completionBlock: nil) }
    //    }
    //    
    //    public func showWithProgressObject(progress: NSProgress, onView: UIView, completionBlock: (() -> Void)?) {
    //        if !shown { ARSProgressLoader().showWithValue(0.0, onView: onView, progress: progress, completionBlock: completionBlock) }
    //    }
    //    
    //    
    //    // MARK: Update Progress Loader
    //    
    //    
    //    public func updateWithProgress(value: CGFloat) {
    //        ARSProgressLoader.weakSelf?.progressValue = value
    //    }
    //    
    //    public func cancelPorgressWithFailAnimation(showFail: Bool) {
    //        ARSProgressLoader.weakSelf?.cancelWithFailAnimation(showFail, completionBlock: nil)
    //    }
    //    
    //    public func cancelPorgressWithFailAnimation(showFail: Bool, completionBlock: (() -> Void)?) {
    //        ARSProgressLoader.weakSelf?.cancelWithFailAnimation(showFail, completionBlock: completionBlock)
    //    }
    //    
    //    
    //    // MARK: Hide Loader
    //    
    //
    //
    //    private func cleanup(loader: DYLoader?) {
    //        loader?.emptyView.removeFromSuperview()
    //        currentLoader = nil
    //    }
}


@objc private protocol DYLoaderProtocol {
    optional weak var superView: UIView? { get set }
    @objc func canShow(onView:UIView) -> Bool
    @objc func show(onView:UIView, block:(() -> Void)?)
    @objc func hide(block: (() -> Void)?)
}

class DYLoader: DYLoaderProtocol {
    @objc weak var superView: UIView?
    let para:DYLineProgressPara
    
    init(para:DYLineProgressPara) {
        self.para = para
    }
    
    //MARK: DYLoader subclass overide methods
    @objc func canShow(onView:UIView) -> Bool {
        return superView == nil
    }
    
    @objc func show(onView:UIView, block:(() -> Void)? = nil) {
        superView = onView
    }
    
    @objc func hide(block: (() -> Void)? = nil) {
        superView = nil
    }
}

private final class DYSucceedLoder: DYLoader {
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

private final class DYFailLoder: DYLoader {
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