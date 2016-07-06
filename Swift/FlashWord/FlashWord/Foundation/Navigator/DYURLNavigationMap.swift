//
//  DYURLNavigationMap.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYURLNavigationMap {
    
    static func setup() {
        Navigator.scheme = "flashword"
        
        Navigator.map("/login", LoginController.self)
        Navigator.map("/register", RegisterController.self)
    }
    
}