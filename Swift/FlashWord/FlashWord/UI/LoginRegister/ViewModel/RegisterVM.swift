//
//  RegisterVM.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//
import RxSwift
import AVOSCloud

class RegisterVM: LoginRegisterVM {
    dynamic var gender : DYGender = DYGender.Unknown
    
    /**是否正在登录*/
    dynamic var isLoggingIn : Bool = false
    
    func register(callback: AVBooleanResultBlock?) {
        AccountData.register(email, password: password, gender: gender) { (succeed, error) in
            guard let callback = callback else {
                return
            }
            
            callback(succeed, error)
        }
    }
}
