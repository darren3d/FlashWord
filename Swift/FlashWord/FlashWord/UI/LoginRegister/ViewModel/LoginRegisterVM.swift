//
//  LoginRegisterVM.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/6.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud

class LoginRegisterVM: DYViewModel {
    dynamic var email : String = "     " {
        willSet{
            
        }
        //        didSet {
        //            isEmailValid = email.characters.count >= 6 && email.containsString("@")
        //        }
    }
    dynamic var password : String = "    " {
        willSet{
            
        }
        //        didSet {
        //            isPasswordValid = password.characters.count >= 6 && password.containsString("@")
        //        }
    }
    
    /**email是否合法*/
    dynamic var isEmailValid : Bool = false
    
    /**password是否合法*/
    dynamic var isPasswordValid : Bool = false
    
    /**缓存的是否为注册用户*/
    private var checkDict : [String:Bool] =  [String:Bool]()
    
    override func setupObserver() {
        super.setupObserver()
        
        self.rx_observe(String.self, "email", options: [.Initial, .New], retainSelf: false)
            .subscribeNext {[weak self] email in
                guard let strongSelf = self, let email = email else {
                    return
                }
                
                strongSelf.isEmailValid = email.characters.count >= 6 && email.containsString("@") && email.containsString(".")
                
            }.addDisposableTo(disposeBag)
        
        self.rx_observe(String.self, "password", options: .New, retainSelf: false)
            .subscribeNext {[weak self] password in
                guard let strongSelf = self, let password = password else {
                    return
                }
                
                strongSelf.isPasswordValid = password.characters.count >= 6
                
            }.addDisposableTo(disposeBag)
    }
    
    func accountCheck(callback: AVBooleanResultBlock) {
        let email = self.email.stringByReplacingOccurrencesOfString(" ", withString: "")
        if email.characters.count <= 0 || !isEmailValid {
            return
        }
        
        let exist = checkDict[email]
        if exist != nil {
            callback(exist!, nil)
            return
        }
        
        let query = AccountData.query()
        query.whereKey("email", equalTo: email)
        query.findObjectsInBackgroundWithBlock { [weak self] (users, error) in
            guard var checkDict = self?.checkDict else {
                return
            }
            
            if users.count > 0 {
                DYLog.info("account \(email) exist")
                checkDict[email] = true
                callback(true, nil)
            } else {
                DYLog.info("account \(email) not exist")
                checkDict[email] = false
                callback(false, nil)
            }
        }
    }
}
