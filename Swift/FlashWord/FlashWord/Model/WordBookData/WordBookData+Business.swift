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

    //添加word单词到WordData表，不检测服务器是否已经添加
    static func addWordBook(name: String, desc: String) -> SignalProducer<(String, WordBookData?), NSError> {
        let creator = AccountData.currentUser()
        if creator == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if name.length <= 0 || desc.length <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数不合法"]))
        }
        
        let producer = SignalProducer<(String, WordBookData?), NSError> {(observer, dispose) in
            let book = WordBookData()
            book.name = name
            book.desc = desc
            book.creator = creator
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
    
    func addWords(words: [String]) -> SignalProducer<Bool, NSError> {
        return SignalProducer<String, NSError>(values: words)
            .flatMap(FlattenStrategy.Concat) { (word) -> SignalProducer<(String, WordData?), NSError> in
                return WordData.addWordData(word)
            }.collect()
             .flatMap(FlattenStrategy.Concat) {[weak self] (wordDatas) -> SignalProducer<Bool, NSError> in
                let producer = SignalProducer<Bool, NSError>{[weak self] (observer, dispose) in
                    guard let stongSelf = self else {
                        observer.sendNext(false)
                        observer.sendCompleted()
                        return
                    }
                    
                    for (_, wordData) in wordDatas {
                        if wordData != nil {
                            stongSelf.words.addObject(wordData!)
                        }
                    }
                    
                    stongSelf.saveInBackgroundWithBlock({ (succeed, error) in
                        if error == nil {
                            observer.sendNext(succeed)
                            observer.sendCompleted()
                        } else {
                            observer.sendFailed(error)
                        }
                    })
                }
                return producer
             }
    }
}

extension MyWordBookData {
    /**进行中的测试*/
    func currentWordTest(cachePolicy:AVCachePolicy = AVCachePolicy.CacheOnly, block: AVObjectResultBlock!) {
        let query = tests.query()
        query.cachePolicy = cachePolicy
        query.whereKeyDoesNotExist("timeEnd")
        query.getFirstObjectInBackgroundWithBlock(block)
    }
    
    //    /**添加一个新的test*/
    //    func addWordTest(words:[WordData], modes:[LearnModeData], block: AVObjectResultBlock!) {
    //        let test = WordTestData()
    //        test.addObjectsFromArray(words, forKey: "words")
    //        test.addObjectsFromArray(modes, forKey: "modes")
    //
    //        
    //    }
    
    static func addMyWordBook(name: String, desc: String) -> SignalProducer<MyWordBookData?, NSError> {
        let creator = AccountData.currentUser()
        if creator == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if name.length <= 0 || desc.length <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数不合法"]))
        }
        
        let producer = WordBookData.addWordBook(name, desc: desc)
        .flatMap(FlattenStrategy.Concat) { (_, book) -> SignalProducer<MyWordBookData?, NSError> in
            if let book = book {
                return MyWordBookData.addMyWordBook(book)
            } else {
                return SignalProducer.empty
            }
        }
        return producer
    }
    
    static func addMyWordBook(book: WordBookData) -> SignalProducer<MyWordBookData?,NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        return SignalProducer<WordBookData, NSError>(value:book)
        .flatMap(FlattenStrategy.Concat) { (book) -> SignalProducer<MyWordBookData?, NSError> in
            MyWordBookData.myWordBook(book)
        }.flatMap(FlattenStrategy.Concat) { (myBook) -> SignalProducer<MyWordBookData?, NSError> in
            if let myBook = myBook {
                return SignalProducer<MyWordBookData?, NSError>(value:myBook)
            } else {
                let producer = SignalProducer<MyWordBookData?, NSError> { (observer, dispose) in
                    let myBookData = MyWordBookData()
                    myBookData.book = book
                    myBookData.learner = learner
                    myBookData.saveInBackgroundWithBlock({ (succeed, error) in
                        if error == nil {
                            if succeed {
                                observer.sendNext(myBookData)
                                observer.sendCompleted()
                            } else {
                                observer.sendNext(nil)
                                observer.sendCompleted()
                            }
                        } else {
                            observer.sendFailed(error)
                        }
                    })
                }
                return producer;
            }
        }
        
    }
    
    //通过book查询mybook
    static func myWordBook(book: WordBookData) -> SignalProducer<MyWordBookData?,NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let producer = SignalProducer<MyWordBookData?, NSError> {(observer, dispose) in
            let query = MyWordBookData.query()
            query.whereKey("book", equalTo: book)
            query.whereKey("learner", equalTo: learner)
            query.getFirstObjectInBackgroundWithBlock { (myBook, error) in
                if error == nil {
                    if let myBook = myBook as? MyWordBookData {
                        observer.sendNext(myBook)
                        observer.sendCompleted()
                    } else {
                        observer.sendNext(nil)
                        observer.sendCompleted()
                    }
                } else {
                    if error.code == kAVErrorObjectNotFound {
                        observer.sendNext(nil)
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
