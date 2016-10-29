//
//  WordSentenceCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/30.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordSentenceCellVM: DYListCellVM {
    dynamic var sentenceEn : NSAttributedString = NSAttributedString(string: "")
    var markAttrEn : TextAttributes
    
    dynamic var sentenceZh = ""
    
    init(data:AnyObject?, markEn: TextAttributes) {
        self.markAttrEn = markEn
        
        super.init(data: data)
    }
    
    override func setupViewModel() {
        guard let sentenceData = self.data as? WordSentenceData else {
            return
        }
        
        func markedSentence(text: String, mark:[[Int]], attr:TextAttributes) -> NSAttributedString {
            if text.length <= 0 || mark.count <= 0 {
                return NSAttributedString(string: "")
            } else {
                let attrString  = NSMutableAttributedString(string: text)
                
                for item in mark {
                    if item.count >= 2 {
                        attrString.addAttributes(attr, range: NSRange(location: item[0], length: item[1]))
                    }
                }
                return attrString
            }
        }
        
        self.sentenceZh = sentenceData.chinese
        self.sentenceEn = markedSentence(sentenceData.english, mark: sentenceData.markEn, attr: self.markAttrEn)
    }
}
