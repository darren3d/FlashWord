//
//  DYRefreshHeader.swift
//  DYRefresh
//
//  Created by darrenyao on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYRefreshHeader: DYRefreshComponent {
    var ignoredInsetTop : CGFloat = 0;
    private var insetTopDelta : CGFloat = 0
    override var state: DYRefreshState {
        didSet {
            let newState = state
            let oldState = oldValue
            if oldState == newState {
                return
            }
            
            if newState == DYRefreshState.Idle {
                if oldState != DYRefreshState.Refreshing {
                    return
                }
                
                UIView.animateWithDuration(0.4
                    , animations: {
                        if let scrollView = self.scrollView {
                            scrollView.contentInset.top += self.insetTopDelta
                        }
                    }, completion: { finished in
                        self.pullingPercent = 0.0;
                })
            } else if newState == DYRefreshState.Refreshing {
                dispatch_async(dispatch_get_main_queue()){
                    UIView.animateWithDuration(0.25
                        , animations: {
                            if let scrollView = self.scrollView {
                                let top = self.scrollViewOriginalInset.top + self.frame.size.height;
                                scrollView.contentInset.top = top
                                scrollView.setContentOffset(CGPointMake(0, -top), animated: false)
                            }
                        }, completion: { finished in
                            self.performRefresh()
                    })
                }
            }
        }
    }
    
    class func header(frame:CGRect, block:DYRefreshComponentBlock) -> DYRefreshHeader {
        let header = DYRefreshHeader(frame: frame)
        header.refreshingBlock = block
        return header
    }
    class func header(frame:CGRect, target:AnyObject, selector:Selector) -> DYRefreshHeader {
        let header = DYRefreshHeader(frame: frame)
        header.target = target
        header.selector = selector
        return header
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.origin.y = -self.frame.size.height - ignoredInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = self.scrollView else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        
        if self.state == DYRefreshState.Refreshing {
            if self.window == nil {
                return
            }
            
            // sectionheader停留解决
            var insetTop = -offsetY > scrollViewOriginalInset.top ?
                -offsetY : scrollViewOriginalInset.top;
            insetTop = insetTop > self.frame.size.height + scrollViewOriginalInset.top ?
                self.frame.size.height + scrollViewOriginalInset.top  : insetTop;
            scrollView.contentInset.top = insetTop
            self.insetTopDelta = scrollViewOriginalInset.top - insetTop
            return
        }
        
        scrollViewOriginalInset = scrollView.contentInset
        let happenOffsetY = -scrollViewOriginalInset.top;
        
        if offsetY > happenOffsetY {
            return
        }
        
        let normal2pullingOffsetY = happenOffsetY - self.frame.size.height;
        let pullingPercent = (happenOffsetY - offsetY) / self.frame.size.height;
        
        if scrollView.dragging {
            self.pullingPercent = pullingPercent
            if self.state == DYRefreshState.Idle && offsetY < normal2pullingOffsetY {
                self.state = DYRefreshState.Pulling;
            } else if self.state == DYRefreshState.Pulling && offsetY >= normal2pullingOffsetY {
                self.state = DYRefreshState.Idle;
            }
        } else if self.state == DYRefreshState.Pulling {
            beginRefreshing()
        }  else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
        }
    }
    
    override func endRefreshing() {
        dispatch_async(dispatch_get_main_queue()){
            self.state = DYRefreshState.Idle
        }
    }
}
