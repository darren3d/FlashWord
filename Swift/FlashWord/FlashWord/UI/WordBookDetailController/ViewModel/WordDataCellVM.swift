//
//  WordDataCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/25.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class WordDataCellVM: DYListCellVM {
    dynamic var word : String = ""
    dynamic var phonation : String = ""
    dynamic var mean : String = ""
    
    override func setupViewModel() {
        guard let _ = self.data as? WordData else {
            return
        }
        
        RAC(target: self, keyPath: "word", nilValue: "") <= RACObserve(target: self, keyPath: "data.word")
        RAC(target: self, keyPath: "phonation", nilValue: "") <= RACSignal.combineLatest([RACObserve(target: self, keyPath: "data.phonationEn"), RACObserve(target: self, keyPath: "data.phonationAm")])
            .mapAs({ (tuple : RACTuple) -> AnyObject in
            var phonation = ""
            if let en = tuple[0] as? String {
                phonation.appendContentsOf("英：[\(en)]")
            }
            
            if let am = tuple[1] as? String {
                phonation.appendContentsOf("美：[\(am)]")
            }
            
            return phonation
        })
        
        RAC(target: self, keyPath: "mean", nilValue: "") <= RACObserve(target: self, keyPath: "data.desc")
            .map({[weak self] (means : AnyObject!) -> AnyObject! in
                guard let word = self?.data as? WordData else {
                    return ""
                }
                return word.allMeans()
            })
    }
}
