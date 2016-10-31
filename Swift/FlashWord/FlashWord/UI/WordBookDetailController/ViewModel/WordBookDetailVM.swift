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
        let width = self.vm_scrollView!.bounds.size.width
        
        var sections: [DYSectionViewModel] = []

        if let bookData = bookData {
            for wordData in bookData.wordDatas {
                let item = WordDataCellVM(data: wordData, width:width)
                let section = DYSectionViewModel(items: [item])
                sections.append(section)
            }
        }
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let limit = AppConst.kLargeDataLoadLimit
        
        var producer = SignalProducer<(MyWordBookData?, WordBookData?), NSError>(value: (myBookData, bookData))
        if myBookData == nil || bookData == nil {
            producer = MyWordBookData.dataWithID(objectID: self.myBookID, cachePolicy: policy, includeKeys: ["book"])
                .map({ (data) -> (MyWordBookData?, WordBookData?) in
                    guard let data = data as? MyWordBookData
                        else {
                            return (nil, nil)
                    }
                    return (data, data.book)
                })
        }
        producer.flatMap(FlattenStrategy.Concat) {[weak self] (myBookData, bookData) -> SignalProducer<[WordData], NSError> in
            guard let _ = myBookData,
                let bookData = bookData else {
                    return SignalProducer(error: NSError(domain: AppError.errorDomain, code: AppError.invalidPara, userInfo: ["msg":"数据有误，请稍后重试或删除后重新添加"]))
            }
            self?.myBookData = myBookData
            self?.bookData = bookData
            
            return bookData.updateWordDatas(policy: policy, limit: limit)
        }.start(Observer<[WordData], NSError>(
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
        
        let limit = AppConst.kLargeDataLoadLimit
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
