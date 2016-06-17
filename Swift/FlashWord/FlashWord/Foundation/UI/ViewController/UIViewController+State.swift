//
//  UIViewController+State.swift
//  FlashWord
//
//  Created by darren on 16/6/16.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

public enum DYUIState : Int32 {
    case Init = 0
    case Loading = 1
    case Content = 2
    case Empty = 4
    case Warning = 8
    case Error = 16
}

class DYUIStateModel {
    var title : NSAttributedString?
    var description : NSAttributedString?
    var image : UIImage?
    var imageTintColor : UIColor?
    var buttonTitle : NSAttributedString?
    var buttonImage : UIImage?
    var buttonBackgroundImage : UIImage?
    var backgroundColor : UIColor?
    var verticalOffset : CGFloat = 0.0
    var spaceHeight : CGFloat = 0.0
}

public protocol DYUIStateDateSource : class {
    func superViewForUIState(uistate:DYUIState)->UIView?
    func titleForUIState(uistate:DYUIState)->NSAttributedString?
    func descriptionForUIState(uistate:DYUIState)->NSAttributedString?
    func imageForUIState(uistate:DYUIState)->UIImage?
    func imageTintColorForUIState(uistate:DYUIState)->UIColor?
    func buttonTitleForUIState(uistate:DYUIState, buttonState:UIControlState)->NSAttributedString?
    func buttonImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage?
    func buttonBackgroundImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage?
    func backgroundColorForUIState(uistate:DYUIState)->UIColor?
    func customViewForUIState(uistate:DYUIState)->UIView?
    func verticleOffsetForUIState(uistate:DYUIState) -> CGFloat
    func spaceHeightForUIState(uistate:DYUIState) -> CGFloat
}

public protocol DYUIStateDelegate : class {
    func shouldDisplayForUIState(uistate:DYUIState) -> Bool
    func shouldAllowTouchForUIState(uistate:DYUIState) -> Bool
    func didTapViewForUIState(uistate:DYUIState) -> Void
    func didTapButtonForUIState(uistate:DYUIState) -> Void
    func willAppearForUIState(uistate:DYUIState) -> Void
    func didAppearForUIState(uistate:DYUIState) -> Void
    func willDisappearForUIState(uistate:DYUIState) -> Void
    func didDisappearForUIState(uistate:DYUIState) -> Void
}


//class DYUIStateAdaptor : DYUIStateDateSource {
//    weak var viewController : UIViewController?
//    weak var superView : UIView?
//    var stateModels : [DYUIState : DYUIStateModel]?
//    
//    init(viewController : UIViewController, superView:UIView) {
//        self.viewController = viewController;
//        self.superView = superView;
//    }
//    
//    //MARK: DYUIStateAdaptor - DYUIStateDateSource
//    func superViewForUIState(uistate:DYUIState)->UIView? {
//        return self.superView
//    }
//    
//    func titleForUIState(uistate:DYUIState)->NSAttributedString? {
//        return stateModels?[uistate]?.title
//    }
//    
//    func descriptionForUIState(uistate:DYUIState)->NSAttributedString? {
//        return stateModels?[uistate]?.description
//    }
//    
//    func imageForUIState(uistate:DYUIState)->UIImage? {
//        return stateModels?[uistate]?.image
//    }
//    
//    func imageTintColorForUIState(uistate:DYUIState)->UIColor? {
//        return stateModels?[uistate]?.imageTintColor
//    }
//    
//    func buttonTitleForUIState(uistate:DYUIState, buttonState:UIControlState)->NSAttributedString? {
//        return stateModels?[uistate]?.imageTintColor
//    }
//    
//    func buttonImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage? {
//        
//    }
//    
//    func buttonBackgroundImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage? {
//        
//    }
//    
//    func backgroundColorForUIState(uistate:DYUIState)->UIColor? {
//        
//    }
//    
//    func customViewForUIState(uistate:DYUIState)->UIView? {
//        
//    }
//    
//    func verticleOffsetForUIState(uistate:DYUIState) -> CGFloat {
//        
//    }
//    
//    func spaceHeightForUIState(uistate:DYUIState) -> CGFloat {
//        
//    }
//}

