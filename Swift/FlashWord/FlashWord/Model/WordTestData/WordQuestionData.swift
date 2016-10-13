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
    @NSManaged var sentence : SentenceData?
    @NSManaged var optionWords : [WordData]
    @NSManaged var answers : [WordAnswerData]
    
    static func parseClassName() -> String! {
        return "WordQuestionData"
    }
    
    static func createQuestion(word:WordData, mode: LearnModeData, optionWords:[WordData], block: AVObjectResultBlock!) {
        
        let question = WordQuestionData()
        question.word = word
        question.mode = mode
        question.optionWords = optionWords
        
        if mode.mode == LearnMode.SentenceChoice || mode.mode == LearnMode.SentenceSpell  {
            let query = AVQuery(className: "WordSentenceData")
            query.whereKey("word", equalTo: word)
            query.getFirstObjectInBackgroundWithBlock({ (relationData, error) in
                if error != nil {
                    block(nil, error)
                    return
                }
                
                guard let relationData = relationData as? WordSentenceData?,
                let sentence = relationData?.sentence
                else {
                    block(nil, nil)
                    return
                }
                
                question.sentence = sentence
                block(question, error)
            })
        } else {
            question.saveInBackgroundWithBlock({ (succeed, error) in
                if succeed && error == nil {
                    block(question, nil)
                } else {
                    block(nil, error)
                }
            })
        }
    }
}
