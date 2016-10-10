//
//  DYTabBar.swift
//  DYTabBarController
//
//  Created by darren on 16/8/12.
//  Copyright © 2016年 flashword. All rights reserved.
//

import UIKit

class DYTabBar: UITabBar {
    private var colorTab : UIView? = nil
    
    override func addSubview(view: UIView) {
        guard let view = view as? DYColorTab else {
            return
        }
        super.addSubview(view)
        colorTab = view
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let colorTab = colorTab as? DYColorTab else {
            return
        }
        
        let frame = self.bounds
        colorTab.center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        colorTab.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 12)
    }
}