private var dynDYUIStateDateSource = "dyn.key.viewcontroller.state.datasource"
private var dynDYUIStateDelegate = "dyn.key.viewcontroller.state.delegate"
private var dynDYUIStateView = "dyn.key.viewcontroller.state.stateview"
private var dynDYUIStateCurrentState = "dyn.key.viewcontroller.state.current"

extension UIViewController : DYUIStateViewDelegate {
    var dy_state : DYUIState {
        get {
            let nState = self.dy_getAssociatedObject(&dynDYUIStateCurrentState, 
                                                     policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) { () -> NSNumber in
                                                        return NSNumber(int:0)
            }
            return DYUIState(rawValue: nState!.intValue)!
        }
        
        set {
            self.dy_setAssociatedObject(&dynDYUIStateCurrentState, 
                                        value: NSNumber(int:newValue.rawValue),
                                        policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    var dy_stateDataSource : DYUIStateDateSource? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDateSource, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: { 
                                                                return WeakWrapper();
            }) else {
                DYLog.error("dy_stateDataSource wrapper alloc failed")
                return nil
            }
            
            return wrapper.target as? DYUIStateDateSource
        }
        
        set {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDateSource, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, 
                                                            initial: { 
                                                                return WeakWrapper();
            }) else {
                DYLog.error("dy_stateDataSource wrapper alloc failed")
                return
            }
            
            wrapper.target = newValue
            
            if newValue == nil {
                dy_invalidate(self.dy_state)
            }
        }
    }
    
    var dy_stateDelegate : DYUIStateDelegate? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDelegate, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, 
                                                            initial: { 
                                                                return WeakWrapper()
            }) else {
                DYLog.error("dy_stateDelegate wrapper alloc failed")
                return nil
            }
            
            return wrapper.target as? DYUIStateDelegate
        }
        
        set {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDelegate, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, 
                                                            initial: { 
                                                                return WeakWrapper();
            }) else {
                DYLog.error("dy_stateDelegate wrapper alloc failed")
                return
            }
            
            wrapper.target = newValue
            if newValue == nil {
                dy_invalidate(self.dy_state)
            }
        }
    }
    
    var dy_stateView : DYUIStateView? {
        get {
            let stateView = self.dy_getAssociatedObject(&dynDYUIStateView, 
                                                        policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) { () -> DYUIStateView in
                                                            let view = DYUIStateView(frame:UIScreen.mainScreen().bounds)
                                                            view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                                                            view.hidden = true;
                                                            
                                                            let tapGesture = UITapGestureRecognizer.init(target: view, action: #selector(DYUIStateView.didTapContent(_:)))
                                                            tapGesture.delegate = view;
                                                            view.addGestureRecognizer(tapGesture)
                                                            return view
            }
            
            
            return stateView
        }
    }
    
    //MARK: Public
    public func reloadState(uistate:DYUIState) {
        if !dy_canDisplay(uistate) {
            return
        }
        
        guard let view = self.dy_stateView else {
            return
        }
        
        self.dy_state = uistate
        
        if dy_shouldDisplay(uistate) {
            
            dy_willAppear(uistate)
            
            if view.superview != nil {
                guard let superview = self.dy_superView(uistate) else {
                    return
                }
                
                superview.addSubview(view)
                superview.sendSubviewToBack(view)
            }
            
            view.prepareForReuse()
            
            let customView = dy_customView(uistate)
            if customView == nil {
                view.verticalSpace = dy_verticalSpace(uistate)
                
                //配置image
                if let image = dy_image(uistate) {
                    let imageTintColor = dy_imageTintColor(uistate)
                    let renderingMode = imageTintColor != nil ? UIImageRenderingMode.AlwaysTemplate : UIImageRenderingMode.AlwaysOriginal
                    view.imageView.image = image.imageWithRenderingMode(renderingMode)
                    view.imageView.tintColor = imageTintColor
                }
                
                //配置title
                if let titleLabelString = dy_titleLabelString(uistate) {
                    view.titleLabel.attributedText = titleLabelString
                }
                
                //配置detail
                if let detailLabelString = dy_detailLabelString(uistate) {
                    view.detailLabel.attributedText = detailLabelString
                }
                
                //配置button
                if let buttonImage = dy_buttonImageForState(uistate, buttonState: UIControlState.Normal) {
                    view.button.setImage(buttonImage, 
                                         forState: UIControlState.Normal)
                    view.button.setImage(dy_buttonImageForState(uistate, buttonState: UIControlState.Highlighted), 
                                         forState: UIControlState.Highlighted)
                } else if let buttonTitle = dy_buttonTitleForState(uistate, buttonState: UIControlState.Normal) {
                    view.button.setAttributedTitle(buttonTitle, 
                                                   forState: UIControlState.Normal)
                    view.button.setAttributedTitle(dy_buttonTitleForState(uistate, buttonState: UIControlState.Highlighted), 
                                                   forState: UIControlState.Highlighted)
                    view.button.setBackgroundImage(dy_buttonImageForState(uistate, buttonState: UIControlState.Normal), 
                                                   forState: UIControlState.Normal)
                    view.button.setBackgroundImage(dy_buttonImageForState(uistate, buttonState: UIControlState.Highlighted), 
                                                   forState: UIControlState.Highlighted)
                }
            } else {
                view.customView = customView
            }
            
            view.verticalOffset = dy_verticalOffset(uistate)
            view.backgroundColor = dy_backgroundColor(uistate)
            view.hidden = false
            view.clipsToBounds = true
            
            view.userInteractionEnabled = dy_isTouchAllowed(uistate)
            
            view.setupConstraints()
            view.layoutIfNeeded()
            
            dy_didAppear(uistate)
        }
        else if view.superview != nil {
            dy_invalidate(uistate)
        }
    }
    
    private func dy_invalidate(uistate:DYUIState) {
        dy_willDisappear(uistate)
        if let view = self.dy_stateView {
            view.prepareForReuse()
            view.removeFromSuperview()
        }
        dy_didDisappear(uistate)
    }
    
    //MARK: DYUIStateViewDelegate
    func didTapButton(view: DYUIStateView, sender: AnyObject) {
        DYLog.info("didTapButton")
    }
    
    func didTapContentView(view: DYUIStateView, sender: AnyObject) {
        DYLog.info("didTapContentView")
    }
    
    func isTouchAllowed(view:DYUIStateView) -> Bool {
        return dy_isTouchAllowed(self.dy_state)
    }
    
    //MARK: Private DateSource gettter
    private func dy_canDisplay(uistate:DYUIState) -> Bool {
        return self.dy_stateDataSource != nil
    }
    
    private func dy_superView(uistate:DYUIState) -> UIView? {
        return self.dy_stateDataSource?.superViewForUIState(uistate)
    }
    
    private func dy_titleLabelString(uistate:DYUIState) -> NSAttributedString? {
        return self.dy_stateDataSource?.titleForUIState(uistate)
    }
    
    private func dy_detailLabelString(uistate:DYUIState) -> NSAttributedString? {
        return self.dy_stateDataSource?.descriptionForUIState(uistate)
    }
    
    private func dy_image(uistate:DYUIState) -> UIImage? {
        return self.dy_stateDataSource?.imageForUIState(uistate)
    }
    
    private func dy_imageTintColor(uistate:DYUIState) -> UIColor? {
        return self.dy_stateDataSource?.imageTintColorForUIState(uistate)
    }
    
    private func dy_buttonTitleForState(uistate:DYUIState, buttonState:UIControlState) -> NSAttributedString? {
        return self.dy_stateDataSource?.buttonTitleForUIState(uistate, buttonState: buttonState)
    }
    
    private func dy_buttonImageForState(uistate:DYUIState, buttonState:UIControlState) -> UIImage? {
        return self.dy_stateDataSource?.buttonImageForUIState(uistate, buttonState: buttonState)
    }
    
    private func dy_buttonBackgroundImageForState(uistate:DYUIState, buttonState:UIControlState) -> UIImage? {
        return self.dy_stateDataSource?.buttonBackgroundImageForUIState(uistate, buttonState: buttonState)
    }
    
    private func dy_backgroundColor(uistate:DYUIState) -> UIColor {
        guard let color = self.dy_stateDataSource?.backgroundColorForUIState(uistate)
            else {
                return UIColor.clearColor()
        }
        return color
    }
    
    private func dy_customView(uistate:DYUIState) -> UIView? {
        return self.dy_stateDataSource?.customViewForUIState(uistate)
    }
    
    private func dy_verticalOffset(uistate:DYUIState) -> CGFloat {
        guard let offset = self.dy_stateDataSource?.verticleOffsetForUIState(uistate)
            else {
                return 0
        }
        return offset
    }
    
    private func dy_verticalSpace(uistate:DYUIState) -> CGFloat {
        guard let space = self.dy_stateDataSource?.spaceHeightForUIState(uistate)
            else {
                return 0
        }
        return space
    }
    
    //MARK: Private Delegate gettter
    private func dy_shouldDisplay(uistate:DYUIState) -> Bool {
        guard let display = self.dy_stateDelegate?.shouldDisplayForUIState(uistate)
            else {
                return true
        }
        return display
    }
    
    private func dy_isTouchAllowed(uistate:DYUIState) -> Bool {
        guard let allow = self.dy_stateDelegate?.shouldAllowTouchForUIState(uistate)
            else {
                return true
        }
        return allow
    }
    
    private func dy_willAppear(uistate:DYUIState) {
        self.dy_stateDelegate?.willAppearForUIState(uistate)
    }
    
    private func dy_didAppear(uistate:DYUIState) {
        self.dy_stateDelegate?.didAppearForUIState(uistate)
    }
    
    private func dy_willDisappear(uistate:DYUIState) {
        self.dy_stateDelegate?.willDisappearForUIState(uistate)
    }
    
    private func dy_didDisappear(uistate:DYUIState) {
        self.dy_stateDelegate?.didDisappearForUIState(uistate)
    }
    
    private func dy_didTapContentView(sender:AnyObject, uistate:DYUIState) -> Void {
        self.dy_stateDelegate?.didTapViewForUIState(uistate)
    }
    
    private func dy_didTapDataButton(sender:AnyObject, uistate:DYUIState) -> Void {
        self.dy_stateDelegate?.didTapButtonForUIState(uistate)
    }
}

