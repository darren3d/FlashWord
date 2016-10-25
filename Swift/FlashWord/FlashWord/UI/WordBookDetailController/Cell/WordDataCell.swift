//
//  WordDataCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/25.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class WordDataCell: UICollectionViewCell {
    @IBOutlet weak var labelWord : UILabel!
    @IBOutlet weak var labelPhonation : UILabel!
    @IBOutlet weak var labelMean : UILabel!
    
    dynamic var viewModel : WordDataCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? WordDataCellVM {
                self.viewModel = vm
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelWord.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.word")
        RAC(target: self, keyPath: "labelPhonation.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.phonation")
        RAC(target: self, keyPath: "labelMean.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.mean")
    }
}
