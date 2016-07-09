//
//  DYOriginalRow.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

//enum DYBatchOperation : Int32{
//    case None = 0
//    case Insert = 1
//    case Delete = 2
//    case Update = 3
//}

struct DYBatchOperation  {
    static let None : Int32     = 0
    static let Insert : Int32   = 1
    static let Delete : Int32   = 2
    static let Update : Int32   = 3
}

class DYOriginalRow: NSObject {
    var hidden: Bool {
        get {
            return (self.hiddenPlanned || self.hiddenPlanned)
        }
        set(hidden) {
            if (!self.hiddenReal) && (hidden) {
                self.batchOperation = DYBatchOperation.Delete
            } else if (self.hiddenReal) && (!hidden) {
                self.batchOperation = DYBatchOperation.Insert
            }
            self.hiddenPlanned = hidden
        }
    }
    
    var hiddenReal: Bool = false
    var hiddenPlanned: Bool = false
    var batchOperation: Int32 = DYBatchOperation.None
    weak var cell: UITableViewCell?
    var originalIndexPath: NSIndexPath?
    var height: CGFloat =  CGFloat.max
    func update() {
        if !self.hidden {
            if self.batchOperation == DYBatchOperation.None {
                self.batchOperation = DYBatchOperation.Update
            }
        }
    }
    
    override init() {
        self.height = CGFloat.max
        super.init()
    }
}
