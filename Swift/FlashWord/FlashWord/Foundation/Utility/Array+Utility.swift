//
//  Array+Utility.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension Array {
    //MARK - 返回含count个元素的随机子数组
    func randomSubArray(count count : Int) -> [Element] {
        var result:[Element] = []
        
        let size = self.count
        if size <= 0 || count <= 0 || count > size {
            return result
        }
        
        let random = DYRandom.random(0, end: size, count: count)
        for index in random {
            let ele = self[index]
            result.append(ele)
        }
        return result
    }
}
