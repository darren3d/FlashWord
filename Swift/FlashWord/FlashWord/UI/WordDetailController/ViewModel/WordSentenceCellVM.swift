//
//  WordSentenceCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/30.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordSentenceCellVM: DYListCellVM {
    dynamic var containerEn : TYTextContainer!
    dynamic var containerZh : TYTextContainer!
    
    var markAttrEn : TextAttributes
    
    init(data:AnyObject?, markEn: TextAttributes, width: CGFloat) {
        self.markAttrEn = markEn
        
        super.init(data: data, width:width)
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
        
        let sentenceEn = markedSentence(sentenceData.english, mark: sentenceData.markEn, attr: self.markAttrEn)
        let containerEn = TYTextContainer()
        containerEn.linesSpacing = 2
        containerEn.attributedText = sentenceEn;
        self.containerEn = containerEn.createTextContainerWithTextWidth(self.width-10-45)
        
        let containerZh = TYTextContainer()
        containerZh.linesSpacing = 2
        containerZh.text = sentenceData.chinese
        self.containerZh = containerZh.createTextContainerWithTextWidth(self.width-10-10)
    }
}
