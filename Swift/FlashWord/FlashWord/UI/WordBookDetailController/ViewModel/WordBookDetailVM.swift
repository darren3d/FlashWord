//
//  WordBookDetailVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/23.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

class WordBookDetailVM: DYListViewModel {
    var myBookID : String = ""
    var myBookData : MyWordBookData?
    var bookData : WordBookData?
    
    init(myBookID: String) {
        super.init(sections: [], data: nil)
        self.myBookID = myBookID
    }
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool{
        var sections: [DYSectionViewModel] = []

        if let bookData = bookData {
            for wordData in bookData.wordDatas {
                let item = WordDataCellVM(data: wordData)
                let section = DYSectionViewModel(items: [item])
                sections.append(section)
            }
        }
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        guard let bookData = bookData else {
            return false
        }
        
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let limit = AppConst.kBigDataLoadLimit
        let producer = bookData.updateWordDatas(policy: policy, limit: limit)
        producer.start(Observer<[WordData], NSError>(
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
                next: {[weak self] (words) in
                    self?.vm_reloadData(sortID: Int64(-1), callback: callback)
                }
            ))
        
        return true
    }
    
    override func vm_loadMoreData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        guard let bookData = bookData else {
            return false
        }
        
        if !super.vm_loadMoreData(policy: policy, callback: callback) {
            return false
        }
        
        let limit = AppConst.kBigDataLoadLimit
        let producer = bookData.loadMoreWordDatas(policy: policy, limit: limit)
        producer.start(Observer<[WordData], NSError>(
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
            next: {[weak self] (words) in
                self?.vm_reloadData(sortID: Int64(-1), callback: callback)
            }
        ))
        
        return true
    }
}
