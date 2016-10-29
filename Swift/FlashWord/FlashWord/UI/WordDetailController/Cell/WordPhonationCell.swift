//
//  WordPhonationCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/28.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordPhonationCell: UICollectionViewCell {
    @IBOutlet weak var labelWord : UILabel!
    
    @IBOutlet weak var labelPhonationEn : UILabel!
    @IBOutlet weak var imagePhonationEn : UIImageView!
    @IBOutlet weak var labelPhonationAm : UILabel!
    @IBOutlet weak var imagePhonationAm : UIImageView!
    
    dynamic var viewModel : WordPhonationCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? WordPhonationCellVM {
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
        RAC(target: self, keyPath: "labelPhonationEn.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.phonationEn")
        RAC(target: self, keyPath: "labelPhonationAm.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.phonationAm")
    }
}
