//
//  SearchWordHistoryVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/26.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

class SearchWordHistoryVM: DYListViewModel {
    var searchDatas : [SearchData] = []
    
    override init(sections: [DYSectionViewModel], data: AnyObject?) {
        super.init(sections: sections, data: data)
        
        self.hasNoMoreData = true
    }
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool {
        var items: [SearchWordCellVM] = []
        
        //filter
        var filterSearchDatas : [SearchData] = []
        var searchTestSet : [String] = []
        
        for searchData in searchDatas {
            if !searchTestSet.contains(searchData.text) {
                searchTestSet.append(searchData.text)
                filterSearchDatas.append(searchData)
            }
        }
        
        for searchData in filterSearchDatas {
            let item = SearchWordCellVM(data: searchData)
            item.displayIcon = true
            items.append(item)
        }
        
        if items.count > 0 {
            self.sections = [DYSectionViewModel(items: items)]
        } else {
             self.sections = []
        }
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool {
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let limit = AppConst.kNormDataLoadLimit
        SearchData.searchDatas(policy: policy, limit: limit)
            .start(Observer<[SearchData], NSError>(
                failed: {[weak self] error in
                    DYLog.info("failed:\(error.localizedDescription)")
                    guard let _ = self, let callback = callback else {
                        return
                    }
                    callback(nil, error)
                },
                completed: {
                    DYLog.info("completed")
                },
                interrupted: {
                    DYLog.info("interrupted")
                },
                next: {[weak self] (searchDatas) in
                    self?.searchDatas = searchDatas
                    self?.vm_reloadData(sortID: Int64(-1), callback: callback)
                }
            ))
        return true
    }
    
    func addSearchHistory(text: String, callback: DYCommonCallback?) {
        SearchData.addSearchHistory(text) {[weak self] (data, error) in
            guard let sSelf = self,
                let data = data as? SearchData else {
                    callback?(nil, error)
                    return
            }
            
            var searchDatas = [data]
            searchDatas.appendContentsOf(sSelf.searchDatas)
            sSelf.searchDatas = searchDatas
            callback?(nil, nil)
        }
    }
}


extension SearchWordHistoryVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return SearchWordCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
        
//        guard let cell = aCell as? SearchWordCell else {
//            return
//        }
//        cell.setDisplayIcon(true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionCount = self.numberOfSectionsInCollectionView(collectionView);
        if section != sectionCount - 1 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
}
