//
//  SearchWordCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/25.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc(SearchWordCellVM)
class SearchWordCellVM: DYListCellVM {
    dynamic var displayIcon : Bool = false
    dynamic var word : String = ""
    dynamic var mean : String = ""
    
    override func setupViewModel() {
        if let _ = self.data as? WordCD  {
            RAC(target: self, keyPath: "word", nilValue: "") <= RACObserve(target: self, keyPath: "data.word")
            //        RAC(target: self, keyPath: "mean", nilValue: "") <= RACObserve(target: self, keyPath: "data.desc")
            //            .map({[weak self] (means : AnyObject!) -> AnyObject! in
            //                guard let word = self?.data as? WordData else {
            //                    return ""
            //                }
            //                return word.allMeans()
            //            })
        } else if let _ = self.data as? SearchData {
            RAC(target: self, keyPath: "word", nilValue: "") <= RACObserve(target: self, keyPath: "data.text")
        }
    }
}
