//
//  DYNavigationController.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/12.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    var ignorePushViewController : Bool = false
    
    deinit {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.dy_color(0x22313F);
    }
    
    func resetDelegate() {
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    func popToFirstViewController(classString : String, animated: Bool) -> [UIViewController]?{
        let viewController = topFirstViewController(classString)!
        return popToViewController(viewController, animated: animated)
    }
    
    func topFirstViewController(classString : String) -> UIViewController? {
        let targetClass : AnyClass = NSObject.swiftClassFromString(classString)
        let viewControllers = self.viewControllers.reverse()
        for vc in viewControllers {
            if vc.isMemberOfClass(targetClass.self) {
                return vc
            }
        }
        return nil
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers.last {
            DYLog.error("pushViewController twice")
            return
        }
        
        if !ignorePushViewController {
            self.interactivePopGestureRecognizer?.enabled = false
            super.pushViewController(viewController, animated: animated)
        } else {
            DYLog.error("pushViewController while animated")
        }
        ignorePushViewController = true
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        // Enable the gesture again once the new controller is shown
        self.interactivePopGestureRecognizer?.enabled = true
        
        //    if ([viewController respondsToSelector:@selector(navigationBarAlpha)]) {
        //        self.navigationBar.alpha = [(FSViewController*)viewController navigationBarAlpha];
        //    }
        ignorePushViewController = false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            //关闭主界面的右滑返回
            return false
        }else{
            return true
        }
    }
    
    override func setNavigationBarHidden(hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        resetDelegate()
    }
}
