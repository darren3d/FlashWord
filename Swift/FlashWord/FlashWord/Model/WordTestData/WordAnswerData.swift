//
//  WordAnswerData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

class WordAnswerData: AVObject, AVSubclassing {
    /**选择题选中的word*/
    @NSManaged var word : WordData
    /**拼写填空题输入的单词*/
    @NSManaged var spell : String
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    @NSManaged var state : TripleState
    
    override init() {
        super.init()
        state = TripleState.StateChanging
    }
}
