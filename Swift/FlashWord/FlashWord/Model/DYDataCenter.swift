//
//  DYDataCenter.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation

public class DYDataCenter: NSObject {
    //MARK: 单例
    static let center = DYDataCenter()
    private override init() {
    }
    
    //MARK: 设置构建数据库
    public func setup() {
        //AVSCloud
        AccountData.registerSubclass()
        
        WordData.registerSubclass()
        WordSentenceData.registerSubclass()
        WordBookData.registerSubclass()
        MyWordBookData.registerSubclass()
        WordQuestionData.registerSubclass()
        WordTestData.registerSubclass()
        WordTestPara.registerSubclass()
        
        LearnModeData.registerSubclass()
        
        //CoreData
        let dbName = "com.flashword.data.\(AppConst.appVersion).\(AppConst.appVersionBuild).\(AppConst.enviroment.rawValue)"
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(dbName)
        
        let path = NSPersistentStore.MR_urlForStoreName(dbName)
        DYLog.info("DB Path: \(path!.absoluteString) ")
    }
    
    //MARK: app退出时清理数据库
    public func cleanUp () {
        MagicalRecord.cleanUp()
    }
    
    //MARK: 同步清除所有数据
    public func clearAndWait() {
        
    }
    
    //MARK: 异步清除所有数据
    public func clearWithBlock(completion:CommonCallback?) {
//        MagicalRecord.saveWithBlock({ (context:NSManagedObjectContext!) in
//            
//        }) { (saveDone:Bool, error:NSError!) in
//            completion?(nil, error)
//        }
    }
    
    private static let kDataCenterDBName = "com.flashword.sqlite"
    lazy var dbDirectory :NSURL = {
        var dirName = "com.flashword.data.\(AppConst.appVersion).\(AppConst.appVersionBuild).\(AppConst.enviroment.rawValue)"
        
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cacheRoot = paths.first! as String
        let cacheDirUrl = NSURL.fileURLWithPathComponents([cacheRoot, dirName])!
        if (!NSFileManager.defaultManager().fileExistsAtPath(cacheDirUrl.path!)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(cacheDirUrl,
                                                                        withIntermediateDirectories: true,
                                                                        attributes: nil)
            } catch let error as NSError {
                DYLog.error("\(error.localizedDescription)")
            }
        }
        
        return cacheDirUrl
    }()
    
    lazy var dbPath : NSURL = {
        let dirUrl = self.dbDirectory
        let dbPath = dirUrl.URLByAppendingPathComponent(kDataCenterDBName)
        return dbPath!
    }()
}
