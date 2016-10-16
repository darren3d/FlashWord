//
//  WordService.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire
import SwiftyJSON

class WordService: NSObject {
    //MARK: 单例
    static let service = WordService()
    private override init() {
        super.init()
    }
    
    func readVocabulary() {
        let documentPath = NSBundle.mainBundle().pathForResource("class_4.xlsx", ofType: nil)
        let spreadsheet = BRAOfficeDocumentPackage.open(documentPath)
        
        guard let worksheet = spreadsheet.workbook.worksheets[0] as? BRAWorksheet else {
            DYLog.error("Xlsx: No Work Sheet")
            return
        }
        
        var words : [String] = []
        for row in worksheet.rows {
            let row = row as! BRARow
            if row.cells.count > 0 {
                let cell = row.cells[0] as! BRACell
                let word = cell.stringValue()
                if word != nil && word.length > 0 {
                    words.append(word)
                }
            }
        }
    }
}
