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
        
        //header
        let sectionHeader = DYSectionViewModel(items: [DYViewModel(data:nil)])
        
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
            self.sections = [sectionHeader, DYSectionViewModel(items: items)]
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
        if indexPath.section == 0 {
            return SearchHistoryHeader.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)

        } else {
             return SearchWordCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
        
        if indexPath.section == 0 {
            if let searchHeader = aCell as? SearchHistoryHeader {
                searchHeader.callback = { [weak self] _ in
                    self?.clearHistory()
                    self?.vm_reloadData(sortID: -1, callback: nil)
                }
            }
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 30)
        } else {
            let halfWidth = floor(collectionView.bounds.width*0.5)
            DYLog.info("section: \(indexPath.section) item: \(indexPath.item) halfWidth: \(halfWidth)")
            return CGSize(width: halfWidth, height: 40)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsZero
        } else {
            return UIEdgeInsetsMake(0, 0, 10, 0)
        }
    }
}
