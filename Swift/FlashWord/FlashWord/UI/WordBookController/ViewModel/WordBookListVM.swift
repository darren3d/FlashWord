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
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) {
        var sections: [DYSectionViewModel] = []
        for myBook in myWordBooks {
            let item = WordBookCellVM(data: myBook)
            let section = DYSectionViewModel(items: [item])
            sections.append(section)
        }
        self.sections = sections
        callback?(nil, nil)
    }
    
    override func vm_updateData(policy policy: AVCachePolicy, callback: DYCommonCallback?) {
        let limit = AppConst.kDataLoadLimit
        let producerMyNewBook = MyWordBookData.myNewWordBook(policy)
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
    }
    
    override func vm_loadMoreData(callback: DYCommonCallback?) {
        let skip = myWordBooks.count
        let limit = AppConst.kDataLoadLimit
        let producerMyBooks = MyWordBookData.myWordBooks(policy: AVCachePolicy.NetworkElseCache, skip: skip, limit: limit)
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
