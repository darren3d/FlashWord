//
//  WordBookCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class WordBookCell: UICollectionViewCell {
    @IBOutlet weak var viewMark : UIView!
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelWordConut : UILabel!
    
    @IBOutlet weak var labelStudyTime : UILabel!
    @IBOutlet weak var labelStudyCount : UILabel!
    @IBOutlet weak var labelStudyPercent : UILabel!
    
    @IBOutlet var linesVert : [UIView]!
    @IBOutlet var linesHori : [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
