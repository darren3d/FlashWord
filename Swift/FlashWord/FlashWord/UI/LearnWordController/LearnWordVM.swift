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
    
    override func reloadData(sortID: Int64, callback: DYCommonCallback?) {
        var sections = [DYSectionViewModel]();
        //没有调用registerSubclass，该处会失败
        if let datas = self.data as? [LearnModeData] {
            for data in datas {
                let itemVM = LearnWordCellVM(data: data)
                let sectionVM = DYSectionViewModel(items: [itemVM])
                sections.append(sectionVM)
            }
        }
        self.sections = sections
        
        super.reloadData(sortID, callback: callback)
    }
    
    override func updateData(callback: DYCommonCallback?) {
        let queryMode = LearnModeData.query()
        queryMode.orderByAscending("mode")
        queryMode.cachePolicy = AVCachePolicy.CacheThenNetwork
        queryMode.findObjectsInBackgroundWithBlock {[weak self] (modes, error) in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                strongSelf.data = modes
            } else {
                DYLog.error(error.localizedDescription)
            }
            
            //刷新数据
            strongSelf.reloadData(Int64(-1), callback: nil)
            
            callback?(modes, error)
        }
    }
    
    override func loadMoreData(callback: DYCommonCallback?) {
        
    }
}


extension LearnWordVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("LearnWordCell", forIndexPath: indexPath)
        return aCell;
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = aCell as? LearnWordCell else {
            return
        }
        
        let section = indexPath.section
        let item = indexPath.item
        
        let sectionVM = self.sectionAtIndex(section)
        let itemVM = sectionVM?.itemAtIndex(item) as? LearnWordCellVM
        
        cell.viewModel = itemVM!
        cell.setContentBackgroundColor(UIColor.flatColor(atIndex:indexPath.section))
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