@objc
protocol DYUIStateViewDelegate : class {
    func didTapButton(view:DYUIStateView, sender:AnyObject) -> Void;
    func didTapContentView(view:DYUIStateView, sender:AnyObject) -> Void;
    func isTouchAllowed(view:DYUIStateView) -> Bool
    optional
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

public class DYUIStateView: UIView, UIGestureRecognizerDelegate {
    override public init(frame:CGRect) {
        super.init(frame: frame)
        
        if self.contentView.superview == nil {
            self.addSubview(self.contentView)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if self.contentView.superview == nil {
            self.addSubview(self.contentView)
        }
    }
    
    var delegate : DYUIStateViewDelegate? = nil
    
    lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clearColor()
        contentView.userInteractionEnabled = true;
        contentView.alpha = 0
        return contentView
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        imageView.userInteractionEnabled = false;
        imageView.accessibilityIdentifier = "state background image";
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(27.0);
        titleLabel.textColor = UIColor(white:0.6, alpha: 1)
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.accessibilityIdentifier = "state title";
        
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var detailLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(17.0);
        titleLabel.textColor = UIColor(white:0.6, alpha: 1)
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.accessibilityIdentifier = "state detail title";
        
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var button : UIButton  = {
        let button = UIButton(type:UIButtonType.Custom)
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = UIColor.clearColor()
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center;
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center;
        button.accessibilityIdentifier = "state button";
        button.addTarget(self, action: #selector(DYUIStateView.didTapButton(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    var customView : UIView? = nil {
        didSet {
            if (oldValue != nil) {
                oldValue!.removeFromSuperview()
            }
            
            guard let customView = customView else {
                return
            }
            
            customView.translatesAutoresizingMaskIntoConstraints = false;
            self.contentView.addSubview(customView)
        }
    }
    var tapGesture : UITapGestureRecognizer?
    
    var verticalOffset : CGFloat = 0
    var verticalSpace : CGFloat = 0
    
    
    private func canShowImage() -> Bool {
        return self.imageView.image != nil && self.imageView.superview != nil
    }
    
    private func canShowTitle() -> Bool {
        guard let aText = self.titleLabel.attributedText else {
            return false
        }
        
        return aText.string.characters.count>0 && self.titleLabel.superview != nil
    }
    
    private func canShowDetail() -> Bool {
        guard let aText = self.detailLabel.attributedText else {
            return false
        }
        
        return aText.string.characters.count>0 && self.detailLabel.superview != nil
    }
    
    private func canShowButton() -> Bool {
        let aText = self.button.attributedTitleForState(UIControlState.Normal)
        let image = self.button.imageForState(UIControlState.Normal)
        if (aText==nil || aText!.string.characters.count <= 0) && image==nil {
            return false
        }
        
        return self.button.superview != nil
    }
    
    
    //MARK: Action
    @objc
    private func didTapButton(sender:AnyObject) {
        delegate?.didTapButton(self, sender: sender)
    }
    
    @objc
    private func didTapContent(sender:AnyObject) {
        delegate?.didTapContentView(self, sender: sender)
    }
    
    //MARK: UIGestureRecognizerDelegate
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.isEqual(gestureRecognizer.view) {
            return (delegate?.isTouchAllowed(self))!
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let tapGesture = self.tapGesture
        if gestureRecognizer == tapGesture || otherGestureRecognizer == tapGesture {
            return true
        }
        
        let hasGestureRecognizer = delegate?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: otherGestureRecognizer)
        return hasGestureRecognizer!
    }
    
    
    //MARK:内部方法
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        self.contentView.removeConstraints(self.contentView.constraints)
    }
    
