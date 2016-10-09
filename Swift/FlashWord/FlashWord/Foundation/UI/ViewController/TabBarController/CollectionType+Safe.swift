//
//  CollectionType+Safe.swift
//  DYTabBarController
//
//  Created by darren on 16/8/11.
//  Copyright © 2016年 flashword. All rights reserved.
//

import Foundation

extension CollectionType {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}