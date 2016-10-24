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
    func vm_updateData(policy policy: AVCachePolicy, callback : DYCommonCallback?) -> Bool
    func vm_loadMoreData(callback : DYCommonCallback?) -> Bool
    //MARK: data 内部使用
    func vm_reloadData(sortID sortID : Int64, callback : DYCommonCallback?) -> Bool
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
    private struct AssociatedKey {
        static var ViewController = "dylistviewmodel.key.viewcontroller"
        static var ScrollView = "dylistviewmodel.key.scrollview"
    }
    var vm_viewController: UIViewController? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&AssociatedKey.ViewController,
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: {
                                                                return WeakWrapper();
            }) else {
                DYLog.error("vm_viewController wrapper alloc failed")
                return nil
            }
            
            return wrapper.target as? UIViewController
        }
        
        set {
            guard let wrapper = self.dy_getAssociatedObject(&AssociatedKey.ViewController,
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: {
                                                                return WeakWrapper();
            }) else {
                DYLog.error("vm_viewController wrapper alloc failed")
                return
            }
            
            wrapper.target = newValue
        }
    }
    
    var vm_scrollView: UIScrollView? {
        get {
            guard let wrapper = self.dy_getAssociatedObject(&AssociatedKey.ScrollView,
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: {
                                                                return WeakWrapper();
            }) else {
                DYLog.error("vm_scrollView wrapper alloc failed")
                return nil
            }
            
            return wrapper.target as? UIScrollView
        }
        
        set {
            guard let wrapper = self.dy_getAssociatedObject(&AssociatedKey.ScrollView,
                                                            policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
                                                            initial: {
                                                                return WeakWrapper();
            }) else {
                DYLog.error("vm_scrollView wrapper alloc failed")
                return
            }
            
            wrapper.target = newValue
        }
    }
    
    //MARK: data 外部使用
    /**下拉刷新*/
    func vm_updateData(policy policy: AVCachePolicy, callback : DYCommonCallback?) -> Bool {
        guard let scrollView = self.vm_scrollView else {
            callback?(nil, nil)
            return false
        }
        
        scrollView.dy_footer?.hidden = true
        
        return true
    }
    
    /**上拉加载更多*/
    func vm_loadMoreData(callback : DYCommonCallback?) -> Bool {
        guard let scrollView = self.vm_scrollView else {
            callback?(nil, nil)
            return false
        }
        
        if !hasAnyItem() {
            scrollView.dy_footer?.endRefreshing()
            callback?(nil, nil)
            return false
        }
        return true
    }
    
    //MARK: data 内部使用，将data转成sections
    func vm_reloadData(sortID sortID : Int64, callback : DYCommonCallback?) -> Bool {
        //更新数据部分
        
        
        //更新界面部分
        guard let scrollView = self.vm_scrollView else {
            callback?(nil, nil)
            return false
        }
        
        if hasAnyItem() {
            scrollView.dy_footer?.hidden = false
        }
        
        if sortID <= 0 {
            //下拉情况
            scrollView.dy_header?.endRefreshing()
        } else {
            //上拉情况
        }
        
        //避免下拉只有少量数据，不满屏，下拉也要监测是否加载完
        if hasNoMoreData {
            scrollView.dy_footer?.endRefreshingWithNoMoreData()
        } else {
            scrollView.dy_footer?.endRefreshing()
        }
        
        if let collectionView = scrollView as? UICollectionView {
            collectionView.reloadData()
        } else if let tableView = scrollView as? UITableView {
            tableView.reloadData()
        }
        
        callback?(nil, nil)
        
        return true
    }
}
