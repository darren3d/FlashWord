//
//  DYRandom.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

struct DYRandom {
    //从区间[start, end)随机生成count个数
    static func random(start:Int, end: Int, count: Int) -> [Int] {
        if start >= end || count <= 0 || count > end - start {
            return []
        }
        
        var startArr =  [Int](start ..< end)
        var resultArr = [Int](count: count, repeatedValue: 0)
        for i in 0..<count {
            let currentCount = startArr.count - i
            let index = Int(arc4random_uniform(UInt32(currentCount)))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[currentCount - 1]
        }
        return resultArr
    }
 }
