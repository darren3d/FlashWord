//
//  WordMeanCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/29.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

@objc(WordMeanCellVM)
class WordMeanCellVM: DYListCellVM {
    dynamic var type : String = ""
    dynamic var mean : String = ""
    
    override func setupViewModel() {
        guard let dict = self.data as? [String : AnyObject] else {
            return
        }
        
        if let type = dict["type"] as? String {
            self.type = type
        }
        
        if let means = dict["means"] as? [String] {
            if means.count > 0 {
                let mean = means.joinWithSeparator("； ")
                self.mean = mean
            }            
        }
    }
}
