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

class WordDetailVM: DYListViewModel {
    var word : String = ""
    var wordData : WordData?
    
    init(word: String) {
        super.init(sections: [], data: nil)
        self.word = word
    }
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool{
        var sections: [DYSectionViewModel] = []
        
        repeat {
            guard let wordData = self.wordData else {
                break
            }
            
            //section 发音
            let sectionPhonation = DYSectionViewModel(items: [WordPhonationCellVM(data: wordData)])
            sections.append(sectionPhonation)
            
            //section 释义
            var itemsMean : [WordMeanCellVM] = []
            for mean in wordData.desc {
                itemsMean.append(WordMeanCellVM(data:mean))
            }
            let sectionMeans = DYSectionViewModel(items:itemsMean)
            sections.append(sectionMeans)
        } while false
        
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let producer = WordData.dataWithKey(key: "word", value: word, cachePolicy: policy)
        producer.start(Observer<(AnyObject, AVObject?), NSError>(
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
            next: {[weak self] (_, wordData) in
                self?.wordData = wordData as? WordData
                self?.vm_reloadData(sortID: Int64(-1), callback: callback)
            }
        ))
        
        return true
    }
}
