//
//  MyWordBookCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class MyWordBookCell: UICollectionViewCell {
    @IBOutlet weak var viewMark : UIView!
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelWordConut : UILabel!
    
    @IBOutlet weak var labelStudyTime : UILabel!
    @IBOutlet weak var labelStudyCount : UILabel!
    @IBOutlet weak var labelStudyPercent : UILabel!
    
    @IBOutlet var linesVert : [UIView]!
    @IBOutlet var linesHori : [UIView]!
    
    dynamic var viewModel : MyWordBookCellVM?
    override var cellViewModel: DYViewModel? {
        get {
            return viewModel
        }
        set {
            if let vm = newValue as? MyWordBookCellVM {
                self.viewModel = vm
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupReactive()
    }
    
    func setupReactive() {
        RAC(target: self, keyPath: "labelTitle.text", nilValue: "匿名") <= RACObserve(target: self, keyPath: "viewModel.name")
        RAC(target: self, keyPath: "labelWordConut.text", nilValue: "") <= RACObserve(target: self, keyPath: "viewModel.countWord")
            .map { (count) -> AnyObject! in
                if let count = count as? Int {
                    if count > 0 {
                        return "\(count)单词"
                    }
                }
                return ""
             }

//        RACObserve(target: self, keyPath: "viewModel.countWord").mapAs { (count: NSNumber) -> NSString in
//            ""
//        }
    }
    
    func setMarkColor(color:UIColor) {
        viewMark.backgroundColor = color
    }
}
