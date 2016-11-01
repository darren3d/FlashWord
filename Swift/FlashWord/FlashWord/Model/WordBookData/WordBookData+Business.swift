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
    func updateCount() -> SignalProducer<Int, NSError> {
        let producer = SignalProducer<Int, NSError> {[weak self] (observer, dispose) in
            guard let sSelf = self else {
                observer.sendCompleted()
                return
            }
            
            let query = sSelf.words.query()
            query.cachePolicy = AVCachePolicy.NetworkOnly
            query.countObjectsInBackgroundWithBlock({[weak self] (count, error) in
                if error == nil {
                    if let sSelf = self {
                        if sSelf.countWord != count {
                            sSelf.countWord = count
                            sSelf.saveInBackground()
                        }
                    }
                    
                    observer.sendNext(count)
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(error)
                }
            })
        }
        return producer
    }
    
    func hasWord(word: String) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        if word.length <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数错误"]))
        }
        
        let producer = SignalProducer<Bool, NSError> {(observer, dispose) in
            let query = self.words.query()
            query.cachePolicy = AVCachePolicy.NetworkOnly
            query.whereKey("word", equalTo: word)
            query.getFirstObjectInBackgroundWithBlock { (wordData, error) in
                if error == nil {
                    if let _ = wordData as? WordData {
                        observer.sendNext(true)
                        observer.sendCompleted()
                    } else {
                        observer.sendNext(false)
                        observer.sendCompleted()
                    }
                } else {
                    if error.code == kAVErrorObjectNotFound {
                        observer.sendNext(false)
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(error)
                    }
                }
            }
        }
        return producer
    }

    //添加单词本，不检测服务器是否已经添加
    static func addWordBook(name: String, desc: String) -> SignalProducer<(String, WordBookData?), NSError> {
        let creator = AccountData.currentUser()
        if creator == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if name.length <= 0 {
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
    
    func addWordData(wordData: WordData) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if self.creator.objectId != adder.objectId {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"只有单词本创建者才有权限添加单词"]))
        }
        
        return self.hasWord(wordData.word).flatMap(FlattenStrategy.Concat) { hasWord -> SignalProducer<Bool, NSError> in
            if hasWord {
                return SignalProducer<Bool, NSError>(value: true)
            } else {
                let producer = SignalProducer<Bool, NSError>{[weak self] (observer, dispose) in
                    guard let stongSelf = self else {
                        observer.sendNext(false)
                        observer.sendCompleted()
                        return
                    }
                    
                    stongSelf.words.addObject(wordData)
                    stongSelf.incrementKey("countWord")
                    
                    stongSelf.fetchWhenSave = true
                    stongSelf.saveInBackgroundWithBlock({[weak self] (succeed, error) in
                        if error == nil {
                            self?.wordDatas.append(wordData)
                            
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
    
    func addWords(words: [String]) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if self.creator.objectId != adder.objectId {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"只有单词本创建者才有权限添加单词"]))
        }
        
        //数组去重
        let  uniWords = Array(Set(words))
        if uniWords.count <= 0 {
            return SignalProducer<Bool, NSError>(value: true)
        }
        
        return SignalProducer<String, NSError>(values: uniWords)
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
                    
                    var count = 0
                    for (_, wordData) in wordDatas {
                        if let wordData = wordData {
                            count += 1
                            stongSelf.words.addObject(wordData)
                        }
                    }
                    if count > 0 {
                        stongSelf.incrementKey("countWord", byAmount: count)
                    }
                    
                    stongSelf.fetchWhenSave = true
                    stongSelf.saveInBackgroundWithBlock({[weak self] (succeed, error) in
                        if error == nil {
                            for (_, wordData) in wordDatas {
                                if let wordData = wordData {
                                    self?.wordDatas.append(wordData)
                                }
                            }
                            
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
    
    private func wordDatas(policy policy: AVCachePolicy, skip: Int, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[WordData],NSError> {
        let producer = SignalProducer<[WordData], NSError> {[weak self] (observer, dispose) in
            guard let sSelf = self else {
                observer.sendCompleted()
                return
            }
            
            let query = sSelf.words.query()
            query.cachePolicy = policy
            query.orderByDescending("word")
            query.skip = skip
            query.limit = limit
            query.findObjectsInBackgroundWithBlock { (words, error) in
                if error == nil {
                    if let words = words as? [WordData] {
                        observer.sendNext(words)
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
    
    func updateWordDatas(policy policy: AVCachePolicy, limit: Int = AppConst.kLargeDataLoadLimit) -> SignalProducer<[WordData], NSError> {
        //FIXME：NOTE：考虑map操作符是否换别的
        let producer = self.wordDatas(policy: policy, skip: 0, limit: limit)
            .map {[weak self] (words) -> [WordData] in
                self?.hasNoMoreWord = limit > words.count
                self?.wordDatas = words
                return words
        }
        return producer
    }
    
    func loadMoreWordDatas(policy policy: AVCachePolicy, limit: Int = AppConst.kLargeDataLoadLimit) -> SignalProducer<[WordData], NSError> {
        //FIXME：NOTE：考虑map操作符是否换别的
        let skip = self.wordDatas.count
        let producer = self.wordDatas(policy: policy, skip: skip, limit: limit)
            .map {[weak self] (words) -> [WordData] in
                self?.hasNoMoreWord = limit > words.count
                self?.wordDatas.appendContentsOf(words)
                return words
        }
        return producer
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
    
    static func addMyWordBook(name: String, desc: String, type: String) -> SignalProducer<MyWordBookData?, NSError> {
        let creator = AccountData.currentUser()
        if creator == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        if name.length <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数不合法"]))
        }
        
        let producer = WordBookData.addWordBook(name, desc: desc)
        .flatMap(FlattenStrategy.Concat) { (_, book) -> SignalProducer<MyWordBookData?, NSError> in
            if let book = book {
                return MyWordBookData.addMyWordBook(book, type: type)
            } else {
                return SignalProducer.empty
            }
        }
        return producer
    }
    
    static func addMyWordBook(book: WordBookData, type: String) -> SignalProducer<MyWordBookData?,NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        return SignalProducer<(WordBookData, String), NSError>(value:(book, type))
        .flatMap(FlattenStrategy.Concat) { (book, type) -> SignalProducer<MyWordBookData?, NSError> in
            return MyWordBookData.myWordBook(book, type: type)
        }.flatMap(FlattenStrategy.Concat) { (myBook) -> SignalProducer<MyWordBookData?, NSError> in
            if let myBook = myBook {
                return SignalProducer<MyWordBookData?, NSError>(value:myBook)
            } else {
                let producer = SignalProducer<MyWordBookData?, NSError> { (observer, dispose) in
                    let myBookData = MyWordBookData()
                    myBookData.book = book
                    myBookData.learner = learner
                    myBookData.type = type
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
    static func myWordBook(book: WordBookData, type: String) -> SignalProducer<MyWordBookData?,NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let producer = SignalProducer<MyWordBookData?, NSError> {(observer, dispose) in
            let query = MyWordBookData.query()
            query.whereKey("book", equalTo: book)
            query.whereKey("learner", equalTo: learner)
            query.whereKey("type", equalTo: type)
            query.includeKey("book")
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
    
    //查询我的生词本，不存在则自动创建
    static func myNewWordBook(policy policy: AVCachePolicy = AVCachePolicy.CacheElseNetwork) -> SignalProducer<MyWordBookData?,NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let producer = SignalProducer<MyWordBookData?, NSError> {(observer, dispose) in
            let query = MyWordBookData.query()
            query.cachePolicy = policy
            query.whereKey("type", equalTo: MyWordBookData.BookType.NewWord)
            query.whereKey("learner", equalTo: learner)
            query.includeKey("book")
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
        
        if policy == AVCachePolicy.CacheOnly || policy == AVCachePolicy.IgnoreCache {
            return producer
        } else {
            return producer.flatMap(FlattenStrategy.Concat) { (myWordBook) -> SignalProducer<MyWordBookData?, NSError> in
                if let myWordBook = myWordBook {
                    return SignalProducer<MyWordBookData?, NSError>(value:myWordBook)
                } else {
                    return MyWordBookData.addMyWordBook("生词本", desc: "", type: MyWordBookData.BookType.NewWord)
                }
            }
        }
    }
    
    //查询我的单词本，除了生词本以外
    static func myWordBooks(policy policy: AVCachePolicy, skip: Int, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[MyWordBookData],NSError> {
        let learner = AccountData.currentUser()
        if learner == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let producer = SignalProducer<[MyWordBookData], NSError> {(observer, dispose) in
                let query = MyWordBookData.query()
                query.cachePolicy = policy
                query.whereKey("type", notEqualTo: MyWordBookData.BookType.NewWord)
                query.whereKey("learner", equalTo: learner)
                query.includeKey("book")
                query.orderByDescending("createdAt")
                query.skip = skip
                query.limit = limit
                query.findObjectsInBackgroundWithBlock { (myBooks, error) in
                    if error == nil {
                        if let myBooks = myBooks as? [MyWordBookData] {
                            observer.sendNext(myBooks)
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
    
    func addWordData(wordData: WordData) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let bookData = self.book
        return bookData.addWordData(wordData)
    }
    
    func addWords(words: [String]) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        let bookData = self.book
        return bookData.addWords(words)
    }
    
    func hasWord(word: String) -> SignalProducer<Bool, NSError> {
        let adder = AccountData.currentUser()
        if adder == nil {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.needLogin, userInfo: ["msg":"请登录"]))
        }
        
        if word.length <= 0 {
            return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数错误"]))
        }
        
        let bookData = self.book
        return bookData.hasWord(word)
    }
}
