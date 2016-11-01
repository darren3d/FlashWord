//
//  WordBookListVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/23.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

struct WordBookListType {
    static let My  = "word.book.my"
    static let Online  = "word.book.my"
}

class WordBookListVM: DYListViewModel {
    var type : String = ""
    
    static func listVM(type :String) -> WordBookListVM? {
        if type == WordBookListType.My {
            return MyWordBookListVM(sections: [])
        } else if type == WordBookListType.Online {
            return OnlineWordBookListVM(sections: [])
        } else {
            return nil
        }
    }
}

class MyWordBookListVM: WordBookListVM {
    private var myNewWordBook : MyWordBookData?
    private var myWordBooks : [MyWordBookData] = []
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool{
        let width = self.vm_scrollView!.bounds.size.width
        
        var sections: [DYSectionViewModel] = []
        if let newWordBook = myNewWordBook {
            let item = MyWordBookCellVM(data: newWordBook, width:width)
            let section = DYSectionViewModel(items: [item])
            sections.append(section)
        }
        
        for myBook in myWordBooks {
            let item = MyWordBookCellVM(data: myBook, width:width)
            let section = DYSectionViewModel(items: [item])
            sections.append(section)
        }
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        if !super.vm_updateData(policy: policy, callback: callback) {
            return false
        }
        
        let limit = AppConst.kNormDataLoadLimit
        let producerMyNewBook = MyWordBookData.myNewWordBook(policy: policy)
        let producerMyBooks = MyWordBookData.myWordBooks(policy: policy, skip: 0, limit: limit)
        let producerZip = producerMyNewBook.zipWith(producerMyBooks)
        producerZip.start(Observer<(MyWordBookData?, [MyWordBookData]), NSError>(
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
                next: {[weak self] (newBook, myBooks) in
                    self?.hasNoMoreData = limit > myBooks.count
                    self?.myNewWordBook = newBook
                    self?.myWordBooks = myBooks
                    self?.vm_reloadData(sortID: Int64(-1), callback: callback)
                }
            ))
        
        return true
    }
    
    override func vm_loadMoreData(policy policy: AVCachePolicy, callback: DYCommonCallback?) -> Bool{
        if !super.vm_loadMoreData(policy: policy, callback: callback) {
            return false
        }
        
        let skip = myWordBooks.count
        let limit = AppConst.kNormDataLoadLimit
        let producerMyBooks = MyWordBookData.myWordBooks(policy: policy, skip: skip, limit: limit)
        producerMyBooks.start(Observer<([MyWordBookData]), NSError>(
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
            next: {[weak self] myBooks in
                self?.hasNoMoreData = limit > myBooks.count
                self?.myWordBooks.appendContentsOf(myBooks)
                self?.vm_reloadData(sortID: Int64(1), callback: callback)
            }
            ))
        
        return true
    }
}

class OnlineWordBookListVM: WordBookListVM {
//    override func vm_reloadData(sortID: Int64, callback: DYCommonCallback?) {
//        <#code#>
//    }
//    
//    override func vm_updateData(callback: DYCommonCallback?) {
//        <#code#>
//    }
//    
//    override func vm_loadMoreData(callback: DYCommonCallback?) {
//        <#code#>
//    }
}
