//
//  LearnWordCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class LearnWordCellVM: DYViewModel {
    dynamic var title : String = ""
    dynamic var desc : String = ""
    
    override func setupViewModel() {
        super.setupViewModel()
        
        self.rac_valuesForKeyPath("data.title", observer: self)
            .subscribeNext {[weak self] title in
                guard let strongSelf = self, let title = title as? String else {
                    return
                }
                strongSelf.title = title
            }
        
        self.rac_valuesForKeyPath("data.desc", observer: self)
            .subscribeNext {[weak self] desc in
                guard let strongSelf = self, let desc = desc as? String else {
                    return
                }
                strongSelf.desc = desc
        }
    }
    
    override var description: String {
        return "title: \(title)\ndesc:\(desc)\n"
    }
}
