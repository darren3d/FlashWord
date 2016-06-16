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
    
    //    static func dy_getAssociatedObject<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, policy:objc_AssociationPolicy, initial: () -> T) -> T {
    //        var value = objc_getAssociatedObject(host, key) as? T
    //        if value == nil {
    //            value = initial()
    //            objc_setAssociatedObject(host, key, value, policy)
    //        }
    //        return value!
    //    }
    //    
    //    static func dy_setAssociatedObject<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, value: T, policy:objc_AssociationPolicy) {
    //        objc_setAssociatedObject(host, key, value, policy)
    //    }
}


class WeakWrapper{
    weak var target : AnyObject?
    
    init(){
    }
    
    init(_ target:AnyObject){
        self.target = target;
    }
}