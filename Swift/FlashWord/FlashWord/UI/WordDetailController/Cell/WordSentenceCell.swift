//
//  WordSentenceCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/28.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordSentenceCell: UICollectionViewCell {
    @IBOutlet weak var labelSentence : UILabel!
    @IBOutlet weak var imagePhonation : UIImageView!
    @IBOutlet weak var labelMean : UILabel!
    @IBOutlet weak var viewLineBottom : SinglePixelView!
    
    dynamic var viewModel : WordSentenceCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? WordSentenceCellVM {
                self.viewModel = vm
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelSentence.attributedText", nilValue: nil) <= RACObserve(target: self, keyPath: "viewModel.sentenceEn")
        RAC(target: self, keyPath: "labelMean.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.sentenceZh")
    }
}
