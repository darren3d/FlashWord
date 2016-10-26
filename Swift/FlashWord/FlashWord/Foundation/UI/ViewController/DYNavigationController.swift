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
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        commonInit()
        resetDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        resetDelegate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
        resetDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        resetDelegate()
        self.view.backgroundColor = UIColor.dy_color(0x22313F);
    }
    
    func commonInit() {
//        // Note that images configured as the back bar button's background do
//        // not have the current tintColor applied to them, they are displayed
//        // as it.
//        UIImage *backButtonBackgroundImage = [UIImage imageNamed:@"02_ic_back_b"];
//        // The background should be pinned to the left and not stretch.
//        backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width - 1, 0, 0)];
//        
//        //    id appearance = [UIBarButtonItem appearanceWhenContainedIn:[self class], nil];
//        //    [appearance setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        //    [appearance setTintColor:nil];
//        
//        self.navigationBar.tintColor = nil;
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
//        if (viewController == nil) {
//            DYLog.error("pushViewController viewController is nil");
//            return;
//        }
        
        if viewController == self.viewControllers.last {
            DYLog.error("pushViewController twice")
            return
        }
        
        if !ignorePushViewController {
            //避免第一次点击跳转很慢
            dispatch_async(dispatch_get_main_queue(), { 
                self.interactivePopGestureRecognizer?.enabled = false
                super.pushViewController(viewController, animated: animated)
            })
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
