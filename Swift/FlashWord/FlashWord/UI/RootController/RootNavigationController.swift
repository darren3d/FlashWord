//
//  RootNavigationController.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/6.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension DefaultsKeys {
    static let appGuideVersion = DefaultsKey<String>("app.guide.last.version")
}

class RootNavigationController: UINavigationController {
    override func awakeFromNib() {
        let lastGuideVersion = Defaults[.appGuideVersion]
        let appVersion = AppConst.appVersion
//        if lastGuideVersion != appVersion {
            Defaults[.appGuideVersion] = appVersion
            switchToGuide(false)
//        }
    }
    
    //MARK:导航到引导页
    func switchToGuide(animate : Bool) -> Void {
        let loginViewController = UIStoryboard(name: "GuideLogin", bundle: nil)
            .instantiateViewControllerWithIdentifier("LoginController")
        setNavigationBarHidden(true, animated: false)
        setViewControllers([loginViewController], animated: animate)
    }
    
    func switchToRootTab(animate : Bool) -> Void {
        guard let  homeTab = self.storyboard?.instantiateViewControllerWithIdentifier("RootTabBarController")
            else {
                return
        }
        setNavigationBarHidden(true, animated: false)
        setViewControllers([homeTab], animated: true)
    }
}
