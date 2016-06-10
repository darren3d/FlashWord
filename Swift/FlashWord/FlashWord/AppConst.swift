//
//  AppConst.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
public typealias CommonCallback = (object:AnyObject?, error:NSError!)->Void

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


public class AppConst: NSObject {
    private static var kEnviroment = Environment.Invalid
    
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
}
