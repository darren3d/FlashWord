//
//  WordQuestionData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

@objc
class WordQuestionData: AVObject, AVSubclassing {
    @NSManaged var mode : LearnModeData
    @NSManaged var word : WordData
    @NSManaged var sentence : SentenceData?
    @NSManaged var optionWords : [WordData]
    @NSManaged var answers : [WordAnswerData]
    
    init(word:WordData, mode: LearnModeData, optionWords:[WordData]) {
        super.init()
        self.word = word
        self.mode = mode
        self.optionWords = []
        self.addUniqueObjectsFromArray(optionWords, forKey: "optionWords")
    }
    
    static func parseClassName() -> String! {
        return "WordQuestionData"
    }
    
    static func createQuestion(word:WordData, mode: LearnModeData, optionWords:[WordData])
        -> SignalProducer<WordQuestionData!, NSError> {
        let producer = SignalProducer<WordQuestionData!, NSError>{ (observer, dispose) in
            let question = WordQuestionData(word: word, mode: mode, optionWords: optionWords)

            question.saveInBackgroundWithBlock({ (succeed, error) in
                if error == nil {
                    if succeed {
                        observer.sendNext(question)
                    } else {
                        observer.sendNext(nil)
                    }
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(error)
                }
            })
        }
        return producer
    }

    static func createQuestion_deprecate(word:WordData, mode: LearnModeData, optionWords:[WordData])
        -> SignalProducer<WordQuestionData!, NSError> {
        let producer = SignalProducer<WordQuestionData!, NSError>{ (observer, dispose) in
            let question = WordQuestionData(word: word, mode: mode, optionWords: optionWords)
            
            if mode.mode == LearnMode.SentenceChoice || mode.mode == LearnMode.SentenceSpell  {
                let query = AVQuery(className: "WordSentenceData")
                query.whereKey("word", equalTo: word)
                query.getFirstObjectInBackgroundWithBlock({ (relationData, error) in
                    if error != nil {
                        observer.sendFailed(error)
                        return
                    }
                    
                    guard let relationData = relationData as? WordSentenceData
                        else {
                            observer.sendNext(nil)
                            observer.sendCompleted()
                            return
                    }
                    
                    question.sentence = relationData.sentence
                    observer.sendNext(question)
                    observer.sendCompleted()
                })
            } else {
                question.saveInBackgroundWithBlock({ (succeed, error) in
                    if error == nil {
                        if succeed {
                            observer.sendNext(question)
                        } else {
                            observer.sendNext(nil)
                        }
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(error)
                    }
                })
            }
        }
        return producer
    }
}
