//
//  WordDetailController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

@objc
class WordDetailController: DYViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    var word : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let viewModel = WordDetailVM(word: word)
        viewModel.vm_scrollView = collectionView
        viewModel.vm_viewController = self
        self.viewModel = viewModel
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 40, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 40, 0)
        //collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 60)
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        
        ui_setupRefresher()
    }
    
    override func viewFirstWillAppear() {
        super.viewFirstWillAppear()
        
        ui_updateData(policy: AVCachePolicy.CacheOnly)
    }
    
    override func viewFirstDidAppear() {
        super.viewFirstDidAppear()
        
        collectionView.dy_header?.beginRefreshing()
    }
}

extension WordDetailController {
    func ui_setupRefresher() {
        self.collectionView.dy_setupHeader(target: self, selector: #selector(ui_updateData as Void -> Void))
        self.collectionView.dy_setupFooter(target: self, selector: #selector(ui_loadMoreData as Void -> Void))
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
        ui_updateData(policy: AVCachePolicy.NetworkElseCache)
    }
    
    func ui_updateData(policy policy: AVCachePolicy) {
        guard let wordDetailVM = self.viewModel as? WordDetailVM else {
            return
        }
        
        wordDetailVM.vm_updateData(policy: policy) { (obj, error) in
            
        }
    }
    
    
    func ui_loadMoreData() {
        ui_loadMoreData(policy: AVCachePolicy.NetworkElseCache)
    }
    
    func ui_loadMoreData(policy policy: AVCachePolicy) {
        //        listVM.vm_loadMoreData { (obj, error) in
        //            <#code#>
        //        }
    }
}

extension WordDetailController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let viewController = UIStoryboard(name: "FlashWord", bundle: nil)
            .instantiateViewControllerWithIdentifier("WordDetailController")
        guard let wordDetailController = viewController as? WordDetailController else {
                return nil
        }
        
        guard let word = URL.queryParameters["word"] else {
            return nil
        }
        wordDetailController.word = word
        wordDetailController.hidesBottomBarWhenPushed = true
        return wordDetailController
    }
}
