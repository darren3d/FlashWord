//
//  WordBookDetailVM+UI.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension WordBookDetailVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return WordDataCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
//        
//        guard let cell = aCell as? MyWordBookCell else {
//            return
//        }
//        
        aCell.backgroundColor = UIColor.flatColor(atIndex:indexPath.section)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 63)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionCount = self.numberOfSectionsInCollectionView(collectionView);
        if section != sectionCount - 1 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
}

extension WordBookDetailVM {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let sectionVM = self.sectionAtIndex(indexPath.section) else {
            return
        }
        guard let itemVM = sectionVM.itemAtIndex(indexPath.item) as? WordDataCellVM else {
            return
        }
        guard let wordData = itemVM.data as? WordData else {
            return
        }
        
        if wordData.word.length <= 0 {
            return
        }
        
        Navigator.pushURL("/word/detail?word=\(wordData.word)")
    }
}
