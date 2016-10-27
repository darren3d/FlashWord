//
//  AppConst.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
public typealias CommonCallback = (AnyObject?, NSError?)->Void

public enum Environment : Int8 {
    case Invalid = 0
    case Official
    case PreRelease
    case Dev
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<Environment?>) -> Environment? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

extension DefaultsKey {
    public static var enviroment : DefaultsKey<Environment?> {
        return DefaultsKey<Environment?>("com.flashword.enviroment")
    }
}

public struct AppError {
    public static let errorDomain = "dy.flash.word"
    public static let invalidPara = Int(1000)
    public static let needLogin = Int(1001)
}


public class AppConst: NSObject {
    public static let kSmallDataLoadLimit = 10
    public static let kNormDataLoadLimit = 20
    public static let kBigDataLoadLimit = 40
    //受AVScloud限制，不要超过100
    public static let kLargeDataLoadLimit = 80
    
    
    public static let kNotificationSwithToHomeTab = "com.flashword.note.switch.hometab"
    
    private static var kEnviroment = Environment.Invalid
    //MARK: 单个像素对应的屏幕点数
    public static let dotPerPixel : CGFloat = {
        return 1.0/UIScreen.mainScreen().scale
    }();
    
    //MARK: 当前环境
    public static var enviroment : Environment {
        get {
            if kEnviroment == .Invalid {
                if AppConst.isReleaseVersion {
                    kEnviroment = .Official
                    return .Official
                }
                
                guard let env = Defaults[.enviroment] else {
                    kEnviroment = .Dev
                    return kEnviroment
                }
                kEnviroment = env
            }
            return kEnviroment
        }
        
        set (newEnv) {
            kEnviroment = newEnv
            Defaults[.enviroment] = newEnv
        }
    }
    
    //FIXME: 表示此处有bug 或者要优化 列如下
    //TODO: 一般用于写到哪了 做个标记，让后回来继续 例如下
    //MARK: 版本号
    public static var appVersion : String {
        let dict = NSBundle.mainBundle().infoDictionary!
        let version = dict["CFBundleShortVersionString"] as! String
        return version
    }
    
    //MARK: Build版本号
    public static var appVersionBuild : String {
        let dict = NSBundle.mainBundle().infoDictionary!
        let version = dict["CFBundleVersion"] as! String
        return version
    }
    
    public static var isReleaseVersion : Bool {
        let dict = NSBundle.mainBundle().infoDictionary!
        let bundle = dict["CFBundleIdentifier"] as! String
        if ("com.flashword.FlashWord" == bundle) {
            return true
        }
        return false
    }
    
    public static let isLanguageFromLeft2Right : Bool = {
        return UIApplication.sharedApplication().userInterfaceLayoutDirection == .LeftToRight
    }()
}
