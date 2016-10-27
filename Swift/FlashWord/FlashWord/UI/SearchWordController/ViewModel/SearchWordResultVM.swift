//
//  SearchWordResultVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/26.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SearchWordResultVM: DYListViewModel {
    var wordsCD : [WordCD] = []
    
    init(textSignal: RACSignal?) {
        super.init(sections: [], data: nil)
        
        if let textSignal = textSignal {
            setupWithTextSignal(textSignal)
        }
    }
    
    private func setupWithTextSignal(textSignal: RACSignal) {
        let limit = AppConst.kNormDataLoadLimit
        
        let searchTexts = textSignal.toSignalProducer()
            .map { text in text as! String }
            .throttle(0.5, onScheduler: QueueScheduler.mainQueueScheduler)
        
        
        searchTexts.flatMap(FlattenStrategy.Latest) { text -> SignalProducer<[WordCD], NSError> in
            if text.length > 0 {
                return WordCD.searchDatas(text, limit: limit).flatMapError{ error in
                    return SignalProducer.empty
                }
            } else {
                return SignalProducer<[WordCD], NSError>(value:[])
            }
            }.observeOn(UIScheduler())
            .start(Observer<[WordCD], NSError>(
                failed: { error in
                    DYLog.info("failed:\(error.localizedDescription)")
                },
                completed: {
                    DYLog.info("completed")
                },
                interrupted: {
                    DYLog.info("interrupted")
                },
                next: { [weak self] wordsCD in
                    DYLog.info("next")
                    self?.wordsCD = wordsCD
                    self?.vm_reloadData(sortID: -1, callback: nil)
                }
            ))
    }
    
    override func vm_reloadData(sortID sortID: Int64, callback: DYCommonCallback?) -> Bool{
        var sections: [DYSectionViewModel] = []
        
        for wordCD in wordsCD {
            let item = SearchWordCellVM(data: wordCD)
            let section = DYSectionViewModel(items: [item])
            sections.append(section)
        }
        self.sections = sections
        
        return super.vm_reloadData(sortID: sortID, callback: callback)
    }
}


extension SearchWordResultVM {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return SearchWordCell.dequeueReusableCellWithReuseIdentifier(collectionView, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, willDisplayCell: aCell, forItemAtIndexPath: indexPath)
        
        guard let cell = aCell as? SearchWordCell else {
            return
        }
        cell.setDisplayIcon(false)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionCount = self.numberOfSectionsInCollectionView(collectionView);
        if section != sectionCount - 1 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
}
