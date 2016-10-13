//
//  WordQuestionData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordQuestionData: AVObject, AVSubclassing {
    @NSManaged var mode : LearnModeData
    @NSManaged var word : WordData
    @NSManaged var sentence : SentenceData
    @NSManaged var optionWords : [WordData]
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    @NSManaged var successCount : Int32
    @NSManaged var failureCount : Int32
    
    static func parseClassName() -> String! {
        return "WordQuestionData"
    }
}
