//
//  WordService.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import Alamofire

class WordService: NSObject {
    //MARK: 单例
    static let service = WordService()
    private override init() {
        super.init()
    }
    
    func translate(word : String) {
        Alamofire.request(.GET, "http://fanyi.baidu.com/?aldtype=16047&tpltype=sigma#en/zh/word")
            .responseData { response in
                DYLog.info("Request: \(response.request)")
                DYLog.info("Success: \(response.result.isSuccess)")
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: NSUTF8StringEncoding) {
                DYLog.info("Data: \(utf8Text)")
            }
        }
    }
    
    //百度翻译下载发音
    //英式发音
    //http://fanyi.baidu.com/gettts?lan=en&text=word&source=web
    //美式发音
    //http://fanyi.baidu.com/gettts?lan=en&text=word&source=web
    //百度翻译数据都存在tplData中
    //百度翻译页面调用的api
    //http://fanyi.baidu.com/?aldtype=16047&tpltype=sigma#en/zh/word
    //http://fanyi.baidu.com/v2transapi?from=en&to=zh&query=word
}
