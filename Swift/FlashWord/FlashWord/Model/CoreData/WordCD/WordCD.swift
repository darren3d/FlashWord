//
//  WordCD.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/26.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import CoreData
import ReactiveCocoa

@objc(WordCD)
public class WordCD: NSManagedObject {
    @NSManaged public var word: String
    @NSManaged public var level : Int32
}


extension WordCD {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCD> {
//        return NSFetchRequest<WordCD>(entityName: "WordCD");
//    }
    class func searchDatas(text: String, limit: Int = AppConst.kNormDataLoadLimit) -> SignalProducer<[WordCD], NSError> {
        let producer = SignalProducer<[WordCD], NSError> {(observer, dispose) in
            var objectIDs : [NSManagedObjectID] = []
            
            MagicalRecord.saveWithBlock({ (localContext) in
                let predicateF = NSPredicate(format: "word BEGINSWITH[cd] $text")
                let predicate = predicateF.predicateWithSubstitutionVariables(["text": text])
                let fetchRequest = WordCD.MR_requestAllSortedBy("level", ascending: true,
                                                                                                         withPredicate: predicate,
                                                                                                                inContext: localContext)
                fetchRequest.fetchLimit = limit
                if let wordCDs = WordCD.MR_executeFetchRequest(fetchRequest, inContext: localContext) {
                    for word in wordCDs {
                        objectIDs.append(word.objectID)
                    }
                }
                }, completion: { (succeed, error) in
                    if error == nil {
                        var wordCDs : [WordCD] = []
                        for objectID in objectIDs {
                            do {
                                let word = try NSManagedObjectContext.MR_defaultContext().existingObjectWithID(objectID)  as? WordCD
                                if word != nil {
                                    wordCDs.append(word!)
                                }
                            } catch let err as NSError {
                                DYLog.error("existingObjectWithID error : \(err.localizedDescription)")
                            }
                        }
                        observer.sendNext(wordCDs)
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(error!)
                    }
            })
            
            dispose.addDisposable({ 
                DYLog.info("searchDatas dispose: count: \(objectIDs.count)")
            })
        }
        return producer
    }

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
