//
//  AVObject+Utility.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/25.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

extension AVObject {
    class func dataWithID(objectID id: String, cachePolicy: AVCachePolicy, includeKeys: [String] = [])-> SignalProducer<AVObject?, NSError> {
        let query = self.query()
        query.cachePolicy = cachePolicy
        for key in includeKeys {
            query.includeKey(key)
        }
        let producer = SignalProducer<AVObject?, NSError> {(observer, dispose) in
            query.getObjectInBackgroundWithId(id) { (object, error) in
                if error == nil {
                    observer.sendNext(object)
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(error)
                }
            }
        }
        return producer
    }
}

