//
//  DYListViewModel.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYListViewModel: DYViewModel {
    var sections : [DYSectionViewModel] = []
    
    init(sections:[DYSectionViewModel], data:AnyObject? = nil) {
        self.sections = sections
        super.init(data: data)
    }
    
    func countOfSections() -> Int {
        return sections.count
    }
    
    func countOfTotalItems() -> Int {
        var count = 0
        for section in sections {
            count += section.countOfItems()
        }
        return count
    }
    
    func hasAnyItem() -> Bool {
        for section in sections {
            if section.countOfItems() > 0 {
                return true
            }
        }
        return false
    }
    
    func sectionAtIndex(index:Int) -> DYSectionViewModel? {
        if (index < countOfSections()) {
            return sections[index];
        } else {
            return nil;
        }
    }
    
    func indexOfSection(item:DYSectionViewModel) -> Array<DYViewModel>.Index? {
        return sections.indexOf(item)
    }
}

extension DYListViewModel {
    //MARK: data 外部使用
    /**下拉刷新*/
    func updateData(callback : DYCommonCallback?) {
    }
    
    /**上拉加载更多*/
    func loadMoreData(callback : DYCommonCallback?) {
    }
    
    //MARK: data 内部使用
    func reloadData(sortID : Int64, callback : DYCommonCallback?) {
        guard let callback = callback else {
            return
        }
        
        callback(nil, nil)
    }
}
