//
//  WordBookData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordBookData: AVObject, AVSubclassing {
    @NSManaged var name : String
    @NSManaged var desc : String
    @NSManaged var creator : AccountData
    @NSManaged var words : AVRelation
    
    //暂时存储单词数，非实时准确
    @NSManaged var countWord : Int
    //非持久化，用于存储获取的单词
    dynamic var wordDatas : [WordData] = []
    dynamic var hasNoMoreWord : Bool = false
    
    static func parseClassName() -> String! {
        return "WordBookData"
    }
}

@objc
class MyWordBookData: AVObject, AVSubclassing {
     struct BookType {
        static let Default = ""
        static let NewWord = "word.book.type.new.word"
    }
    @NSManaged var book : WordBookData
    @NSManaged var learner : AccountData
    @NSManaged var tests : AVRelation
    @NSManaged var type : String
    
    @NSManaged var timeAvg : Int
    @NSManaged var countLearn : Int
    @NSManaged var masterDegree : Float
    
    static func parseClassName() -> String! {
        return "MyWordBookData"
    }
}
