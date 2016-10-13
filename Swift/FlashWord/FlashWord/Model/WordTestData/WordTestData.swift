//
//  WordTestData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordTestData: AVObject, AVSubclassing {
    @NSManaged var words : [WordData]
    @NSManaged var questions : AVRelation
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    
    static func parseClassName() -> String! {
        return "WordTestData"
    }
}
