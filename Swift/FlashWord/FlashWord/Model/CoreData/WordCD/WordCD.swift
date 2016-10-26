//
//  WordCD.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/26.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import CoreData

@objc(WordCD)
public class WordCD: NSManagedObject {
    @NSManaged public var word: String
    @NSManaged public var level : Int32
}


extension WordCD {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCD> {
//        return NSFetchRequest<WordCD>(entityName: "WordCD");
//    }

    class func checkWordCD() {
        MagicalRecord.saveWithBlock({ (context) in
            let count = WordCD.MR_countOfEntitiesWithContext(context)
            if count <= 40000 {
                let words = self.readVocabulary()
                let wordsCount = words.count
                
                for index in 0..<wordsCount {
                    let word = words[index]
                    let wordCD = WordCD.MR_createEntityInContext(context)
                    wordCD?.word = word
                    wordCD?.level = index+1
                }
            }
        }) { (succeed, error) in
            if let error = error {
                DYLog.error("checkWordCD error: \(error.localizedDescription)")
            }
        }
    }
    
    private class func readVocabulary() -> [String] {
        let documentPath = NSBundle.mainBundle().pathForResource("vocabulary.xlsx", ofType: nil)
        let spreadsheet = BRAOfficeDocumentPackage.open(documentPath)
        
        guard let worksheet = spreadsheet.workbook.worksheets[0] as? BRAWorksheet else {
            DYLog.error("Xlsx: No Work Sheet")
            return []
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
        
        return words
    }
}
