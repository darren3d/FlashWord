//
//  LearnWordCellVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import RxSwift

class LearnWordCellVM: DYViewModel {
    var title : String = ""
    var desc : String = ""
    
    
    override func setupViewModel() {
        super.setupViewModel()
        
        self.rx_observe(String.self, "data.title", options: [.Initial, .New], retainSelf: true)
            .shareReplay(1)
            .takeUntil(self.rx_deallocated)
            .subscribeNext {[weak self] title in
                guard let strongSelf = self, let title = title else {
                    return
                }
                
                strongSelf.title = title
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
}
