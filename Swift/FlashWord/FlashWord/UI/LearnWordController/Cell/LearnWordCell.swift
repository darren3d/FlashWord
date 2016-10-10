//
//  LearnWordCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class LearnWordCell: UICollectionViewCell {
    @IBOutlet weak var viewContent : UIView!
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelDesc : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setContentBackgroundColor(color:UIColor) {
        viewContent.backgroundColor = color
    }
}
