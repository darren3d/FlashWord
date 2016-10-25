//
//  RAC+Utility.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import ReactiveCocoa

extension RACSignal {
    func subscribeNextAs<T>(nextClosure:(T) -> ()) -> () {
        self.subscribeNext {
            (next: AnyObject!) -> () in
            let nextAsT = next! as! T
            nextClosure(nextAsT)
        }
    }
    
    func mapAs<T: AnyObject, U: AnyObject>(mapClosure:(T) -> U) -> RACSignal {
        return self.map {
            (next: AnyObject!) -> AnyObject! in
            let nextAsT = next as! T
            return mapClosure(nextAsT)
        }
    }
    
    func filterAs<T: AnyObject>(filterClosure:(T) -> Bool) -> RACSignal {
        return self.filter {
            (next: AnyObject!) -> Bool in
            let nextAsT = next as! T
            return filterClosure(nextAsT)
        }
    }
    
    func doNextAs<T: AnyObject>(nextClosure:(T) -> ()) -> RACSignal {
        return self.doNext {
            (next: AnyObject!) -> () in
            let nextAsT = next as! T
            nextClosure(nextAsT)
        }
    }
}


// a struct that replaces the RAC macro
struct RAC  {
    var target : NSObject!
    var keyPath : String!
    var nilValue : AnyObject!
    
    init(target aTarget: NSObject!, keyPath path: String, nilValue: AnyObject? = nil) {
        self.target = aTarget
        self.keyPath = path
        self.nilValue = nilValue
    }
    
    
    func assignSignal(signal : RACSignal) {
        signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

func <= (rac: RAC, signal: RACSignal) {
    rac.assignSignal(signal)
}

func >= (signal: RACSignal, rac: RAC) {
    rac.assignSignal(signal)
}

func RACObserve(target obj: NSObject!, keyPath path: String) -> RACSignal  {
    return obj.rac_valuesForKeyPath(path, observer: obj)
}
