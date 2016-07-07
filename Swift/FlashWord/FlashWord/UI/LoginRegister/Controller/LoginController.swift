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
    @IBOutlet weak var btnForgetPassword : UIButton!
    
    //TODO:  使用StatefulViewController重试为空等结合EmptyDataSource，图片缓存用Nuke，字体加载用FontBlaster, PrediKit,ARSLineProgress
    //FIXME: 使用StatefulViewController重试为空等结合EmptyDataSource，图片缓存用Nuke，字体加载用FontBlaster, https://github.com/jathu/UIImageColors
    //https://github.com/ViccAlexander/Chameleon
    
    //https://github.com/PrideChung/FontAwesomeKit
    ///ZCAnimatedLabel
    //Yalantis/Preloader.Ophiuchus
    //Automatic summarizer text in Swift
    //https://github.com/hyperoslo/Hue
    //https://github.com/hyperoslo/Sugar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dy_stateDataSource = self
        
        //        let testView  = DYUIStateView(frame: self.view.frame)
        //        self.view.addSubview(testView)
        //        testView.snp_makeConstraints { (make) in
        //            make.edges.equalTo(self.view)
        //        }
        //        testView.backgroundColor = UIColor.blueColor()
        
        
        let loginViewModel = LoginVM()
        viewModel = loginViewModel
        
        setupBtnLogin()
        setupBtnRegister()
        setupBtnForgetPassword()
        setupTextField()
        
        //        btnLogin.enabled = false
        
        //        if AppConst.isLanguageFromLeft2Right {
        //            textFieldEmail.iconRotationDegrees = 180
        //            textFieldPassword.iconRotationDegrees = 180
        //        } else { // In RTL languages the plane should point to the other side
        //            textFieldEmail.iconRotationDegrees = 90
        //            textFieldPassword.iconRotationDegrees = 90
        //        }
        
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
        
        let emailValid = textFieldEmail.rx_text
            .map { $0.characters.count >= 6 && $0.containsString("@") }
            .shareReplay(1)
        
        let passwordValid = textFieldPassword.rx_text
            .map { $0.characters.count >= 8 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        everythingValid.bindTo(btnLogin.rx_enabled)
            .addDisposableTo(disposeBag)
        
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    func setupBtnLogin() {
        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        
        //SunsetOrange,SilverSand,JordyBlue
        btnLogin.normalBackgroundColor = blurColor
        btnLogin.highlightedBackgroundColor = blurColor.darkenColor(0.15)
        btnLogin.disableBackgroundColor = disableColor
        
        btnLogin.layer.cornerRadius = 20
        self.view.bringSubviewToFront(self.btnLogin)
    }
    
    func setupBtnRegister() {
        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        
        let fullString = "还没有账号? 立即 注册新账号" as NSString
        let markString = "注册新账号" as NSString
        let markRange = fullString.rangeOfString(markString as String)
        let attrs = TextAttributes()
            .font(UIFont.systemFontOfSize(13))
            .foregroundColor(blurColor)
        let attrString  = NSMutableAttributedString(string: fullString as String)
        attrString.addAttributes(TextAttributes().foregroundColor(disableColor))
        attrString.addAttributes(attrs, range: markRange)
        btnRegiser.setAttributedTitle(attrString, forState: UIControlState.Normal)
    }
    
    func setupBtnForgetPassword() {
        
    }
    
    func setupTextField() {
        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        
        textFieldEmail.iconColor = disableColor
        textFieldEmail.selectedIconColor = disableColor
        textFieldEmail.iconFont = UIFont(name: "FontAwesome", size: 18)
        textFieldEmail.iconText = "\u{f003}"
        textFieldEmail.iconWidth = 30;
        
        textFieldEmail.textColor = disableColor
        textFieldEmail.titleColor = blurColor
        textFieldEmail.selectedTitleColor = blurColor
        textFieldEmail.tintColor = disableColor
        textFieldEmail.lineColor = disableColor
        textFieldEmail.selectedLineColor = blurColor
        textFieldEmail.lineHeight = AppConst.dotPerPixel
        textFieldEmail.selectedLineHeight = AppConst.dotPerPixel
        
        textFieldEmail.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldEmail.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldEmail.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textFieldEmail.placeholder     = "Email"
        textFieldEmail.title           = "Email"
        
        
        textFieldPassword.iconColor = disableColor
        textFieldPassword.selectedIconColor = disableColor
        textFieldPassword.iconFont = UIFont(name: "FontAwesome", size: 18)
        textFieldPassword.iconText = "\u{f13e}"
        textFieldPassword.iconWidth = 30;
        
        textFieldPassword.textColor = disableColor
        textFieldPassword.titleColor = blurColor
        textFieldPassword.selectedTitleColor = blurColor
        textFieldPassword.tintColor = disableColor
        textFieldPassword.lineColor = disableColor
        textFieldPassword.selectedLineColor = blurColor
        textFieldPassword.lineHeight = AppConst.dotPerPixel
        textFieldPassword.selectedLineHeight = AppConst.dotPerPixel
        
        textFieldPassword.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldPassword.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldPassword.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        //        textFieldPassword.iconColor = colorNorm
        //        textFieldPassword.selectedIconColor = colorHighlighted
        //        textFieldPassword.iconFont = UIFont(name: "FontAwesome", size: 18)
        //        textFieldPassword.iconText = "\u{f13e}"
        //        //http://fontawesome.io/cheatsheet/
        //
        //
        //        //参考EGFloatingTextField动画和验证
        //        colorNorm = UIColor.flat(FlatColors.BurntOrange)
        //        colorHighlighted = colorNorm.darkerColor()
        //
        //        textFieldPassword.textColor = colorNorm
        //        textFieldPassword.selectedTitleColor = colorHighlighted
        //        textFieldPassword.tintColor = colorHighlighted
        //
        //
        //        textFieldPassword.lineColor = colorNorm
        //        textFieldPassword.selectedLineColor = colorHighlighted
        
        // Set custom fonts for the title, placeholder and textfield labels
        
        textFieldPassword.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldPassword.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldPassword.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        
        textFieldPassword.placeholder = "Password"
        textFieldPassword.title = "Password"
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    var progressView : DYLineProgress?
    
    //MARK: UI Action
    @IBAction func onButtonLogin(sender : AnyObject) {
        progressView = DYLineProgress(superView: self.view)
        progressView!.show(DYLoaderType.Loading, text: "登录中...")
        
        //        //        button.animate(1, completion: { () -> () in
        //        //            let secondVC = SecondViewController()
        //        //            secondVC.transitioningDelegate = self
        //        //            self.presentViewController(secondVC, animated: true, completion: nil)
        //        //        })
        //        
        //        //                self?.showProgressView()
        //        DYLog.info("login next")
        //        //                self?.dy_state = DYUIState.Empty
        
        AccountData.login("nanjimeng_lgb@126.com", password: "111111", callback: {[weak self] (user, error) in
            
            self?.progressView?.dismissProgress()
            guard let error = error else {
                DYLog.info("login OK")
                guard let _ = user as? AccountData else {
                    DYLog.error("invalid account")
                    return
                }
                
                //通知进入主界面
                NSNotificationCenter.defaultCenter().postNotificationName(AppConst.kNotificationSwithToHomeTab, object: nil)
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
        Navigator.pushURL("/register")
    }
    
    @IBAction func onBtnForgetPassword(sender : AnyObject) {
        
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

extension LoginController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let loginViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("LoginController")
        
        return loginViewController
    }
}
