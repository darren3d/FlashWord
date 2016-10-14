//
//  WordTestData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

@objc
class WordTestPara: AVObject, AVSubclassing {
    //限制字典key值必须为String
    @NSManaged var countPerMode : [String : Int]
    override init() {
        super.init()
        
        countPerMode = [:]
    }
    static func parseClassName() -> String! {
        return "WordTestPara"
    }
}

@objc
class WordTestData: AVObject, AVSubclassing {
    static let kCountPerWordMode : Int32 = 4
    
    @NSManaged var words : [WordData]
    @NSManaged var modes : [LearnModeData]
    @NSManaged var para : WordTestPara
    
    @NSManaged var questions : AVRelation
    @NSManaged var timeStart : NSDate
    @NSManaged var timeEnd : NSDate
    
    static func parseClassName() -> String! {
        return "WordTestData"
    }
    
    private override init() {
        super.init()
        
        self.words = []
        self.modes = []
    }
    
    static func createTest(words:[WordData], modes:[LearnModeData], para:WordTestPara)
        -> SignalProducer<WordTestData!, NSError> {
                if words.count < 4 || modes.count <= 0 || para.countPerMode.count <= 0 {
                    return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数不合法"]))
                }
            
            let producer = SignalProducer<WordTestData!, NSError>{ (observer, dispose) in
                var localQuestions : [WordQuestionData] = []
                
                let count = words.count
                for mode in modes {
                    var questionCount = (para.countPerMode[String(mode.mode)]) ?? 0
                    while questionCount > 0{
                        questionCount -= 1
                        
                        for index in 0..<count {
                            let mainWord = words[index]
                            var optionWords = words
                            optionWords.removeAtIndex(index)
                            optionWords = optionWords.randomSubArray(count:3)
                            localQuestions.append(WordQuestionData(word: mainWord, mode: mode, optionWords: optionWords))
                        }
                    }
                }
                
                if localQuestions.count <= 0 {
                    observer.sendNext(nil)
                    observer.sendCompleted()
                } else {
                    var localObjs : [AnyObject] = localQuestions
                    localObjs.append(para)
                    AVObject.saveAllInBackground(localObjs) { (succeed, error) in
                        if error == nil {
                            if succeed {
                                let test = WordTestData()
                                test.addUniqueObjectsFromArray(words, forKey: "words")
                                test.addUniqueObjectsFromArray(modes, forKey: "modes")
                                test.para = para
                                
                                for quest in localQuestions {
                                    test.questions.addObject(quest)
                                }
                                
                                test.saveInBackgroundWithBlock({ (succeed, error) in
                                    if error == nil {
                                        if succeed {
                                            observer.sendNext(test)
                                        } else {
                                            observer.sendNext(nil)
                                        }
                                        observer.sendCompleted()
                                    } else {
                                        observer.sendFailed(error)
                                    }
                                })
                                return
                            }
                            
                            observer.sendNext(nil)
                            observer.sendCompleted()
                        } else {
                            observer.sendFailed(error)
                        }
                    }
                }
            }
            return producer
    }
}
