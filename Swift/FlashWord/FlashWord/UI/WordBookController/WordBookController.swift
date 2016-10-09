//
//  WordBookController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordBookController: DYViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 55, 0)
        collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 120)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension WordBookController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//    }
    
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
