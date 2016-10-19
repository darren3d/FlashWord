//
//  WordBookPageCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordBookPageCell: UICollectionViewCell {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
    }
}

extension WordBookPageCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("WordBookCell", forIndexPath: indexPath)
        return aCell;
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = aCell as? WordBookCell else {
            return
        }
        
        cell.setMarkColor(UIColor.flatColor(atIndex:indexPath.section))
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 120)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionCount = self.numberOfSectionsInCollectionView(collectionView);
        if section != sectionCount - 1 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
