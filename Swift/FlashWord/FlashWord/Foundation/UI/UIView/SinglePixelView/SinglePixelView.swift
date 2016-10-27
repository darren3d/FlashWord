//
//  SinglePixelView.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/27.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

enum SinglePixelType {
    case Height
    case Width
    case All
}

class SinglePixelView: UIView {
    private var widthContraint : NSLayoutConstraint?
    private var heightContraint : NSLayoutConstraint?
    private var widthFromIB : CGFloat = -1
    private var heightFromIB : CGFloat = -1
    
    var singlePixelType : SinglePixelType = SinglePixelType.Height {
        didSet {
            switch singlePixelType {
            case .Height:
                widthContraint?.constant = widthFromIB
                heightContraint?.constant = heightFromIB * AppConst.dotPerPixel
                break
            case .Width:
                widthContraint?.constant = widthFromIB * AppConst.dotPerPixel
                heightContraint?.constant = heightFromIB
                break
            case .All:
                widthContraint?.constant = widthFromIB * AppConst.dotPerPixel
                heightContraint?.constant = heightFromIB * AppConst.dotPerPixel
                break
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for constraint in self.constraints {
            guard let item = constraint.firstItem as? NSObject else {
                continue
            }
            
            if constraint.firstAttribute == NSLayoutAttribute.Width && item == self {
                widthContraint = constraint
                widthFromIB = constraint.constant
            }
            
            if constraint.firstAttribute == NSLayoutAttribute.Height && item == self{
                heightContraint = constraint
                heightFromIB = constraint.constant
            }
            
            if (widthContraint != nil && heightContraint != nil) {
                break;
            }
        }
        
        self.singlePixelType = SinglePixelType.Height
    }
}