    func prepareForReuse() {
        self.contentView.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        
        //        self.titleLabel = nil
        //        self.detailLabel = nil
        //        self.imageView = nil
        //        self.button = nil
        self.customView = nil
        
        self.removeAllConstraints()
    }
    
    
    func setupConstraints() {
        // contentView约束
        // 居中
        let centerXConstraint = self.dy_equallyRelatedConstraintWithView(self.contentView, attribute: NSLayoutAttribute.CenterX)
        let centerYConstraint = self.dy_equallyRelatedConstraintWithView(self.contentView, attribute: NSLayoutAttribute.CenterY)
        self.addConstraint(centerXConstraint)
        self.addConstraint(centerYConstraint)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|" ,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["contentView": self.contentView]))
        
        if self.verticalOffset != 0 && self.constraints.count > 0 {
            centerYConstraint.constant = self.verticalOffset
        }
        
        if let customView = self.customView  {
            customView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[customView]|" ,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["customView": customView]))
            
            customView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[customView]|" ,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["customView": customView]))
        } else {
            var width = Float(self.frame.size.width)
            width = width > 0 ? width : Float(UIScreen.mainScreen().bounds.size.width);
            
            let padding =  UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 20.0 : roundf(width/16.0);
            let verticalSpace = self.verticalSpace > 0 ? self.verticalSpace : 11.0;
            
            var subviewStrings = [String]();
            var views = [String:UIView]();
            let metrics = ["padding": padding];
            
            // Assign the image view's horizontal constraints
            if self.imageView.superview != nil {
                subviewStrings.append("imageView")
                
                views["imageView"] = self.imageView;
                self.contentView.addConstraint(self.contentView.dy_equallyRelatedConstraintWithView(self.imageView,
                    attribute: NSLayoutAttribute.CenterX));
            }
            
            // Assign the title label's horizontal constraints
            if (canShowTitle()) {
                subviewStrings.append("titleLabel")
                views["titleLabel"] = self.titleLabel;
                self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[titleLabel(>=0)]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            }
                // or removes from its superview
            else {
                self.titleLabel.removeFromSuperview()
            }
            
            // Assign the detail label's horizontal constraints
            if (canShowDetail()) {
                subviewStrings.append("detailLabel")
                views["detailLabel"] = self.detailLabel;
                self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[detailLabel(>=0)]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            }
                // or removes from its superview
            else {
                self.detailLabel.removeFromSuperview()
            }
            
            // Assign the button's horizontal constraints
            if (canShowButton()) {
                subviewStrings.append("button")
                views["button"] = self.button;
                self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[button(>=0)]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            }
                // or removes from its superview
            else {
                self.button.removeFromSuperview()
            }
            
            let verticalFormat = NSMutableString()
            
            // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
            for i in 0 ..< subviewStrings.count {
                let string = subviewStrings[i];
                verticalFormat.appendFormat("[%@]", string)
                
                if (i < subviewStrings.count-1) {
                    verticalFormat.appendFormat("-(%.f)-", verticalSpace)
                }
            }
            
            // Assign the vertical constraints to the content view
            if (verticalFormat.length > 0) {
                self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(String(format: "V:|%@|", verticalFormat),
                    options:NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            }
        }
    }
    
}


extension UIView {
    func dy_equallyRelatedConstraintWithView(view:UIView, attribute:NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: attribute,
                                  relatedBy: NSLayoutRelation.Equal,
                                  toItem: self,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0.0)
    }
}