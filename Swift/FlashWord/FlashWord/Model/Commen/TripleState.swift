//
//  TripleState.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

typealias TripleState = Int32

extension TripleState {
    /**状态1，未点赞，未收藏等*/
    static let StateNo                  = Int32(0x0000)
    /**收藏或取消收藏请求中*/
    static let StateChanging        = 0x1000
    /**状态2，已点赞，已藏等*/
    static let StateYes                = 0x0001
    static let StateMask              = 0x0FFF
}
