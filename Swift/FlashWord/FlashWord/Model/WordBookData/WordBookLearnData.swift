//
//  WordBookLearnData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordBookLearnData: AVObject, AVSubclassing {
    @NSManaged var book : WordBookData
    @NSManaged var learner : AccountData
    @NSManaged var learnMode : LearnModeData
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    
    static func parseClassName() -> String! {
        return "WordBookLearnData"
    }
}
