//
//  WordSentenceData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordSentenceData: AVObject, AVSubclassing {
    @NSManaged var word : WordData
    @NSManaged var sentence: SentenceData
    
    //单词起始位置
    @NSManaged var wordStart : Int32
    //单词长度
    @NSManaged var wordLength : Int32
    
    static func parseClassName() -> String! {
        return "WordSentenceData"
    }
}
