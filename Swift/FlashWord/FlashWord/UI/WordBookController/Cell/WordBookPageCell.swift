//
//  WordBookPageCell.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

class WordBookPageCell: UICollectionViewCell {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    
    var listVM : MyWordBookListVM!
    override var cellViewModel: DYViewModel? {
        get {
            return listVM
        }
        set {
            if let listVM = newValue as? MyWordBookListVM {
                listVM.vm_scrollView = collectionView
                self.listVM = listVM
                
                self.collectionView.dataSource = listVM
                self.collectionView.delegate = listVM
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.backgroundColor = UIColor.flat(FlatColors.Nephritis).colorWithAlphaComponent(0.2)
        
        ui_setupRefresher()
    }
}

extension WordBookPageCell {
    func ui_setupRefresher() {
        self.collectionView.dy_setupHeader(target: self, selector: #selector(ui_updateData))
        self.collectionView.dy_setupFooter(target: self, selector: #selector(ui_loadMoreData))
        let colors = [UIColor.flat(FlatColors.Nephritis),
                      UIColor.flat(FlatColors.Flamingo),
                      UIColor.flat(FlatColors.PeterRiver),
                      UIColor.flat(FlatColors.California)]
        
        let header = self.collectionView.dy_header as! DYRefreshBallHeader
        header.setBallColors(colors)
        
        let footer = self.collectionView.dy_footer as! DYRefreshBallFooter
        footer.setBallColors(colors)
    }
    
    func ui_updateData() {
        listVM.vm_updateData(policy: AVCachePolicy.NetworkElseCache) { (obj, error) in

        }
    }
    
    
    func ui_loadMoreData() {
//        listVM.vm_loadMoreData { (obj, error) in
//            <#code#>
//        }
    }
}
