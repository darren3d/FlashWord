//
//  UICollectionViewCell+Utility.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/24.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    class func nibName() -> String {
        return NSObject.SimpleStringFromClass(self)
    }
    
    class func reuseIdentifier() -> String {
        return NSObject.SimpleStringFromClass(self)
    }
    
    class func registerCell(collectionView: UICollectionView) {
        let nib = UINib(nibName: self.nibName(), bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: self.reuseIdentifier())
    }
    
    class func dequeueReusableCellWithReuseIdentifier(collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier(),
                                                                     forIndexPath: indexPath)
    }
    
    class func heightWith(viewModel viewModel: DYViewModel, cellWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    func cellWillDisplay() {
    }
    
    func cellDidEndDisplay() {
    }
    
    func setViewWith(width: CGFloat) {
    }
    
    var cellViewModel: DYViewModel? {
        get {
            return nil
        }
        set {
        }
    }
}
