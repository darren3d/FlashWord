//
//  SearchWordCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/25.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class SearchWordCell: UICollectionViewCell {
    @IBOutlet weak var imageIcon : UIImageView!
    @IBOutlet weak var labelWord : UILabel!
    @IBOutlet weak var labelWordLead : NSLayoutConstraint!
    @IBOutlet weak var labelMean : UILabel!
    
    dynamic var viewModel : SearchWordCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? SearchWordCellVM {
                self.viewModel = vm
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDisplayIcon(false)
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelWord.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.word")
        RAC(target: self, keyPath: "labelMean.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.mean")
    }
    
    func setDisplayIcon(display : Bool) {
        if display {
            imageIcon.hidden = false
            labelWordLead.constant = 40
        } else {
            imageIcon.hidden = true
            labelWordLead.constant = 10
        }
    }
}
