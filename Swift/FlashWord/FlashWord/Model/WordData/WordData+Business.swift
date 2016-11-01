//
//  WordData+Business.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/16.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa
import Alamofire
import SwiftyJSON

extension WordData {
    //百度翻译下载发音
    //英式发音
    //http://fanyi.baidu.com/gettts?lan=en&text=word&source=web
    //美式发音
    //http://fanyi.baidu.com/gettts?lan=en&text=word&source=web
    //百度翻译数据都存在tplData中
    //百度翻译页面调用的api
    //http://fanyi.baidu.com/?aldtype=16047&tpltype=sigma#en/zh/word
    //http://fanyi.baidu.com/v2transapi?from=en&to=zh&query=word
    
    //添加word单词到WordData表
//    static func addWordData(word : [String]) -> SignalProducer<(String, WordData?), NSError> {
//        let producer = SignalProducer<(String, WordData?), NSError> { (observer, dispose) in
//            //先查询是否已经添加
//            let query = AVQuery(className: "WordData")
//            query.whereKey("word", equalTo: word)
//            query.getFirstObjectInBackgroundWithBlock({ (wordData, error) in
//                if error != nil {
//                    observer.sendFailed(error)
//                    return
//                }
//                
//                if let wordData = wordData as? WordData {
//                    observer.sendNext((word, wordData))
//                    observer.sendCompleted()
//                } else {
//                    //不存在，翻译后保存
//                    observer.sendNext((word, nil))
//                    observer.sendCompleted()
//                    return
//                }
//            })
//        }
//        return producer
//    }
        
    //添加word单词到WordData表
    //该函数先检测服务器是否已经添加，有直接返回，没有则查询翻译后添加到服务器
    static func addWordData(word : String) -> SignalProducer<(String, WordData?), NSError> {
        let producer = SignalProducer<String, NSError>(value: word)
        .flatMap(FlattenStrategy.Concat) { word -> SignalProducer<(AnyObject, AVObject?), NSError> in
            //查询服务器
            return WordData.dataWithKey(key: "word", value: word, cachePolicy: AVCachePolicy.NetworkOnly)
         }.flatMap(FlattenStrategy.Concat) { (word, wordData) -> SignalProducer<(String, WordData?), NSError> in
            if wordData != nil {
                //服务器存在
                return SignalProducer<(String, WordData?), NSError>(value: (word as! String, wordData as? WordData))
            } else {
                //服务器不存在，
                return WordData.forceAddWordData(word as! String)
            }
        }
        return producer
    }
    
