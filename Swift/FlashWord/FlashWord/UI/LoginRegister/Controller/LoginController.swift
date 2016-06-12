//
//  LoginController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class LoginController: DYViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var textFieldEmail : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnLogin : DYSubmitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 20;
        self.view.bringSubviewToFront(self.btnLogin)
        
        if AppConst.isLanguageFromLeft2Right {
            self.textFieldEmail.iconRotationDegrees = 90
        } else { // In RTL languages the plane should point to the other side
            self.textFieldEmail.iconRotationDegrees = 180
        }
        
        var colorNorm = UIColor.flat(FlatColors.JungleGreen)
        var colorSelected = colorNorm
        self.textFieldEmail.iconColor = colorNorm
        self.textFieldEmail.selectedIconColor = colorSelected
        self.textFieldEmail.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.textFieldEmail.iconText = "\u{f003}"
        //http://fontawesome.io/cheatsheet/
        
        
        //参考EGFloatingTextField动画和验证
        colorNorm = UIColor.flat(FlatColors.BurntOrange)
        colorSelected = colorNorm.darkerColor()
        self.textFieldEmail.textColor = colorNorm
        self.textFieldEmail.selectedTitleColor = colorSelected
        self.textFieldEmail.tintColor = colorSelected
        
        self.textFieldEmail.lineColor = colorNorm
        self.textFieldEmail.selectedLineColor = colorSelected
        
        // Set custom fonts for the title, placeholder and textfield labels
        self.textFieldEmail.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        self.textFieldEmail.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        self.textFieldEmail.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        
        self.textFieldEmail.placeholder     = NSLocalizedString("Arrival City", tableName: "SkyFloatingLabelTextField", comment: "placeholder for the arrival city field")
        self.textFieldEmail.selectedTitle   = NSLocalizedString("Arrival City", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        self.textFieldEmail.title           = NSLocalizedString("Arrival City", tableName: "SkyFloatingLabelTextField", comment: "title for the arrival city field")
        
    }
    
    //MARK: UI Action
    @IBAction func onButtonSubmit(button: DYSubmitButton) {
        button.animate(1, completion: { () -> () in
            let secondVC = SecondViewController()
            secondVC.transitioningDelegate = self
            self.presentViewController(secondVC, animated: true, completion: nil)
        })
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
