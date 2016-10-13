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
    static let kCountPerWordMode : Int32 = 4
    
    @NSManaged var words : [WordData]
    @NSManaged var modes : [LearnModeData]
    @NSManaged var questions : AVRelation
    /**每个单词每个mode创建的question数目*/
    @NSManaged var countPerWordMode : Int32;
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    
    static func parseClassName() -> String! {
        return "WordTestData"
    }
    
    override init() {
        super.init()
        self.countPerWordMode = WordTestData.kCountPerWordMode
    }
    
    static func createTest(words:[WordData], modes:[LearnModeData],
                           countPerWordMode:Int, block: AVObjectResultBlock!) {
        if words.count < 4 || modes.count <= 0 || countPerWordMode <= 0 {
            block(nil, nil)
            return
        }
        
        let count = words.count
        for mode in modes {
            for index in 0..<count {
                let mainWord = words[index]
                var optionWords = words
                optionWords.removeAtIndex(index)
                optionWords = optionWords.randomSubArray(count:3)
                WordQuestionData.createQuestion(mainWord,
                                                mode: mode,
                                                optionWords: optionWords,
                                                block: { (question, error) in
                                                    
                })
            }
        }
    }
}
