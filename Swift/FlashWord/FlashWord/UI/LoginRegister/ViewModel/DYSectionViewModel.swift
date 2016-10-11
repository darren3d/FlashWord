//
//  DYSectionViewModel.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYSectionViewModel: DYViewModel {
    var header : DYViewModel?
    var footer : DYViewModel?
    var items : [DYViewModel] = []
    
    init(items:[DYViewModel], header:DYViewModel? = nil, footer:DYViewModel? = nil, data:AnyObject? = nil) {
        self.header = header
        self.footer = footer
        self.items = items
        super.init(data: data)
    }
    
    func countOfItems() -> Int {
        return items.count
    }
    
    func itemAtIndex(index:Int) -> DYViewModel? {
        if (index < countOfItems()) {
            return items[index];
        } else {
            return nil;
        }
    }
    
    func indexOfItem(item:DYViewModel) -> Array<DYViewModel>.Index? {
        return items.indexOf(item)
    }
}
