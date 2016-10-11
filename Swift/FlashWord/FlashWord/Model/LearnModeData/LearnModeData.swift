//
//  LearnModeData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

typealias LearnMode = Int32

extension LearnMode {
    /**单词释义，英译汉，选择题*/
    static let EnglishToChinese = Int32(0)
     /**单词释义，汉译英，选择题*/
    static let ChineseToEnglishChoice = Int32(1)
    /**单词释义，汉译英，拼写题*/
    static let ChineseToEnglishSpell = Int32(2)
    /**选词填空，汉译英，选择题*/
    static let SentenceChoice = Int32(3)
     /**例句填空，汉译英，拼写题*/
    static let SentenceSpell = Int32(4)
}

class LearnModeData: AVObject, AVSubclassing {
    @NSManaged var mode : LearnMode
    @NSManaged var title : String
    @NSManaged var desc : String
    
    static func parseClassName() -> String! {
        return "LearnModeData"
    }
}

class UserLearnModeData: AVObject, AVSubclassing {
    @NSManaged var mode : LearnModeData
    @NSManaged var user : AccountData
    @NSManaged var likeState : TripleState
    
    static func parseClassName() -> String! {
        return "UserLearnModeData"
    }
}
