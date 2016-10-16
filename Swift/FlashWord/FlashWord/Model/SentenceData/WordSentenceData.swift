//
//  WordSentenceData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/13.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class WordSentenceData: AVObject, AVSubclassing {
    @NSManaged var english : String
    //英文单词位置标记
    @NSManaged var markEn : [[Int]]
    
    @NSManaged var chinese : String
    //中文解释位置标记
    @NSManaged var markZh : [[Int]]
    
    static func parseClassName() -> String! {
        return "WordSentenceData"
    }
    
    static func sentence(data: [AnyObject]) -> WordSentenceData? {
        if data.count < 2 {
            return nil
        }
        
        guard let englishData = data[0] as? [AnyObject] else {
            return nil
        }
        
        let (english, marksEn) = sentence(englishData)
        if english.length <= 0 {
            return nil
        }
        
        guard let chineseData = data[1] as? [AnyObject] else {
            return nil
        }
        let (chinese, marksZh) = sentence(chineseData)
        if chinese.length <= 0 {
            return nil
        }
        
        let sentenceData = WordSentenceData()
        sentenceData.english = english
        sentenceData.markEn = marksEn
        sentenceData.chinese = chinese
        sentenceData.markZh = marksZh
        
        return sentenceData
    }
    
    private static func sentence(data: [AnyObject]) -> (String, [[Int]]) {
        if data.count <= 0 {
            return ("", [])
        }
        
        var sentence : String = ""
        var length = 0
        var marks : [[Int]] = []
        
        for wordPiece in data {
            guard let wordPiece = wordPiece as? [AnyObject] else {
                continue
            }
            
            let count = wordPiece.count
            if count <= 0 {
                continue
            } else {
                if let word = wordPiece[0] as? String {
                    let start = length
                    let size = word.characters.count
                    length += size
                    sentence += word
                    if count >= 4 {
                        if let markInt = wordPiece[3] as? Int {
                            if markInt > 0 {
                                marks.append([start, size])
                            }
                        }
                        if count >= 5{
                            if let blank = wordPiece[4] as? String {
                                length += blank.characters.count
                                sentence += blank
                            }
                        }
                    }
                }
            }
        }
        
        return (sentence, marks)
    }
}
