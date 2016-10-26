//
//  SearchWordHistoryVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/26.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class SearchWordHistoryVM: DYListViewModel {

}


extension SearchWordHistoryVM {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 6
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return SearchWordCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
        
        guard let cell = aCell as? SearchWordCell else {
            return
        }
        cell.setDisplayIcon(true)
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
