//
//  AccountData.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import CoreData

@objc(AccountData)
class AccountData: NSManagedObject {
    @NSManaged var sid: String?
    @NSManaged var name: String?
}
