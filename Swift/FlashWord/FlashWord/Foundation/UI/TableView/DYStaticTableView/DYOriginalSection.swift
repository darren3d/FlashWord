//
//  DYOriginalSection.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYOriginalSection: NSObject {
    var label: String = ""
    var rows: [DYOriginalRow] = [DYOriginalRow]()
    
    func numberOfVissibleRows() -> Int {
        var count = 0
        for or: DYOriginalRow in self.rows {
            if !or.hidden {
                count += 1
            }
        }
        return count
    }
    
    func vissibleRowIndexWithTableViewCell(cell: UITableViewCell) -> Int {
        var i = 0
        for or: DYOriginalRow in self.rows {
            if or.cell == cell {
                return i
            }
            if !or.hidden {
                i += 1
            }
        }
        return -1
    }
}
