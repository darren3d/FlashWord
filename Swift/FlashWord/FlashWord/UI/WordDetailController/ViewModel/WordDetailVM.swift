//
//  WordDetailVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/23.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

typealias WordDetailSection = Int
extension WordDetailSection {
    static let Phonation = 0
    static let  Meaning = 1
    static let  Sentence = 2
}

@objc (WordDetailVM)
class WordDetailVM: DYListViewModel {
    dynamic var word : String = ""
    dynamic var wordData : WordData?
    dynamic var newBookData : MyWordBookData?
    dynamic var hasAddedWord : TripleState = TripleState.StateUndefined
    
    init(word: String) {
        super.init(sections: [], data: nil)
        self.word = word
    }
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool{
        var sections: [DYSectionViewModel] = []
        let width = self.vm_scrollView!.bounds.size.width
        
        repeat {
            guard let wordData = self.wordData else {
                break
            }
            
            //section 发音
            let sectionPhonation = DYSectionViewModel(items: [WordPhonationCellVM(data: wordData, width: width)])
            sections.append(sectionPhonation)
            
            //section 释义
            var itemsMean : [WordMeanCellVM] = []
            for mean in wordData.desc {
                itemsMean.append(WordMeanCellVM(data:mean, width: width))
            }
            let sectionMeans = DYSectionViewModel(items:itemsMean)
            sections.append(sectionMeans)
            
            //section 例句
            var itemsSentence : [DYListCellVM] = []
            //头部
            let itemSentenceHead = DYListCellVM(data: nil, width: width)
            itemsSentence.append(itemSentenceHead)
            //句子
            let markAttri = TextAttributes()
                .foregroundColor(UIColor.flat(FlatColors.Valencia))
            
            let sentences = wordData.sentenceDatas
            let count = min(2, sentences.count)
            for index in 0..<count {
                let sentenceData = sentences[index]
                itemsSentence.append(WordSentenceCellVM(data:sentenceData, markEn:markAttri, width: width))
            }
            //尾部
            let itemSentenceFoot = DYListCellVM(data: nil, width: width)
            itemsSentence.append(itemSentenceFoot)
            let sectionSentences = DYSectionViewModel(items:itemsSentence)
            sections.append(sectionSentences)
        } while false
        
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let word = self.word
        
        //获取我的生词本
        let user = AccountData.currentUser()
        if user != nil {
            MyWordBookData.myNewWordBook(policy: policy)
                .flatMap(FlattenStrategy.Concat, transform: { [weak self] (newWordBook) -> SignalProducer<Bool, NSError> in
                    self?.newBookData = newWordBook
                    
                    if let newWordBook = newWordBook {
                        return newWordBook.hasWord(word)
                    } else {
                        return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"参数错误，请稍后刷新重试"]))
                    }
                })
                .start(Observer<Bool, NSError>(
                    failed: {[weak self] error in
                        DYLog.info("failed:\(error.localizedDescription)")
                        guard let sSelf = self, let callback = callback else {
                            return
                        }
                        sSelf.hasAddedWord = TripleState.StateUndefined
                        callback(nil, error)
                    },
                    completed: {
                        DYLog.info("completed")
                    },
                    interrupted: {
                        DYLog.info("interrupted")
                    },
                    next: {[weak self] hasAddedWord in
                        if hasAddedWord {
                            self?.hasAddedWord = TripleState.StateYes
                        } else{
                            self?.hasAddedWord = TripleState.StateNo
                        }
                    }
                ))
        }

        
        //更新单词相关信息
        let producer = WordData.dataWithKey(key: "word", value: word, cachePolicy: policy)
        producer.flatMap(FlattenStrategy.Concat) { (_, wordData) -> SignalProducer<(WordData?, [WordSentenceData]?), NSError> in
            if let wordData = wordData as? WordData {
                return wordData.updateSentenceDatas(policy: policy, limit: AppConst.kTinyDataLoadLimit).map({ (sentences) -> (WordData?, [WordSentenceData]?) in
                    return (wordData, sentences)
                })
            } else {
                return SignalProducer<(WordData?, [WordSentenceData]?), NSError>(value:(nil, nil))
            }
        }.start(Observer<(WordData?, [WordSentenceData]?), NSError>(
            failed: {[weak self] error in
                DYLog.info("failed:\(error.localizedDescription)")
                guard let _ = self, let callback = callback else {
                    return
                }
                callback(nil, error)
            },
            completed: {
                DYLog.info("completed")
            },
            interrupted: {
                DYLog.info("interrupted")
            },
            next: {[weak self] (wordData, sentences) in
                self?.wordData = wordData
                self?.vm_reloadData(sortID: Int64(-1), callback: callback)
            }
        ))
        
        return true
    }
}
