//
//  WordBookDetailController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

@objc
class WordBookDetailController: DYViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    var myBookID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let viewModel = WordBookDetailVM(myBookID: myBookID)
        viewModel.vm_scrollView = collectionView
        viewModel.vm_viewController = self
        self.viewModel = viewModel
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 120)
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        
        ui_setupRefresher()
        
        let barRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(onBarBtnRight(_:)))
        self.navigationItem.rightBarButtonItem = barRight
    }
    
    override func viewFirstWillAppear() {
        super.viewFirstWillAppear()
        
        ui_updateData(policy: AVCachePolicy.CacheOnly)
    }
    
    override func viewFirstDidAppear() {
        super.viewFirstDidAppear()
        
        collectionView.dy_header?.beginRefreshing()
    }
    
    func onBarBtnRight(sender:AnyObject!) {
        Navigator.pushURL("/word/search")
        
        
//        MyWordBookData.addMyWordBook("生词本", desc: "一些不熟悉的单词集合", type: MyWordBookData.BookType.NewWord)
//        .start(Observer<MyWordBookData?, NSError>(
//            failed: { error in
//                DYLog.info("failed:\(error.localizedDescription)")
//            },
//            completed: {
//                DYLog.info("completed")
//            },
//            interrupted: {
//                DYLog.info("interrupted")
//            },
//            next: { myBook in
//                if myBook == nil {
//                    DYLog.info("myBook : empty")
//                } else {
//                    DYLog.info("myBook : myBook")
//                }
//            }
//            ))
//        return
//        
//        let produce = WordData.addWordData("word")
//        produce.start(Observer<(String, WordData?), NSError>(
//                    failed: { error in
//                        DYLog.info("failed:\(error.localizedDescription)")
//                    },
//                    completed: {
//                        DYLog.info("completed")
//                    },
//                    interrupted: {
//                        DYLog.info("interrupted")
//                    },
//                    next: { (word, wordData) in
//                        if wordData == nil {
//                            DYLog.info("word : \(word)  dict: 0")
//                        } else {
//                            DYLog.info("word : \(word)  dict: \(wordData!.desc.count)")
//                        }
//                    }))
//        return
//        
//        let queryWord = WordData.query()
//        queryWord.cachePolicy = AVCachePolicy.CacheElseNetwork
//        queryWord.findObjectsInBackgroundWithBlock {[weak self] (words, error) in
//            guard let _ = self else {
//                return
//            }
//            
//            if error != nil {
//                DYLog.error(error.localizedDescription)
//                return
//            }
//            
//            let queryMode = LearnModeData.query()
//            queryMode.orderByAscending("mode")
//            queryMode.cachePolicy = AVCachePolicy.CacheElseNetwork
//            queryMode.findObjectsInBackgroundWithBlock {[weak self] (modes, error) in
//                guard let _ = self else {
//                    return
//                }
//                
//                if error != nil {
//                    DYLog.error(error.localizedDescription)
//                    return
//                }
//                
//                if words.count < 4 || modes.count <= 0 {
//                    return
//                }
//                
//                let words = words as! [WordData]
//                let optionWords = Array(words[1...3])
//                let word = words[0]
//                
//                var modes = modes as! [LearnModeData]
//                let mode0 = modes[0]
//		
//                modes = Array(modes[0...0])
//                let para = WordTestPara()
//                let key = String(mode0.mode)
//                para.countPerMode[key] = 1
//                
//                let produce = WordTestData.createTest(words, modes: modes, para: para)
//                produce.start(Observer<WordTestData!, NSError>(
//                    failed: { error in
//                        DYLog.info("failed:\(error.localizedDescription)")
//                    },
//                    completed: {
//                        DYLog.info("completed")
//                    },
//                    interrupted: {
//                        DYLog.info("interrupted")
//                    },
//                    next: { questin in
//                        DYLog.info("next")
//                    }))
        
//                let produce = WordQuestionData.createQuestion(word, mode: mode, optionWords: optionWords)
//                produce.start(Observer<WordQuestionData!, NSError>(
//                    failed: { error in
//                        DYLog.info("failed:\(error.localizedDescription)")
//                    },
//                    completed: {
//                        DYLog.info("completed")
//                    },
//                    interrupted: {
//                        DYLog.info("interrupted")
//                    },
//                    next: { questin in
//                        DYLog.info("next")
//                    }))
//            }
//        }
    }
}

extension WordBookDetailController {
    func ui_setupRefresher() {
        self.collectionView.dy_setupHeader(target: self, selector: #selector(ui_updateData as Void -> Void))
        let colors = [UIColor.flat(FlatColors.Nephritis),
                      UIColor.flat(FlatColors.Flamingo),
                      UIColor.flat(FlatColors.PeterRiver),
                      UIColor.flat(FlatColors.California)]
        
        let header = self.collectionView.dy_header as! DYRefreshBallHeader
        header.setBallColors(colors)
    }
    
    func ui_updateData() {
        ui_updateData(policy: AVCachePolicy.NetworkElseCache)
    }
    
    func ui_updateData(policy policy: AVCachePolicy) {
        guard let bookDetailVM = self.viewModel as? WordBookDetailVM else {
            return
        }
        
        bookDetailVM.vm_updateData(policy: policy) { (obj, error) in
            
        }
    }
    
    
    func ui_loadMoreData() {
    }
}

extension WordBookDetailController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let viewController = UIStoryboard(name: "FlashWord", bundle: nil)
            .instantiateViewControllerWithIdentifier("WordBookDetailController")
        guard let bookDetailController = viewController as? WordBookDetailController else {
                return nil
        }
        
        guard let myBookID = URL.queryParameters["id"] else {
            return nil
        }
        bookDetailController.myBookID = myBookID
        bookDetailController.hidesBottomBarWhenPushed = true
        return bookDetailController
    }
}
