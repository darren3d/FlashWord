//
//  SentenceData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

@objc
class SentenceData: AVObject, AVSubclassing {
    @NSManaged var sentence: String
    @NSManaged var desc : String
    
    static func parseClassName() -> String! {
        return "SentenceData"
    }
}
