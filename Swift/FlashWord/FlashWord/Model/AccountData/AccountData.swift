//
//  AccountData.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud

class AccountData: AVUser {
    @NSManaged var age: Int32
    
    override static func parseClassName() -> String! {
        return "_User"
    }
}
