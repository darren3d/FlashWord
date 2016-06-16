//
//  UIViewController+State.swift
//  FlashWord
//
//  Created by darren on 16/6/16.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

public enum DYUIState : String {
    case Init = "init"
    case Loading = "loading"
    case Content = "content"
    case Empty = "empty"
    case Warning = "warning"
    case Error = "error"
}

public protocol DYUIStateDateSource : class {
    func titleForUIState(uistate:DYUIState)->NSAttributedString
    func descriptionForUIState(uistate:DYUIState)->NSAttributedString
    func imageForUIState(uistate:DYUIState)->UIImage
    func imageTintColorForUIState(uistate:DYUIState)->UIColor
    func buttonTitleForUIState(uistate:DYUIState, buttonState:UIControlState)->NSAttributedString
    func buttonImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage
    func buttonBackgroundImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage
    func buttonBackgroundColorForUIState(uistate:DYUIState, buttonState:UIControlState)->UIColor
    func customViewForUIState(uistate:DYUIState, buttonState:UIControlState)->UIView
    func offsetForUIState(uistate:DYUIState) -> CGPoint
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


private var dynDYUIStateDateSource = "dyn.key.viewcontroller.state.datasource"
private var dynDYUIStateDelegate = "dyn.key.viewcontroller.state.delegate"
extension UIViewController : DYUIStateViewDelegate{
    var dy_stateDataSource : DYUIStateDateSource? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDateSource, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: { 
                                                                return WeakWrapper();
            }) else {
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
                return
            }
            
            wrapper.target = newValue
        }
    }
    
    var dy_stateDelegate : DYUIStateDelegate? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&dynDYUIStateDelegate, 
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, 
                                                            initial: { 
                                                                return WeakWrapper();
            }) else {
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
                return
            }
            
            wrapper.target = newValue
        }
    }
    
    
    //MARK: DYUIStateViewDelegate
    func didTapButton(view: DYUIStateView, sender: AnyObject) {
        
    }
}


protocol DYUIStateViewDelegate : class {
    func didTapButton(view:DYUIStateView, sender:AnyObject) -> Void;
}

class DYUIStateView: UIView {
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        if self.contentView.superview == nil {
            self.addSubview(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
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