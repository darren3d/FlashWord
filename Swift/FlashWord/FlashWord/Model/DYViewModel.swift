//
//  DYViewModel.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import RxSwift

class DYViewModel: NSObject {
    var disposeBag : DisposeBag! = DisposeBag()
    override init() {
        super.init()
        
        setupObserver()
    }
    
    deinit {
        disposeBag = nil
    }
    
    func setupObserver() {
    }
}
