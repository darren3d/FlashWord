//
//  DYViewController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class DYViewController : UIViewController {
    dynamic var viewModel : DYViewModel?
    dynamic var isFirstAppear : Bool = true
    
    deinit {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (isFirstAppear) {
            self.viewFirstWillAppear();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (isFirstAppear) {
            self.viewFirstDidAppear();
            
            dispatch_async(dispatch_get_main_queue()) {
                self.isFirstAppear = false
            }
        }
    }
    
    func viewFirstWillAppear() {
    }
    
    func viewFirstDidAppear() {
    }
}
