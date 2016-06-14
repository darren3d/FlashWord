//
//  LoginViewModel.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//
import RxSwift
import AVOSCloud

class LoginViewModel: DYViewModel {
    var email : String = "     " {
        willSet{
            
        }
        //        didSet {
        //            isEmailValid = email.characters.count >= 6 && email.containsString("@")
        //        }
    }
    var password : String = "    " {
        willSet{
            
        }
        //        didSet {
        //            isPasswordValid = password.characters.count >= 6 && password.containsString("@")
        //        }
    }
    
    /**email是否合法*/
    var isEmailValid : Bool = false
    
    /**password是否合法*/
    var isPasswordValid : Bool = false
    
    /**是否正在登录*/
    var isLoggingIn : Bool = false
    
    override init() {
        super.init()
    }
    
    override func setup(info: NSDictionary?) {
        
        self.rx_observe(String.self, "email", options: [.Initial, .New], retainSelf: false)
            .subscribeNext {[weak self] email in
                guard let strongSelf = self, let email = email else {
                    return
                }
                
                strongSelf.isEmailValid = email.characters.count >= 6 && email.containsString("@")
                
            }.addDisposableTo(disposeBag)
        
        self.rx_observe(String.self, "password", options: .New, retainSelf: false).asObservable()
            .subscribeNext {[weak self] password in
                guard let password = password else {
                    return
                }
                
                self?.isPasswordValid = password.characters.count >= 6 && password.containsString("@")
                
            }.addDisposableTo(disposeBag)
    }
}
