//
//  ObjectUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/16.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation

extension NSObject {
    public func dy_getAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>, policy:objc_AssociationPolicy, initial: () -> T) -> T? {
        var value = objc_getAssociatedObject(self, key) as? T
        if value == nil {
            value = initial()
            objc_setAssociatedObject(self, key, value, policy)
        }
        return value
    }
    
    public func dy_setAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>, value: T, policy:objc_AssociationPolicy) {
        objc_setAssociatedObject(self, key, value, policy)
    }
    
    // 通过string创建swift类，类必须用@objc标记
    class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        guard let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
            else {
                return nil
        }
        
        // generate the full name of your class (take a look into your "YourProject-swift.h" file)
        let classStringName = "_TtC\(appName.utf16.count)\(appName)\(className.characters.count)\(className)"
        // return the class!
        let cls : AnyClass? = NSClassFromString(classStringName)
        assert(cls != nil, "class not found, please check className \(className)")
        return cls
    }
}


class WeakWrapper{
    weak var target : AnyObject?
    
    init(){
    }
    
    init(_ target:AnyObject){
        self.target = target;
    }
}