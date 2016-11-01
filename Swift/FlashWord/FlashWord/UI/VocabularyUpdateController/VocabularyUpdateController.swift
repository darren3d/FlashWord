//
//  VocabularyUpdateController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/11/1.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

class VocabularyUpdateController: DYViewController {
    @IBOutlet weak var btnUpdate : UIButton!
    @IBOutlet weak var labelStatus : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onBtnUpdate() {
        btnUpdate.userInteractionEnabled = false
        
        var words = WordCD.readVocabulary()
        var count = words.count
        words = Array(words[585..<count])
        count = words.count
        let first = words[0]
        
        var index = 585
        let producer = SignalProducer<String, NSError>(values: words)
        producer.flatMap(FlattenStrategy.Concat) { (word) -> SignalProducer<(String, WordData?), NSError> in
            return WordData.addWordData(word).flatMapError({ (error) -> SignalProducer<(String, WordData?), NSError> in
                return SignalProducer<(String, WordData?), NSError>(value: (word, nil))
            })
        }.start(Observer<(String, WordData?), NSError>(
            failed: { error in
                DYLog.info("failed:\(error.localizedDescription)")
            },
            completed: {
                DYLog.info("completed")
            },
            interrupted: {
                DYLog.info("interrupted")
            },
            next: {[weak self] (text, wordData) in
                index += 1
                var msg = ""
                if let _ = wordData {
                    msg = "count: \(count) index:\(index) succeed: \(text)"
                } else {
                    msg = "count: \(count) index:\(index) failed: \(text)"
                }
                DYLog.error(msg)
                self?.labelStatus.text = msg
            }
        ))
    }
}

extension VocabularyUpdateController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let viewController = UIStoryboard(name: "FlashWord", bundle: nil)
            .instantiateViewControllerWithIdentifier("VocabularyUpdateController")
        guard let vocabularyController = viewController as? VocabularyUpdateController else {
            return nil
        }
        
        vocabularyController.hidesBottomBarWhenPushed = true
        return vocabularyController
    }
}
