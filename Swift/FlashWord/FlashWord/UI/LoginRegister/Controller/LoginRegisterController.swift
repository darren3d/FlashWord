//
//  LoginRegisterController.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class LoginRegisterController: DYViewController {
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnPhoto : UIButton!
    @IBOutlet var segmentControl : UISegmentedControl!
    
    var pageController : UIPageViewController!
    var loginController : LoginController!
    var registerController : RegisterController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPhoto.hidden = true
        
        setupNavigationBar()
        setupRx()
        
        //获取到嵌入的UIPageViewController
        pageController = self.childViewControllers.first as! UIPageViewController
        //根据Storyboard ID来创建一个View Controller
        loginController = storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        registerController = storyboard?.instantiateViewControllerWithIdentifier("RegisterController") as! RegisterController
        pageController.dataSource = self
        pageController.delegate = self
        
        //手动为pageViewController提供提一个页面
        pageController.setViewControllers([loginController],
                                          direction: UIPageViewControllerNavigationDirection.Forward,
                                          animated: true,
                                          completion: nil)
    }
    
    func setupNavigationBar() {
        let disableColor = UIColor.flat(FlatColors.SilverSand)
        btnBack.titleLabel?.font = UIFont(name: "FontAwesome", size: 22)
        btnBack.setTitle("\u{f060}", forState: UIControlState.Normal)
        btnBack.setTitleColor(disableColor, forState: UIControlState.Normal)
        
        btnPhoto.titleLabel?.font = UIFont(name: "FontAwesome", size: 22)
        btnPhoto.setTitle("\u{f03e}", forState: UIControlState.Normal)
        btnPhoto.setTitleColor(disableColor, forState: UIControlState.Normal)
    }
    
    func setupRx() {
        self.rx_observe(Int.self, "segmentControl.selectedSegmentIndex",
            options: [.Initial, .New], retainSelf: false)
            .map { (index) -> Bool in
                guard let index = index
                    else {
                        return true
                }
                
                return index != 1
            }.bindTo(btnPhoto.rx_hidden)
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onBtnBack(sender : AnyObject) {
        
    }
    
    @IBAction func onBtnPhoto(sender : AnyObject) {
        
    }
    
    @IBAction func onSegmentChanged(sender:AnyObject) {
        let segment = sender as! UISegmentedControl
        let index = segment.selectedSegmentIndex
        if index == 0 {
            pageController.setViewControllers([loginController],
                                              direction: UIPageViewControllerNavigationDirection.Reverse,
                                              animated: true,
                                              completion: nil)
        } else if index == 1 {
            pageController.setViewControllers([registerController],
                                              direction: UIPageViewControllerNavigationDirection.Forward,
                                              animated: true,
                                              completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginRegisterController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: UIPageViewControllerDataSource
    //返回当前页面的下一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isMemberOfClass(LoginController) {
            return registerController
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(RegisterController) {
            return loginController
        }
        return nil
    }
    
    //MARK: UIPageViewControllerDelegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let targetController = pageViewController.viewControllers?.last
            else {
                return
        }
        
        if targetController == loginController {
            btnPhoto.hidden = true
            segmentControl.selectedSegmentIndex = 0
        } else if targetController == registerController {
            btnPhoto.hidden = false
            segmentControl.selectedSegmentIndex = 1
        }
    }
}

