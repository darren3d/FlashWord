//
//  WordPhonationCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/29.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

@objc(WordPhonationCellVM)
class WordPhonationCellVM: DYListCellVM {
    dynamic var word : String = ""
    dynamic var phonationEn = ""
    dynamic var phonationAm = ""
    
    override func setupViewModel() {
        guard let _ = self.data as? WordData else {
            return
        }
        
        RAC(target: self, keyPath: "word", nilValue: "") <= RACObserve(target: self, keyPath: "data.word")
        RAC(target: self, keyPath: "phonationEn", nilValue: "") <= RACObserve(target: self, keyPath: "data.phonationEn")
            .map({ (text) -> AnyObject! in
            guard let text = text as? String else {
                return ""
            }
            return "英：[\(text)]"
        })
        RAC(target: self, keyPath: "phonationAm", nilValue: "") <= RACObserve(target: self, keyPath: "data.phonationAm")
            .map({ (text) -> AnyObject! in
            guard let text = text as? String else {
                return ""
            }
            return "美：[\(text)]"
        })
    }
    
    //英式发音
    func soundUrlEn() -> String {
        guard let wordData = self.data as? WordData else {
            return ""
        }
        return wordData.soundUrlEn()
    }
    
    //美式发音
    func soundUrlAm() -> String {
        guard let wordData = self.data as? WordData else {
            return ""
        }
        return wordData.soundUrlAm()
    }
}
