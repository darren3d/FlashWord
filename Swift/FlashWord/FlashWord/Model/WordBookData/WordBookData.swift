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
    
    static func parseClassName() -> String! {
        return "WordBookData"
    }
}

@objc
class MyWordBookData: AVObject, AVSubclassing {
    static let NewWord = "word.book.type.new.word"
    @NSManaged var book : WordBookData
    @NSManaged var learner : AccountData
    @NSManaged var tests : AVRelation
    @NSManaged var type : String
    
    static func parseClassName() -> String! {
        return "MyWordBookData"
    }
}
