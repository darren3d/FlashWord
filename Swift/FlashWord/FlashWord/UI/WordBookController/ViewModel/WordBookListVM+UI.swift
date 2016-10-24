//
//  WordBookListVM+UI.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension WordBookListVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return WordBookCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
        
        guard let cell = aCell as? WordBookCell else {
            return
        }
        
        cell.setMarkColor(UIColor.flatColor(atIndex:indexPath.section))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 120)
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
