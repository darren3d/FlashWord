//
//  LearnModeData.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/11.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

@objc(SearchData)
class SearchData: AVObject, AVSubclassing {
    @NSManaged var text : String
    @NSManaged var creator : AccountData?
    
    static func parseClassName() -> String! {
        return "SearchData"
    }
}


extension SearchData {
    class func searchDatas(text: String, policy: AVCachePolicy = AVCachePolicy.CacheElseNetwork, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[SearchData],NSError> {
        let creator = AccountData.currentUser()
        
        let producer = SignalProducer<[SearchData], NSError> {(observer, dispose) in
            let query = SearchData.query()
            query.cachePolicy = policy
            query.whereKey("text", equalTo: text)
            query.whereKey("creator", equalTo: creator)
            query.orderByDescending("updatedAt")
            query.skip = 0
            query.limit = limit
            query.findObjectsInBackgroundWithBlock { (searchDatas, error) in
                if error == nil {
                    if let searchDatas = searchDatas as? [SearchData] {
                        observer.sendNext(searchDatas)
                        observer.sendCompleted()
                    } else {
                        observer.sendNext([])
                        observer.sendCompleted()
                    }
                } else {
                    if error.code == kAVErrorObjectNotFound {
                        observer.sendNext([])
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(error)
                    }
                }
            }
        }
        return producer
    }
}
