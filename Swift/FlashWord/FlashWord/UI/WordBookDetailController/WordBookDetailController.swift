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

class WordBookDetailController: DYViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
        collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 120)
        
        let barRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(onBarBtnRight(_:)))
        self.navigationItem.rightBarButtonItem = barRight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onBarBtnRight(sender:AnyObject!) {
        MyWordBookData.addMyWordBook("生词本", desc: "一些不熟悉的单词集合")
        .start(Observer<MyWordBookData?, NSError>(
            failed: { error in
                DYLog.info("failed:\(error.localizedDescription)")
            },
            completed: {
                DYLog.info("completed")
            },
            interrupted: {
                DYLog.info("interrupted")
            },
            next: { myBook in
                if myBook == nil {
                    DYLog.info("myBook : empty")
                } else {
                    DYLog.info("myBook : myBook")
                }
            }
            ))
        return
        
        let produce = WordData.addWordData("word")
        produce.start(Observer<(String, WordData?), NSError>(
                    failed: { error in
                        DYLog.info("failed:\(error.localizedDescription)")
                    },
                    completed: {
                        DYLog.info("completed")
                    },
                    interrupted: {
                        DYLog.info("interrupted")
                    },
                    next: { (word, wordData) in
                        if wordData == nil {
                            DYLog.info("word : \(word)  dict: 0")
                        } else {
                            DYLog.info("word : \(word)  dict: \(wordData!.desc.count)")
                        }
                    }))
        return
        
        let queryWord = WordData.query()
        queryWord.cachePolicy = AVCachePolicy.CacheElseNetwork
        queryWord.findObjectsInBackgroundWithBlock {[weak self] (words, error) in
            guard let _ = self else {
                return
            }
            
            if error != nil {
                DYLog.error(error.localizedDescription)
                return
            }
            
            let queryMode = LearnModeData.query()
            queryMode.orderByAscending("mode")
            queryMode.cachePolicy = AVCachePolicy.CacheElseNetwork
            queryMode.findObjectsInBackgroundWithBlock {[weak self] (modes, error) in
                guard let _ = self else {
                    return
                }
                
                if error != nil {
                    DYLog.error(error.localizedDescription)
                    return
                }
                
                if words.count < 4 || modes.count <= 0 {
                    return
                }
                
                let words = words as! [WordData]
                let optionWords = Array(words[1...3])
                let word = words[0]
                
                var modes = modes as! [LearnModeData]
                let mode0 = modes[0]
		
                modes = Array(modes[0...0])
                let para = WordTestPara()
                let key = String(mode0.mode)
                para.countPerMode[key] = 1
                
                let produce = WordTestData.createTest(words, modes: modes, para: para)
                produce.start(Observer<WordTestData!, NSError>(
                    failed: { error in
                        DYLog.info("failed:\(error.localizedDescription)")
                    },
                    completed: {
                        DYLog.info("completed")
                    },
                    interrupted: {
                        DYLog.info("interrupted")
                    },
                    next: { questin in
                        DYLog.info("next")
                    }))
                
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
            }
        }
    }
}


extension WordBookDetailController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("WordBookCell", forIndexPath: indexPath)
        return aCell;
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell aCell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = aCell as? WordBookCell else {
            return
        }
        
        cell.setMarkColor(UIColor.flatColor(atIndex:indexPath.section))
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionCount = self.numberOfSectionsInCollectionView(collectionView);
        if section != sectionCount - 1 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
