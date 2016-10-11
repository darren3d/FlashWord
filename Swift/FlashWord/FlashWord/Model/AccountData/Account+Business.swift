//
//  Account+Business.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import Foundation
import AVOSCloud

extension AccountData {
    static func login(userName: String!, password: String!, callback: AVUserResultBlock?) -> Void {
        AccountData.logInWithUsernameInBackground(userName, password: password) { (user, error) in
            guard let callback = callback else {
                return
            }
            callback(user, error)
        }
    }
    
    static func register(userName: String!, password: String!, gender: DYGender,
                         callback: AVBooleanResultBlock?) -> Void {
        let user = AccountData()
        user.username = userName
        user.password = password
        user.email = userName
        
        user.gender = gender
        
        user.signUpInBackgroundWithBlock { (suceed, error) in
            guard let callback = callback else {
                return
            }
            callback(suceed, error)
        }
    }
}
