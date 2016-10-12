//
//  LoginVM.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import AVOSCloud

class LoginVM: LoginRegisterVM {
    /**是否正在登录*/
    dynamic var isLoggingIn : Bool = false
    
    func login(callback: AVBooleanResultBlock?) {
        AccountData.logInWithUsernameInBackground(email, password: password) { (user, error) in
            guard let callback = callback else {
                return
            }
            
            let succeed : Bool = user != nil
            callback(succeed, error)
        }
    }
}
