//
//  LearnWordCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class LearnWordCell: UICollectionViewCell {
    @IBOutlet weak var viewContent : UIView!
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelDesc : UILabel!
    
    dynamic var viewModel : LearnWordCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rac_valuesForKeyPath("viewModel.title", observer: self)
            .subscribeNext { [weak self] title in
                guard let strongSelf = self, let title = title as? String else {
                    return
                }
                strongSelf.labelTitle.text = title
        }
        
        self.rac_valuesForKeyPath("viewModel.desc", observer: self)
            .subscribeNext { [weak self] desc in
                guard let strongSelf = self, let desc = desc as? String else {
                    return
                }
                strongSelf.labelDesc.text = desc
        }
    }
    
    
    func setContentBackgroundColor(color:UIColor) {
        viewContent.backgroundColor = color
    }
}
