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
    @NSManaged var desc : [[String : AnyObject]]
    
    @NSManaged var phonationEn : String
    @NSManaged var phonationAm : String
    @NSManaged var sentences : AVRelation
    //非持久化，用于存储获取的单词
    dynamic var sentenceDatas : [WordSentenceData] = []
    dynamic var hasNoMoreSentence : Bool = false
    
    //第三人称单数数
    @NSManaged var formThird  : String
    //复数
    @NSManaged var formPlural  : String
    //比较级
    @NSManaged var formCompare  : String
    //最高级
    @NSManaged var formSuper  : String
    
    //现在分词
    @NSManaged var formPresent  : String
    //过去分词，一般表示持续性的动作,一般与has,have连用
    @NSManaged var formPastParticiple  : String
    //过去式，过去某一刻做的什么事,短暂性的动作
    @NSManaged var formPastTense  : String
    
    //MARK: - 单词发音
    //发音文件不存在服务器，每次直接利用百度资源，写成函数，以后好hotfix
    //FIX: 找英式发音和美式发音不同的单词
    //英式发音
    func soundUrlEn() -> String {
        return "http://fanyi.baidu.com/gettts?lan=en&text=\(word)&source=web"
    }
    //美式发音
    func soundUrlAm() -> String {
        return "http://fanyi.baidu.com/gettts?lan=en&text=\(word)&source=web"
    }
    
    static func parseClassName() -> String! {
        return "WordData"
    }
    
    func allMeans(typeSeparator: String = "  ", meanSeparator: String = " ") -> String {
        var allMean = ""
        let count = desc.count
        for index in 0..<count {
            let item = desc[index]
            guard let type = item["type"] as? String,
            let means = item["means"] as? [String] else {
                continue
            }
            
            allMean.appendContentsOf(type)
            if means.count > 0 {
                allMean.appendContentsOf(meanSeparator)
                allMean.appendContentsOf(means.joinWithSeparator(meanSeparator))
            }
            
            if index < count-1 {
                allMean.appendContentsOf(typeSeparator)
            }
        }
        return allMean
    }
}


