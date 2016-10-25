//
//  DYListViewModel.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

protocol DYTableViewDelegate : UITableViewDataSource, UITableViewDelegate {
    
}

protocol DYCollectionViewDelegate : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
}

extension DYListViewModel : DYCollectionViewDelegate {
    //MARK: Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.countOfSections();
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionVM = self.sectionAtIndex(section) else {
            return 0
        }
        return sectionVM.countOfItems();
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        NSException.raise(NSInternalInconsistencyException, format:"subclass must override this method: cellForItemAtIndexPath", arguments:getVaList(["nil"]))
        return UICollectionViewCell();
    }
    
    //MARK: View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let sectionVM = self.sectionAtIndex(indexPath.section) else {
            return
        }
        guard let itemVM = sectionVM.itemAtIndex(indexPath.item) else {
            return
        }
        cell.cellWillDisplay()
        cell.cellViewModel = itemVM
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.cellDidEndDisplay()
    }
    
//    //MARK: Layout Delegate
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        guard let sectionVM = self.sectionAtIndex(indexPath.section) else {
//            return CGSizeZero
//        }
//        guard let itemVM = sectionVM.itemAtIndex(indexPath.item) else {
//            return CGSizeZero
//        }
//        return CGSizeZero
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsZero
//    }
}



protocol DYListViewModelDelegate {
    /**显示footer需要的最小数目*/
    func vm_minSectionCount() -> Int;
    func vm_updateData(policy policy: AVCachePolicy, callback : DYCommonCallback?) -> Bool
    func vm_loadMoreData(policy policy: AVCachePolicy, callback : DYCommonCallback?) -> Bool
    //MARK: data 内部使用
    func vm_reloadData(sortID sortID : Int64, callback : DYCommonCallback?) -> Bool
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
    
    /**显示footer需要的最小数目*/
    func vm_minSectionCount() -> Int {
        return 4
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
    func vm_loadMoreData(policy policy: AVCachePolicy, callback : DYCommonCallback?) -> Bool {
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
            scrollView.dy_footer?.hidden = false
            scrollView.dy_footer?.endRefreshingWithNoMoreData()
            let countSection = countOfSections()
            if countSection < self.vm_minSectionCount() {
                //                scrollView.dy_footer?.setTitle(" ")
                scrollView.dy_footer?.hidden = true
            }
        } else {
            scrollView.dy_footer?.hidden = false
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
