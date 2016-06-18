//
//  ViewControllerUtility.swift
//  FlashWord
//
//  Created by darren on 16/6/14.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

extension UIViewController {
    public class func topViewController() -> UIViewController? {
        let rootViewController = UIApplication.sharedApplication().windows.first?.rootViewController
        return self.topViewController(rootViewController)
    }
    
    class func topViewController(viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(selectedViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return self.topViewController(presentedViewController)
        } else {
            for subview in viewController?.view?.subviews ?? [] {
                if let childViewController = subview.nextResponder() as? UIViewController {
                    return self.topViewController(childViewController)
                }
            }
        }
        
        return viewController
    }
}