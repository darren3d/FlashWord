//
//  DYListViewModel.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

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
