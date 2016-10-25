//
//  MyWordBookCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

@objc
class MyWordBookCellVM: DYListCellVM {
    dynamic var name : String = ""
    dynamic var countWord : Int = 0
    dynamic var time : Int = 0
    dynamic var countLearn : Int = 0
    dynamic var masterDegree : Int = 0
    
    override func setupViewModel() {
        guard let _ = self.data as? MyWordBookData else {
            return
        }
        
        RAC(target: self, keyPath: "name", nilValue: "") <= RACObserve(target: self, keyPath: "data.book.name")
        RAC(target: self, keyPath: "countWord", nilValue: 0) <= RACObserve(target: self, keyPath: "data.book.countWord")
    }
}
