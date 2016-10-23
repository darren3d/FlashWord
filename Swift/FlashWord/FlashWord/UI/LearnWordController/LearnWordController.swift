//
//  LearnWordController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

class LearnWordController: DYViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LearnWordVM(sections:[])
        self.viewModel = viewModel
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 66)
        viewModel.vm_updateData(policy: AVCachePolicy.NetworkElseCache) {[weak self] (objs, error) in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                strongSelf.collectionView.reloadData()
            } else {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
