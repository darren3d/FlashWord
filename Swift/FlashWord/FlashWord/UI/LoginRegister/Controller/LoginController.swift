//
//  LoginController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginController: DYViewController, UIViewControllerTransitioningDelegate, DYUIStateDateSource {
    @IBOutlet weak var textFieldEmail : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldPassword : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnLogin : DYSubmitButton!
    @IBOutlet weak var btnRegiser : UIButton!
    
    //TODO:  使用StatefulViewController重试为空等结合EmptyDataSource，图片缓存用Nuke，字体加载用FontBlaster, PrediKit
    //FIXME: 使用StatefulViewController重试为空等结合EmptyDataSource，图片缓存用Nuke，字体加载用FontBlaster
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dy_stateDataSource = self
        
        //        let testView  = DYUIStateView(frame: self.view.frame)
        //        self.view.addSubview(testView)
        //        testView.snp_makeConstraints { (make) in
        //            make.edges.equalTo(self.view)
        //        }
        //        testView.backgroundColor = UIColor.blueColor()
        //        
        
        self.view.backgroundColor = UIColor.flat(FlatColors.MidnightBlue)
        
        let loginViewModel = LoginVM()
        viewModel = loginViewModel
        
        var colorNorm = UIColor.flat(FlatColors.MidnightBlue)
        var colorHighlighted = UIColor.flat(FlatColors.Shamrock)
        var colorDisable = UIColor.flat(FlatColors.SilverSand)
        btnLogin.normalBackgroundColor = colorNorm
        btnLogin.highlightedBackgroundColor = colorHighlighted
        btnLogin.disableBackgroundColor = colorDisable
        
        btnLogin.layer.cornerRadius = 20;
        self.view.bringSubviewToFront(self.btnLogin)
        
        //        if AppConst.isLanguageFromLeft2Right {
        //            textFieldEmail.iconRotationDegrees = 180
        //            textFieldPassword.iconRotationDegrees = 180
        //        } else { // In RTL languages the plane should point to the other side
        //            textFieldEmail.iconRotationDegrees = 90
        //            textFieldPassword.iconRotationDegrees = 90
        //        }
        
        colorNorm = UIColor.flat(FlatColors.JungleGreen)
        colorHighlighted = colorNorm
        textFieldEmail.iconColor = colorNorm
        textFieldEmail.selectedIconColor = colorHighlighted
        textFieldEmail.iconFont = UIFont(name: "FontAwesome", size: 18)
        textFieldEmail.iconText = "\u{f003}"
        textFieldPassword.iconColor = colorNorm
        textFieldPassword.selectedIconColor = colorHighlighted
        textFieldPassword.iconFont = UIFont(name: "FontAwesome", size: 18)
        textFieldPassword.iconText = "\u{f13e}"
        //http://fontawesome.io/cheatsheet/
        
        
        //参考EGFloatingTextField动画和验证
        colorNorm = UIColor.flat(FlatColors.BurntOrange)
        colorHighlighted = colorNorm.darkerColor()
        textFieldEmail.textColor = colorNorm
        textFieldEmail.selectedTitleColor = colorHighlighted
        textFieldEmail.tintColor = colorHighlighted
        textFieldPassword.textColor = colorNorm
        textFieldPassword.selectedTitleColor = colorHighlighted
        textFieldPassword.tintColor = colorHighlighted
        
        textFieldEmail.lineColor = colorNorm
        textFieldEmail.selectedLineColor = colorHighlighted
        textFieldPassword.lineColor = colorNorm
        textFieldPassword.selectedLineColor = colorHighlighted
        
        // Set custom fonts for the title, placeholder and textfield labels
        textFieldEmail.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldEmail.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldEmail.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textFieldPassword.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldPassword.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldPassword.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        
        textFieldEmail.placeholder     = NSLocalizedString("Email", tableName: "SkyFloatingLabelTextField", comment: "placeholder for the arrival city field")
        textFieldEmail.selectedTitle   = NSLocalizedString("Email2", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        textFieldEmail.title           = NSLocalizedString("Email1", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        textFieldPassword.placeholder     = NSLocalizedString("Password", tableName: "SkyFloatingLabelTextField", comment: "placeholder for the arrival city field")
        textFieldPassword.selectedTitle   = NSLocalizedString("Arrival City", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        textFieldPassword.title           = NSLocalizedString("Arrival City", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        
        
        textFieldEmail.rx_text
            .distinctUntilChanged()
            .subscribeNext {[weak self] email in
                guard let loginViewModel =  self?.viewModel as? LoginVM else {
                    return
                }
                
                loginViewModel.email = email
            }.addDisposableTo(disposeBag)
        
        textFieldPassword.rx_text
            .distinctUntilChanged()
            .subscribeNext{ [weak self] password in
                guard let loginViewModel =  self?.viewModel as? LoginVM else {
                    return
                }
                
                loginViewModel.password = password
            }.addDisposableTo(disposeBag)
        
        //        let emailValid = textFieldEmail.rx_text
        //            .map { $0.characters.count >= 6 && $0.containsString("@") }
        //            .shareReplay(1)
        //        
        //        let passwordValid = textFieldPassword.rx_text
        //            .map { $0.characters.count >= 8 }
        //            .shareReplay(1)
        //        
        //        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
        //            .shareReplay(1)
        //        
        //        everythingValid.bindTo(btnLogin.rx_enabled)
        //            .addDisposableTo(disposeBag)
        //
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    //MARK: UI Action
    @IBAction func onButtonLogin(sender : AnyObject) {
        //        button.animate(1, completion: { () -> () in
        //            let secondVC = SecondViewController()
        //            secondVC.transitioningDelegate = self
        //            self.presentViewController(secondVC, animated: true, completion: nil)
        //        })
        
        //                self?.showProgressView()
        DYLog.info("login next")
        //                self?.dy_state = DYUIState.Empty
        AccountData.login("nanjimeng_lgb@126.com", password: "111111", callback: { (user, error) in
            guard let error = error else {
                DYLog.error("login OK")
                
                guard let user = user as? AccountData else {
                    return
                }
                
                user.age = 13
                user.saveInBackgroundWithBlock({ (succed, error) in
                    if succed {
                        DYLog.error("saveInBackgroundWithBlock")
                    }
                })
                return
            }
            
            switch error.code {
            case 211:
                DYLog.error("未注册")
                DYLog.error("login Failed : \(error)")
            default:
                DYLog.error("login Failed : \(error)")
            }
            
        })
    }
    
    @IBAction func onButtonRegister(sender : AnyObject) {
        
    }
    
    //MARK: DYUIState
    func superViewForUIState(uistate:DYUIState)->UIView? {
        return self.view
    }
    
    func titleForUIState(uistate:DYUIState)->NSAttributedString? {
        return NSAttributedString(string: "TestTestTestTestTestTest")
    }
    
    func descriptionForUIState(uistate:DYUIState)->NSAttributedString? {
        return NSAttributedString(string: "descriptiondescriptiondescriptiondescriptiondescription")
    }
    
    func imageForUIState(uistate:DYUIState)->UIImage? {
        return UIImage(named: "logo-40")
    }
    
    func imageTintColorForUIState(uistate:DYUIState)->UIColor? {
        return nil
    }
    
    func buttonTitleForUIState(uistate:DYUIState, buttonState:UIControlState)->NSAttributedString? {
        return NSAttributedString(string: "Retry")
    }
    
    func buttonImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage? {
        return nil
    }
    
    func buttonBackgroundImageForUIState(uistate:DYUIState, buttonState:UIControlState)->UIImage? {
        return nil
    }
    
    func backgroundColorForUIState(uistate:DYUIState)->UIColor? {
        return nil
    }
    
    func customViewForUIState(uistate:DYUIState)->UIView? {
        return nil
    }
    
    func verticleOffsetForUIState(uistate:DYUIState) -> CGFloat {
        return 0
    }
    
    func spaceHeightForUIState(uistate:DYUIState) -> CGFloat {
        return 20
    }
}
