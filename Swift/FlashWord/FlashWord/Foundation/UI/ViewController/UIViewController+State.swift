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
extension UIViewController {
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
        
    }
    
    func setupConstraints() {
        
    }
    
    func prepareForReuse() {
    }
    
    
}