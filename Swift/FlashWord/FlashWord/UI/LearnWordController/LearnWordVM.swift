//
//  LearnWordVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

class LearnWordVM: DYListViewModel {
    
    override func updateData(callback: DYCommonCallback?) {
        let queryMode = LearnModeData.query()
        queryMode.orderByAscending("mode")
        queryMode.findObjectsInBackgroundWithBlock { (modes, error) in
            guard let callback = callback else {
                return
            }
            
            callback(modes, error)
        }
    }
}
