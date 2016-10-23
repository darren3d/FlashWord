//
//  DYRefreshFooter.swift
//  DYRefresh
//
//  Created by darren on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYRefreshFooter: DYRefreshComponent {
    var triggerRefreshPercent : CGFloat = 1.0
    override var state: DYRefreshState {
        didSet {
            let newState = state
            let oldState = oldValue
            
            if newState == DYRefreshState.Refreshing {
                dispatch_async(dispatch_get_main_queue()){
                    self.performRefresh()
                }
            } else if newState == DYRefreshState.NoMoreData || newState == DYRefreshState.Idle {
                if oldState == DYRefreshState.Refreshing {
                    
                }
            }
        }
    }
    
    override var hidden: Bool {
        didSet {
            let newHidden = hidden
            let oldHidden = oldValue
            
            guard let scrollView = self.scrollView else {
                return
            }
            
            if !oldHidden && newHidden {
                self.state = DYRefreshState.Idle;
                scrollView.contentInset.bottom -= self.frame.size.height;
            } else if (oldHidden && !newHidden) {
                scrollView.contentInset.bottom += self.frame.size.height;
                self.frame.origin.y = scrollView.contentSize.height;
            }
        }
    }
    
    class func footer(frame:CGRect, block:DYRefreshComponentBlock) -> DYRefreshFooter {
        let footer = DYRefreshFooter(frame: frame)
        footer.refreshingBlock = block
        return footer
    }
    
    class func footer(frame:CGRect, target:AnyObject, selector:Selector) -> DYRefreshFooter {
        let footer = DYRefreshFooter(frame: frame)
        footer.target = target
        footer.selector = selector
        return footer
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        let oldScrollView = self.scrollView
        super.willMoveToSuperview(newSuperview)
        
        guard let newScrollView = self.scrollView else {
            if (self.hidden == false && oldScrollView != nil) {
                oldScrollView!.contentInset.bottom -= self.frame.size.height;
            }
            return
        }
        
        if (self.hidden == false) {
            newScrollView.contentInset.bottom += self.frame.size.height;
        }
        self.frame.origin.y = newScrollView.contentSize.height;
    }
    
    func endRefreshingWithNoMoreData() {
        self.state = DYRefreshState.NoMoreData
    }
    
    override func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        
        guard let scrollView = self.scrollView else {
            return
        }
        self.frame.origin.y = scrollView.contentSize.height
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if self.state != DYRefreshState.Idle || self.frame.origin.y == 0 {
            return
        }
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        if scrollView.contentInset.top + scrollView.contentSize.height <= scrollView.frame.size.height {
            return
        }
        
        if scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height +
            self.frame.size.height*triggerRefreshPercent + scrollView.contentInset.bottom - self.frame.size.height {
            return
        }
        
        guard let oldOffset = (change?["old"])?.CGPointValue()  else {
            return
        }
        
        guard let newOffset = (change?["new"])?.CGPointValue()  else {
            return
        }
        if newOffset.y <= oldOffset.y {
            return
        }
        
        beginRefreshing()
    }
    
    override func scrollViewPanStateDidChange(change: [String : AnyObject]?) {
        super.scrollViewPanStateDidChange(change)
        
        if self.state != DYRefreshState.Idle {
            return
        }
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        if scrollView.panGestureRecognizer.state != UIGestureRecognizerState.Ended {
            return
        }
        
        if scrollView.contentInset.top + scrollView.contentSize.height <= scrollView.frame.size.height {
            if scrollView.contentOffset.y >= -scrollView.contentInset.top { // 向上拽
                beginRefreshing()
            }
        } else if (scrollView.contentOffset.y >= scrollView.contentSize.height+scrollView.contentInset.bottom-scrollView.frame.size.height) {
            beginRefreshing()
        }
    }
    
    
}
