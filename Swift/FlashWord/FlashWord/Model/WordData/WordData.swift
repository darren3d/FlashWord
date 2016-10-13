//
//  WordData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordData: AVObject, AVSubclassing {
    @NSManaged var word : String
    @NSManaged var desc : [String]
    
    @NSManaged var britishSoundUrl : String
    @NSManaged var americanSoundUrl : String
    
    //复数
    @NSManaged var plural  : String
    //现在分词
    @NSManaged var presentParticiple  : String
    //过去分词，一般表示持续性的动作,一般与has,have连用
    @NSManaged var pastParticiple  : String
    //过去式，过去某一刻做的什么事,短暂性的动作
    @NSManaged var pastForm  : String
    
    static func parseClassName() -> String! {
        return "WordData"
    }
}
