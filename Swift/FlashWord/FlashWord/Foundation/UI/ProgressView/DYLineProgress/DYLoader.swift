//
//  DYLoader.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

@objc protocol DYLoaderProtocol {
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