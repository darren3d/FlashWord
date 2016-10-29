//
//  WordDetailVM+UI.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension WordDetailVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case WordDetailSection.Phonation:
            return WordPhonationCell.dequeueReusableCellWithReuseIdentifier(collectionView,
                                                                     forIndexPath: indexPath)
        case WordDetailSection.Meaning:
            return WordMeanCell.dequeueReusableCellWithReuseIdentifier(collectionView,
                                                                       forIndexPath: indexPath)
        case WordDetailSection.Sentence:
            let item = indexPath.item
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            if item > 0 && item < count - 1  {
                return WordSentenceCell.dequeueReusableCellWithReuseIdentifier(collectionView,
                                                                               forIndexPath: indexPath)
            } else if item == 0 {
                return WordSentenceHeadCell.dequeueReusableCellWithReuseIdentifier(collectionView,
                                                                               forIndexPath: indexPath)
            } else {
                return WordSentenceFootCell.dequeueReusableCellWithReuseIdentifier(collectionView,
                                                                               forIndexPath: indexPath)
            }
        default:
            DYLog.error("WordDetailVM cellForItemAtIndexPath error")
            return UICollectionViewCell()
        }
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
        let width = collectionView.bounds.width
        var  size = CGSize(width: width, height: 0)
        
        switch indexPath.section {
        case WordDetailSection.Phonation:
            size.height = 75
        case WordDetailSection.Meaning:
            size.height = 27
        case WordDetailSection.Sentence:
            let item = indexPath.item
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            if item > 0 && item < count - 1  {
                size.height = 66
            } else if item == 0 {
                size.height = 27
            } else {
                size.height = 4
            }
        default:
            DYLog.error("WordDetailVM cellForItemAtIndexPath error")
        }
        return size
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

extension WordDetailVM {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let sectionVM = self.sectionAtIndex(indexPath.section) else {
            return
        }
        guard let itemVM = sectionVM.itemAtIndex(indexPath.item) as? MyWordBookCellVM else {
            return
        }
        guard let myBook = itemVM.data as? MyWordBookData else {
            return
        }
        Navigator.pushURL("/mywordbook/detail?id=\(myBook.objectId)")
    }
}
