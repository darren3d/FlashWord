//
//  DYListCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

@objc
class DYListCellVM: DYViewModel {
    var width : CGFloat = 0
    init(data: AnyObject?, width: CGFloat) {
        self.width = width
        super.init(data: data)
    }
}
