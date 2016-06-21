//
//  DYTabBarController.swift
//  FlashWord
//
//  Created by darren on 16/6/21.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYTabBarController: UITabBarController, UITabBarControllerDelegate {
    var tabBarChangeAnimator : DYTransitionAnimator = DYTransitionAnimator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let indexFrom = tabBarController.viewControllers?.indexOf(fromVC), 
            let indexTo = tabBarController.viewControllers?.indexOf(toVC) else {
                tabBarChangeAnimator.para["direction"] = "none"
                return tabBarChangeAnimator
        }
        
        if indexFrom > indexTo {
            tabBarChangeAnimator.para["direction"] = "right"
        } else {
            tabBarChangeAnimator.para["direction"] = "left"
        }
        return tabBarChangeAnimator
    }
}
