//
//  WordSentenceCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/28.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordSentenceCell: UICollectionViewCell {
    @IBOutlet weak var labelSentence : TYAttributedLabel!
    @IBOutlet weak var imagePhonation : UIImageView!
    @IBOutlet weak var labelMean : TYAttributedLabel!
    @IBOutlet weak var viewLineBottom : SinglePixelView!
    
    dynamic var viewModel : WordSentenceCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? WordSentenceCellVM {
                self.viewModel = vm
//                self.labelSentence.textContainer = vm.containerEn
//                self.labelMean.textContainer = vm.containerZh
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelSentence.linesSpacing = 2
        labelSentence.numberOfLines = 0
        labelSentence.font = UIFont.systemFontOfSize(14)
        labelSentence.textColor = UIColor.flat(FlatColors.Seance)
        
        labelMean.linesSpacing = 2
        labelMean.numberOfLines = 0
        labelMean.font = UIFont.systemFontOfSize(14)
        labelMean.textColor = UIColor.flat(FlatColors.Seance)
        
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelSentence.textContainer", nilValue: nil) <= RACObserve(target: self, keyPath: "viewModel.containerEn")
        RAC(target: self, keyPath: "labelMean.textContainer", nilValue: nil) <= RACObserve(target: self, keyPath: "viewModel.containerZh")
    }
    
    override func setViewWith(width: CGFloat) {
        labelSentence.preferredMaxLayoutWidth = width - 10 - 45
        labelMean.preferredMaxLayoutWidth = width - 10 - 10
    }
    
    override class func heightWith(viewModel viewModel: DYViewModel, cellWidth: CGFloat) -> CGFloat {
        guard let viewModel = viewModel as? WordSentenceCellVM else {
            return 0
        }
        
        guard let containerEn = viewModel.containerEn,
        let containerZh = viewModel.containerZh else {
            return 0
        }
        
        return 10 + containerEn.textHeight + 12 + containerZh.textHeight + 10
    }
}
