//
//  RegisterController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RegisterController: DYStaticTableController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var imageViewHead : UIImageView!
    
    @IBOutlet weak var textFieldEmail : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldPassword : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldGender : SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var btnRegister : DYSubmitButton!
    @IBOutlet weak var btnUserProtocol : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewModel = LoginVM()
        viewModel = loginViewModel
        
        self.tableView.delegate = self
        imageViewHead.layer.masksToBounds = true
        imageViewHead.layer.cornerRadius = imageViewHead.bounds.size.width*0.5;
        
        setupBtnRegister()
        setupBtnForgetPassword()
        setupTextField()
        setupRx()
        
        //        //该手势和tableview的cell点击相冲突
        //        let tapBackground = UITapGestureRecognizer()
        //        tapBackground.rx_event
        //            .subscribeNext { [weak self] _ in
        //                self?.view.endEditing(true)
        //            }
        //            .addDisposableTo(disposeBag)
        //        view.addGestureRecognizer(tapBackground)
    }
    
    func setupBtnRegister() {
        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        
        //SunsetOrange,SilverSand,JordyBlue
        btnRegister.normalBackgroundColor = blurColor
        btnRegister.highlightedBackgroundColor = blurColor.darkenColor(0.15)
        btnRegister.disableBackgroundColor = disableColor
        
        btnRegister.layer.masksToBounds = true
        btnRegister.layer.cornerRadius = 20
        self.view.bringSubviewToFront(btnRegister)
    }
    
    //    func setupBtnRegister() {
    //        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
    //        let disableColor = UIColor.flat(FlatColors.SilverSand)
    //
    //        let fullString = "还没有账号? 立即 注册新账号" as NSString
    //        let markString = "注册新账号" as NSString
    //        let markRange = fullString.rangeOfString(markString as String)
    //        let attrs = TextAttributes()
    //            .font(UIFont.systemFontOfSize(13))
    //            .foregroundColor(blurColor)
    //        let attrString  = NSMutableAttributedString(string: fullString as String)
    //        attrString.addAttributes(TextAttributes().foregroundColor(disableColor))
    //        attrString.addAttributes(attrs, range: markRange)
    //        btnRegiser.setAttributedTitle(attrString, forState: UIControlState.Normal)
    //    }
    
    func setupBtnForgetPassword() {
        
    }
    
    func setupTextField() {
        let blurColor = UIColor.flat(FlatColors.RoyalBlue)
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        
        textFieldEmail.iconColor = disableColor
        textFieldEmail.selectedIconColor = disableColor
        textFieldEmail.iconFont = UIFont(name: "FontAwesome", size: 20)
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
        textFieldPassword.iconFont = UIFont(name: "FontAwesome", size: 20)
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
        
        
        
        textFieldGender.iconColor = disableColor
        textFieldGender.selectedIconColor = disableColor
        textFieldGender.iconFont = UIFont(name: "FontAwesome", size: 20)
        textFieldGender.iconText = "\u{f224}"
        textFieldGender.iconWidth = 30;
        
        textFieldGender.textColor = disableColor
        textFieldGender.titleColor = blurColor
        textFieldGender.selectedTitleColor = blurColor
        textFieldGender.tintColor = disableColor
        textFieldGender.lineColor = disableColor
        textFieldGender.selectedLineColor = blurColor
        textFieldGender.lineHeight = AppConst.dotPerPixel
        textFieldGender.selectedLineHeight = AppConst.dotPerPixel
        
        textFieldGender.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textFieldGender.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textFieldGender.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textFieldGender.placeholder     = "Gender"
        textFieldGender.title           = ""
    }
    
    func setupRx() {
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
        
        
        let emailValid = self.rx_observe(Bool.self, "viewModel.isEmailValid", options: [.Initial, .New], retainSelf: false)
            .map{
                return $0 ?? false
            }
            .shareReplay(1)
        
        let passwordValid = self.rx_observe(Bool.self, "viewModel.isPasswordValid", options: [.Initial, .New], retainSelf: false)
            .map{
                return $0 ?? false
            }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        everythingValid.bindTo(btnRegister.rx_enabled)
            .addDisposableTo(disposeBag)
    }
    
    //MARK: UI Action
    @IBAction private func onButtonRegister(sender: AnyObject) {
        //        AccountData.register(<#T##userName: String!##String!#>, password: <#T##String!#>, callback: <#T##AVBooleanResultBlock?##AVBooleanResultBlock?##(Bool, NSError!) -> Void#>)
    }
    
    @IBAction private func onButtonProtocol(sender: AnyObject) {
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DYLog.error("path: \(indexPath)")
        
        switch (indexPath.section, indexPath.row) {
        case (1, 2):
            showGenderOptions()
            break
        default:
            break
            
        }
    }
    
    func showGenderOptions() {
        let alertController = DOAlertController(title: "请选择您的性别",
                                                message: nil,
                                                preferredStyle: .ActionSheet)
        // OverlayView
        alertController.overlayColor = UIColor.dy_color(0x333333, alpha: 0.75)
        // AlertView
        alertController.alertViewBgColor = UIColor(red:44/255, green:62/255, blue:80/255, alpha:1)
        // Title
        alertController.titleFont = UIFont(name: "GillSans-Bold", size: 18.0)
        alertController.titleTextColor = UIColor(red:241/255, green:196/255, blue:15/255, alpha:1)
        // Message
        alertController.messageFont = UIFont(name: "GillSans-Italic", size: 15.0)
        alertController.messageTextColor = UIColor.whiteColor()
        // Cancel Button
        alertController.buttonFont[.Cancel] = UIFont(name: "GillSans-Bold", size: 16.0)
        // Other Button
        alertController.buttonFont[.Default] = UIFont(name: "GillSans-Bold", size: 16.0)
        // Default Button
        alertController.buttonFont[.Destructive] = UIFont(name: "GillSans-Bold", size: 16.0)
        alertController.buttonBgColor[.Destructive] = UIColor(red: 192/255, green:57/255, blue:43/255, alpha:1)
        alertController.buttonBgColorHighlighted[.Destructive] = UIColor(red:209/255, green:66/255, blue:51/255, alpha:1)
        
        // Create the actions.
        let cancelAction = DOAlertAction(title: "取消", style: .Cancel) { action in
            NSLog("The \"Custom\" alert action sheet's cancel action occured.")
        }
        
        let otherAction = DOAlertAction(title: "男", style: .Default) { action in
            NSLog("The \"Custom\" alert action sheet's other action occured.")
        }
        
        let destructiveAction = DOAlertAction(title: "女", style: .Destructive) { action in
            NSLog("The \"Custom\" alert action sheet's destructive action occured.")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        alertController.addAction(destructiveAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension RegisterController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let registerController = UIStoryboard(name: "GuideLogin", bundle: nil)
            .instantiateViewControllerWithIdentifier("RegisterController")
        
        return registerController
    }
}
