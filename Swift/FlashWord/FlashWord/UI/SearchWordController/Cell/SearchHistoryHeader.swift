//
//  SearchHistoryHeader.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/27.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

typealias SearchHistoryHeaderCallback = (SearchHistoryHeader)->Void

@objc
class SearchHistoryHeader: UICollectionViewCell {
    var callback : SearchHistoryHeaderCallback?
    
    @IBOutlet weak var btnClear : UIButton!
    @IBAction func onBtnClear() {
        callback?(self)
    }
}
