//
//  WordBookData+Business.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/17.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

extension WordBookData {

    //添加word单词到WordData表
    //该函数先检测服务器是否已经添加，有直接返回，没有则查询翻译后添加到服务器
    static func addWordBook(name: String, desc: String, words: [String]) -> SignalProducer<(String, WordBookData?), NSError> {
        let creator = AccountData.currentUser()
        if creator == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if name.length <= 0 || desc.length <= 0 || words.count <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数不合法"]))
        }
        
        let producer = SignalProducer<(String, WordBookData?), NSError> {(observer, dispose) in
            let book = WordBookData()
            book.name = name
            book.desc = desc
            book.saveInBackgroundWithBlock({ (succeed, error) in
                if error == nil {
                    if succeed {
                        observer.sendNext((name, book))
                        observer.sendCompleted()
                    } else {
                        observer.sendNext((name, nil))
                        observer.sendCompleted()
                    }
                } else {
                    observer.sendFailed(error)
                }
            })
        }
        return producer
    }
}
