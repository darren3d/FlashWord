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
    @NSManaged var tests : AVRelation
    
    static func parseClassName() -> String! {
        return "WordBookData"
    }
}


extension WordBookData {
    /**进行中的测试*/
    func currentWordTest(cachePolicy:AVCachePolicy = AVCachePolicy.CacheOnly, block: AVObjectResultBlock!) {
        let query = tests.query()
        query.cachePolicy = cachePolicy
        query.whereKeyDoesNotExist("timeEnd")
        query.getFirstObjectInBackgroundWithBlock(block)
    }
    
//    /**添加一个新的test*/
//    func addWordTest(words:[WordData], modes:[LearnModeData], block: AVObjectResultBlock!) {
//        let test = WordTestData()
//        test.addObjectsFromArray(words, forKey: "words")
//        test.addObjectsFromArray(modes, forKey: "modes")
//        
//        
//    }
}
