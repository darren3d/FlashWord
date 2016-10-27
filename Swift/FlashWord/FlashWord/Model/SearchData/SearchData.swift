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
    @NSManaged var addTime : NSDate
    
    static func parseClassName() -> String! {
        return "SearchData"
    }
}


extension SearchData {
    class func addSearchHistory(text: String, callback: DYCommonCallback?) {
        if text.length <= 0 {
            callback?(nil, nil)
            return
        }
        
        let creator = AccountData.currentUser()
        
        let query = SearchData.query()
        query.cachePolicy = AVCachePolicy.NetworkElseCache
        query.whereKey("text", equalTo: text)
        if creator != nil {
            query.whereKey("creator", equalTo: creator)
        }
        query.getFirstObjectInBackgroundWithBlock { (data, error) in
            if (error == nil && data == nil) || (error != nil && error.code == kAVErrorObjectNotFound) {
                let searchData = SearchData()
                searchData.text = text
                searchData.creator = creator
                searchData.addTime = NSDate()
                searchData.saveInBackgroundWithBlock({ (succeed, error2) in
                    if error2 == nil && succeed {
                        callback?(searchData, nil)
                    } else {
                        callback?(nil, error2)
                    }
                })
            } else if data != nil {
                if let data = data as? SearchData {
                    data.addTime = NSDate()
                }
                data.saveInBackground()
                callback?(data, nil)
            } else {
                DYLog.error("addSearchHistory: error:\(error.localizedDescription)")
                callback?(nil, error)
            }
        }
    }
    
    class func searchDatas(policy policy: AVCachePolicy = AVCachePolicy.CacheElseNetwork, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[SearchData],NSError> {
        let creator = AccountData.currentUser()
        
        let producer = SignalProducer<[SearchData], NSError> {(observer, dispose) in
            let query = SearchData.query()
            query.cachePolicy = policy
            if creator != nil {
                query.whereKey("creator", equalTo: creator)
            } else {
                 //如果不登录，只能查本地的搜索历史
                query.cachePolicy = AVCachePolicy.CacheOnly
            }
            query.orderByDescending("addTime")
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
