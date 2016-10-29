//
//  WordMeanCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/28.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordMeanCell: UICollectionViewCell {
    @IBOutlet weak var labelType : UILabel!
    @IBOutlet weak var labelDesc : UILabel!
    
    dynamic var viewModel : WordMeanCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? WordMeanCellVM {
                self.viewModel = vm
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelType.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.type")
        RAC(target: self, keyPath: "labelDesc.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.mean")
    }
}
