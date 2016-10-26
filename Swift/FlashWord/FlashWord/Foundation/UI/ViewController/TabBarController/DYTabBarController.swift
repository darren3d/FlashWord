//
//  DYTabBarController.swift
//  DYTabBarController
//
//  Created by darren on 16/8/12.
//  Copyright © 2016年 flashword. All rights reserved.
//

import UIKit

class DYTabBarController: UITabBarController {
    private var dyViewControllers : [UIViewController] = []
    private var dySelectedIndex : Int = 0
    
    private(set) lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.userInteractionEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces  = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private(set) lazy var colorTab : DYColorTab = {
        var frame = self.tabBar.bounds
        frame.origin.y = 6
        frame.size.height = frame.size.height - 12
        
        let colorTab = DYColorTab(frame: frame)
        colorTab.userInteractionEnabled = true
        colorTab.dataSource = self
        return colorTab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //注意自定义Tabbar不会响应系统的hidesBottomBarWhenPushed
        let tabBar = DYTabBar(frame: self.tabBar.frame)
        tabBar.barStyle = self.tabBar.barStyle
        tabBar.translucent = self.tabBar.translucent
        self.setValue(tabBar, forKey: "tabBar")
        
        self.view.insertSubview(scrollView, belowSubview: self.tabBar)
        scrollView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        
        self.tabBar.addSubview(colorTab)
//        colorTab.snp_makeConstraints { (make) in
//            make.center.equalTo(self.tabBar)
//            make.width.equalTo(self.tabBar)
//            make.height.equalTo(self.tabBar).offset(-12)
//        }
        
        colorTab.addTarget(self, action: #selector(onColorTabChanged(_:)), forControlEvents:.ValueChanged)
        
        setViewControllers(self.childViewControllers, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        emptyTabBarSubViews()
        
        selectedViewController?.viewWillAppear(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedViewController?.viewDidAppear(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        selectedViewController?.viewWillDisappear(false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        selectedViewController?.viewDidDisappear(false)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
////        var frame = self.tabBar.bounds
////        frame.origin.y = 6
////        frame.size.height = frame.size.height - 12
////        colorTab.frame = frame
//        
//        let frame = self.tabBar.bounds
//        colorTab.center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
//        colorTab.bounds = CGRect(x: 0, y: 6, width: frame.size.width, height: frame.size.height - 12)
//    }
    
    private func emptyTabBarSubViews() {
        for subView in self.tabBar.subviews {
            if let control = subView as? UIControl {
                if control != colorTab {
                    control.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func onColorTabChanged(sender: DYColorTab) {
        if self.selectedIndex != sender.selectedSegmentIndex  {
            self.selectedIndex = sender.selectedSegmentIndex
        }
    }
    
    override var selectedIndex: Int {
        get {
            return dySelectedIndex
        }
        set {
            if dySelectedIndex == newValue ||
                scrollView.decelerating ||
                scrollView.dragging {
                return
            }
            let oldSelectedController = dyViewControllers[safe: dySelectedIndex]
            let newSelectedController = dyViewControllers[safe: newValue]
            self.dySelectedIndex = newValue
            
            let size = self.scrollView.bounds.size
            let rectToVisible = CGRect(x: size.width*CGFloat(dySelectedIndex), y: 0, width: size.width, height: size.height)
            scrollView.delegate = nil
            
            oldSelectedController?.viewWillDisappear(false)
            newSelectedController?.viewWillAppear(false)
            scrollView.scrollRectToVisible(rectToVisible, animated: false)
            newSelectedController?.viewDidAppear(false)
            oldSelectedController?.viewDidDisappear(false)
            
            
            scrollView.delegate = self
            
            if dySelectedIndex != colorTab.selectedSegmentIndex {
                colorTab.selectedSegmentIndex = dySelectedIndex
            }
        }
    }
    
    func tabViewControllers() -> [UIViewController] {
        return Array<UIViewController>(dyViewControllers)
    }
    
    override var viewControllers: [UIViewController]? {
        get {
            //always return nil, or something may be wrong
            return nil
        }
        set {
            setViewControllers(newValue, animated: false)
        }
    }
    
    override var selectedViewController: UIViewController? {
        get {
            return (dySelectedIndex >= 0 && dySelectedIndex < dyViewControllers.count) ? dyViewControllers[dySelectedIndex] : nil
        }        
        set {
            guard let newValue = newValue, 
                let index = dyViewControllers.indexOf(newValue) else {
                    return
            }
            self.selectedIndex = index
        }
    }
    
    override func setViewControllers(viewControllers: [UIViewController]?, animated: Bool) {
        guard let viewControllers = viewControllers else {
            return
        }
        
        dyViewControllers = viewControllers
        
        let size = self.scrollView.bounds.size
        self.scrollView.delegate = nil
        self.scrollView.contentOffset = CGPointMake(size.width*CGFloat(dySelectedIndex), 0);
        self.scrollView.contentSize = CGSizeMake(size.width*CGFloat(viewControllers.count), size.height);
        self.scrollView.delegate = self
        
        for (index, childController) in viewControllers.enumerate() {
            childController.removeFromParentViewController()
            
            childController.view.removeFromSuperview()
            
            self.addChildViewController(childController)
            
            childController.view.frame = CGRect(x: size.width*CGFloat(index), y: 0, width: size.width, height: size.height)
            scrollView.addSubview(childController.view)
        }
        
        colorTab.reloadData()
    }
}


extension DYTabBarController : DYColorTabDataSource {
    func numberOfItems(inTabSwitcher tabSwitcher: DYColorTab) -> Int {
        return dyViewControllers.count
    }
    
    func tabSwitcher(tabSwitcher: DYColorTab, titleAt index: Int) -> String {
        guard let title = dyViewControllers[index].tabBarItem.title else {
            return ""
        }
        return title
    }
    
    func tabSwitcher(tabSwitcher: DYColorTab, iconAt index: Int) -> UIImage {
        guard let image = dyViewControllers[index].tabBarItem.image else {
            return UIImage()
        }
        return image
    }
    
    func tabSwitcher(tabSwitcher: DYColorTab, hightlightedIconAt index: Int) -> UIImage {
        guard let image = dyViewControllers[index].tabBarItem.selectedImage else {
            return UIImage()
        }
        return image
    }
    
    func tabSwitcher(tabSwitcher: DYColorTab, tintColorAt index: Int) -> UIColor {
        guard let tabItem = dyViewControllers[index].tabBarItem as? DYTabBarItem else {
            return UIColor()
        }
        return tabItem.colorBackground
    }
}

extension DYTabBarController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x/scrollView.bounds.width))
        colorTab.selectedSegmentIndex = index
    }
}