    private func sentenceDatas(policy policy: AVCachePolicy, skip: Int, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[WordSentenceData],NSError> {
        let producer = SignalProducer<[WordSentenceData], NSError> {[weak self] (observer, dispose) in
            guard let sSelf = self else {
                observer.sendCompleted()
                return
            }
            
            let query = sSelf.sentences.query()
            query.cachePolicy = policy
            query.skip = skip
            query.limit = limit
            query.findObjectsInBackgroundWithBlock { (words, error) in
                if error == nil {
                    if let words = words as? [WordSentenceData] {
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
    
    //更新句子
    func updateSentenceDatas(policy policy: AVCachePolicy, limit: Int = AppConst.kLargeDataLoadLimit) -> SignalProducer<[WordSentenceData], NSError> {
        //FIXME：NOTE：考虑map操作符是否换别的
        let producer = self.sentenceDatas(policy: policy, skip: 0, limit: limit)
            .map {[weak self] (sentences) -> [WordSentenceData] in
                self?.hasNoMoreSentence = limit > sentences.count
                self?.sentenceDatas = sentences
                return sentences
        }
        return producer
    }
    
    //加载更多句子
    func loadMoreSentenceDatas(policy policy: AVCachePolicy, limit: Int = AppConst.kLargeDataLoadLimit) -> SignalProducer<[WordSentenceData], NSError> {
        //FIXME：NOTE：考虑map操作符是否换别的
        let skip = self.sentenceDatas.count
        let producer = self.sentenceDatas(policy: policy, skip: skip, limit: limit)
            .map {[weak self] (sentences) -> [WordSentenceData] in
                self?.hasNoMoreSentence = limit > sentences.count
                self?.sentenceDatas.appendContentsOf(sentences)
                return sentences
        }
        return producer
    }
    
    //网络查询单词后添加到服务器
    private static func forceAddWordData(word : String) -> SignalProducer<(String, WordData?), NSError> {
        let producer = WordData.translate(word)
        .flatMap(FlattenStrategy.Concat) { (word, wordDict) -> SignalProducer<(String, WordData?), NSError> in
            let wordParseSaver = SignalProducer<(String, WordData?), NSError> { (observer, dispose) in
                guard let wordDict = wordDict else {
                    observer.sendNext((word, nil))
                    observer.sendCompleted()
                    return
                }

                let (_, wordData1, sentenceDatas) = WordData.parseWordSentence(word, dict: wordDict)
                guard let wordData = wordData1 else {
                    observer.sendNext((word, nil))
                    observer.sendCompleted()
                    return
                }

                if sentenceDatas.count > 0 {
                    //保存前乱序
                    let randSentenceDatas = sentenceDatas.randomSubArray(count: sentenceDatas.count)
                    AVObject.saveAllInBackground(randSentenceDatas, block: { (succeed, error) in
                        if error == nil {
                            if succeed {
                                
                                for data in randSentenceDatas {
                                    wordData.sentences.addObject(data)
                                }

                                wordData.saveInBackgroundWithBlock({ (succeed2, error2) in
                                    if error2 == nil {
                                        if succeed2 {
                                            observer.sendNext((word, wordData))
                                            observer.sendCompleted()
                                        } else {
                                            observer.sendNext((word, nil))
                                            observer.sendCompleted()
                                        }
                                    } else {
                                        observer.sendFailed(error2)
                                    }
                                })
                            } else {
                                observer.sendNext((word, nil))
                                observer.sendCompleted()
                            }
                        } else {
                            observer.sendFailed(error)
                        }
                    })
                } else {
                    wordData.saveInBackgroundWithBlock({ (succeed, error) in
                        if error == nil {
                            if succeed {
                                observer.sendNext((word, wordData))
                                observer.sendCompleted()
                            } else {
                                observer.sendNext((word, nil))
                                observer.sendCompleted()
                            }
                        } else {
                            observer.sendFailed(error)
                        }
                    })
                }
            }
            return wordParseSaver
        }
        return producer
    }
    
    static func translate(words : [String]) -> SignalProducer<(String, [String : AnyObject]?), NSError> {
        let producer = SignalProducer<String, NSError>(values: words)
            .flatMap(FlattenStrategy.Concat) { word -> SignalProducer<(String, [String : AnyObject]?), NSError> in
                return WordData.translate(word)
        }
        return producer
    }
    
    static func translate(word : String) -> SignalProducer<(String, [String : AnyObject]?), NSError> {
        let producer = SignalProducer<(String, [String : AnyObject]?), NSError>{ (observer, dispose) in
            let url = "http://fanyi.baidu.com/v2transapi?aldtype=16047&tpltype=sigma&from=en&to=zh&query=" + word
            let request = Alamofire.request(.GET, url)
                .responseData{ response in
                    if let error = response.result.error {
                        observer.sendFailed(error)
                    } else {
                        if let data = response.result.value  {
                            var json = JSON(data: data)
                            
                            var jsonString = json["liju_result"]["double"].string
                            var jsonArr : JSON = nil
                            if let dataFromString = jsonString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                                jsonArr = JSON(data: dataFromString)
                                json["liju_result"]["double"] = jsonArr
                            }
                            
                            jsonString = json["liju_result"]["single"].string
                            jsonArr = nil
                            if let dataFromString = jsonString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                                jsonArr = JSON(data: dataFromString)
                                json["liju_result"]["single"] = jsonArr
                            }
                            
                            let dict = json.dictionaryObject
                            observer.sendNext((word, dict))
                        } else {
                            observer.sendNext((word, nil))
                        }
                        
                        observer.sendCompleted()
                    }
            }
        }
        return producer
    }
    
    private static func parseWordSentence(word: String ,dict: [String : AnyObject]) -> (String, WordData?, [WordSentenceData]){
        //单词意思、音标等 dict_result symbols
        //单词第三人称等各种形式 dict_result exchange
        //例句 liju_result double  每个单词所在数组的下标为0，4（一般为空格和标点符号）所在值拼接在一起，拼在一起就是句子
        //小标3所在值>0，表示高亮
        
        
        //单词
        guard let wordDict = dict["dict_result"] as? [String : AnyObject] else {
            return (word, nil, [])
        }
        let wordData = WordData.word(word, data: wordDict)
        
        //例句
        guard let sentenceDict = dict["liju_result"] as? [String : AnyObject] else {
            return (word, wordData, [])
        }
        
        guard let sentenceArr = sentenceDict["double"] as? [AnyObject] else {
            return (word, wordData, [])
        }
        
        var sentenceDatas : [WordSentenceData] = []
        for sentence in sentenceArr {
            if let sentence = sentence as? [AnyObject] {
                if let sentenceData = WordSentenceData.sentence(sentence) {
                    sentenceDatas.append(sentenceData)
                    //关系数据，必须先把被add的保存成功获得objectId后才能add
                    //                    wordData?.sentences.addObject(sentenceData)
                }
            }
        }
        
        return (word, wordData, sentenceDatas)
    }
    
    private static func word(word: String, data: [String : AnyObject]) -> WordData? {
        guard let simpleMeans = data["simple_means"] as? NSDictionary else {
            return nil
        }
        guard let symbols = simpleMeans["symbols"] as? [[String : AnyObject]] else {
            return nil
        }
        
        if symbols.count <= 0 {
            return nil
        }
        let symbol = symbols[0]
        
        guard let parts = symbol["parts"] as? [NSDictionary] else {
            return nil
        }
        
        if parts.count <= 0 {
            return nil
        }
        
        let ph_am = symbol["ph_am"] as? String
        let ph_en = symbol["ph_en"] as? String
        var desc : [[String : AnyObject]] = []
        for part  in parts {
            var type = part["part"] as?  String
            if type == nil {
                type = part["part_name"]  as?  String
                if type == nil {
                    continue
                }
            }
            guard let means = part["means"] else {
                continue
            }
            
            desc.append(["type" : type!, "means" : means])
        }
        
        let wordData = WordData()
        wordData.word = word
        wordData.phonationAm = ph_am ?? ""
        wordData.phonationEn = ph_en ?? ""
        wordData.desc = desc
        
        guard let exchange = simpleMeans["exchange"] as? NSDictionary else {
            return wordData
        }
        
        if let wordThird = exchange["word_third"] as? [String] {
            wordData.formThird = wordThird.joinWithSeparator(" ")
        } else if let wordThird = exchange["word_third"] as? String {
            wordData.formThird = wordThird ?? ""
        }
        
        if let wordPl = exchange["word_pl"] as? [String] {
            wordData.formPlural = wordPl.joinWithSeparator(" ")
        } else if let wordPl = exchange["word_pl"] as? String {
            wordData.formPlural = wordPl ?? ""
        }
        
        if let wordEr = exchange["word_er"] as? [String] {
            wordData.formCompare = wordEr.joinWithSeparator(" ")
        } else if let wordEr = exchange["word_er"] as? String {
            wordData.formCompare = wordEr ?? ""
        }
        
        if let wordEst = exchange["word_est"] as? [String] {
            wordData.formSuper = wordEst.joinWithSeparator(" ")
        } else if let wordEst = exchange["word_est"] as? String {
            wordData.formSuper = wordEst ?? ""
        }
        
        if let wordPast = exchange["word_past"] as? [String] {
            wordData.formPastTense = wordPast.joinWithSeparator(" ")
        } else if let wordPast = exchange["word_past"] as? String {
            wordData.formPastTense = wordPast  ?? ""
        }
        
        if let wordIng = exchange["word_ing"] as? [String] {
            wordData.formPresent = wordIng.joinWithSeparator(" ")
        } else if let wordIng = exchange["word_ing"] as? String {
            wordData.formPresent = wordIng  ?? ""
        }
        
        if let wordDone = exchange["word_done"] as? [String] {
            wordData.formPastParticiple = wordDone.joinWithSeparator(" ")
        } else if let wordDone = exchange["word_done"] as? String {
            wordData.formPastParticiple = wordDone  ?? ""
        }
        
        return wordData
    }
}
