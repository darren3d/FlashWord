//
//  DYListViewModel.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

protocol DYListViewModelDelegate {
    func vm_updateData(policy policy: AVCachePolicy, callback : DYCommonCallback?)
    func vm_loadMoreData(callback : DYCommonCallback?)
    //MARK: data 内部使用
    func vm_reloadData(sortID sortID : Int64, callback : DYCommonCallback?)
}

class DYListViewModel: DYViewModel {
    var hasNoMoreData : Bool = false
    
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

extension DYListViewModel : DYListViewModelDelegate{
    //MARK: data 外部使用
    /**下拉刷新*/
    func vm_updateData(policy policy: AVCachePolicy, callback : DYCommonCallback?) {
    }
    
    /**上拉加载更多*/
    func vm_loadMoreData(callback : DYCommonCallback?) {
    }
    
    //MARK: data 内部使用，将data转成sections
    func vm_reloadData(sortID sortID : Int64, callback : DYCommonCallback?) {
        guard let callback = callback else {
            return
        }
        
        callback(nil, nil)
    }
}
