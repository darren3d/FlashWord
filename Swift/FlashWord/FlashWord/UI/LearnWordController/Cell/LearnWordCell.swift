//
//  LearnWordCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import RxSwift

class LearnWordCell: UICollectionViewCell {
    @IBOutlet weak var viewContent : UIView!
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelDesc : UILabel!
    
    var disposeBag : DisposeBag! = DisposeBag()
    var viewModel : LearnWordCellVM = LearnWordCellVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rx_observe(LearnWordCellVM.self, "viewModel", options: [.Initial, .New], retainSelf: true)
            .subscribeNext {[weak self] viewModel in
                guard let strongSelf = self, let viewModel = viewModel else {
                    return
                }
                
                strongSelf.labelTitle.text = viewModel.title
            }.addDisposableTo(disposeBag)
        
        self.rx_observe(String.self, "viewModel.title", options: [.Initial, .New], retainSelf: true)
            .subscribeNext {[weak self] title in
                guard let strongSelf = self, let title = title else {
                    return
                }
                
                strongSelf.labelTitle.text = title
            }.addDisposableTo(disposeBag)
        //
        //        self.rx_observe(String.self, "data.title", options: [.Initial, .New], retainSelf: false)
        //            .subscribeNext {[weak self] title in
        //                guard let strongSelf = self, let title = title else {
        //                    return
        //                }
        //
        //                strongSelf.title = title
        //            }.addDisposableTo(disposeBag)
    }
    
    
    func setContentBackgroundColor(color:UIColor) {
        viewContent.backgroundColor = color
    }
}
