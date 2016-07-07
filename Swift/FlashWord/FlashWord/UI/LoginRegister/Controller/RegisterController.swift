//
//  RegisterController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class RegisterController: DYViewController {
    @IBOutlet weak var textFieldEmail : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldPassword : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnRegister : DYSubmitButton!
    @IBOutlet weak var btnUserProtocol : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewModel = LoginVM()
        viewModel = loginViewModel
        
        setupSubViews()
    }
    
    private func setupSubViews() {
        self.view.backgroundColor = UIColor.flat(FlatColors.MidnightBlue)
        
        var colorNorm = UIColor.flat(FlatColors.MidnightBlue)
        var colorHighlighted = UIColor.flat(FlatColors.Shamrock)
        let colorDisable = UIColor.flat(FlatColors.SilverSand)
        btnRegister.normalBackgroundColor = colorNorm
        btnRegister.highlightedBackgroundColor = colorHighlighted
        btnRegister.disableBackgroundColor = colorDisable
        
        btnRegister.layer.cornerRadius = 20;
        self.view.bringSubviewToFront(self.btnRegister)
        
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
        
    }
    
    //MARK: UI Action
    @IBAction private func onButtonRegister(sender: AnyObject) {
        //        AccountData.register(<#T##userName: String!##String!#>, password: <#T##String!#>, callback: <#T##AVBooleanResultBlock?##AVBooleanResultBlock?##(Bool, NSError!) -> Void#>)
    }
}

extension RegisterController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let registerController = UIStoryboard(name: "GuideLogin", bundle: nil)
            .instantiateViewControllerWithIdentifier("RegisterController")
        
        return registerController
    }
}
