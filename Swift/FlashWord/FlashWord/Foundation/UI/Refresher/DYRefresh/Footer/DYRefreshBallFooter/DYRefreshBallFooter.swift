//
//  DYRefreshBallFooter.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYRefreshBallFooter: DYRefreshFooter {
    var labelStatus : UILabel!
    /** 所有状态对应的文字 */
    var stateTitles : [DYRefreshState : String] = [:];
    
    var ballView:DYBallView!
    
//    var ballColor: UIColor? {
//        get {
//            return self.waveView.waveColor
//        }
//        set {
//            self.waveView.waveColor = newValue
//        }
//    }
    
    override var state: DYRefreshState {
        didSet {
            let newState = state
            let oldState = oldValue
            if oldState == newState {
                return
            }
            
            self.labelStatus.text = self.stateTitles[self.state];
            
            switch newState {
            case DYRefreshState.Idle:
                labelStatus.hidden = true
                ballView.hidden = true
                break
            case DYRefreshState.Refreshing:
                labelStatus.hidden = true
                ballView.hidden = false
                ballView.startAnimation()
                break
            case DYRefreshState.NoMoreData:
                labelStatus.hidden = false
                ballView.resetAnimation()
                ballView.hidden = true
                //                waveView.alpha = 1
                break
            default: break
                
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            var percent = min(pullingPercent, 1.0)
            percent = max(percent, 0.0)
        }
    }
    
    override class func footer(frame:CGRect, block:DYRefreshComponentBlock) -> DYRefreshBallFooter {
        let footer = DYRefreshBallFooter(frame: frame)
        footer.refreshingBlock = block
        footer.setTitle(" ", forState: DYRefreshState.Idle)
        footer.setTitle(" ", forState: DYRefreshState.Pulling)
        footer.setTitle(" ", forState: DYRefreshState.Refreshing)
        footer.setTitle("没有更多了", forState: DYRefreshState.NoMoreData)
        return footer
    }
    
    override class func footer(frame:CGRect, target:AnyObject, selector:Selector) -> DYRefreshFooter {
        let footer = DYRefreshBallFooter(frame: frame)
        footer.target = target
        footer.selector = selector
        footer.setTitle(" ", forState: DYRefreshState.Idle)
        footer.setTitle(" ", forState: DYRefreshState.Pulling)
        footer.setTitle(" ", forState: DYRefreshState.Refreshing)
        footer.setTitle("没有更多了", forState: DYRefreshState.NoMoreData)
        return footer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        ballView = DYBallView(frame: bounds)
        addSubview(ballView)
        ballView.hidden = true
        
        labelStatus = UILabel(frame: bounds)
        addSubview(labelStatus)
        labelStatus.textColor = UIColor(red: CGFloat(153.0/255.0), green: CGFloat(153.0/255.0), blue: CGFloat(153.0/255.0), alpha:1)
        labelStatus.font = UIFont.systemFontOfSize(14)
        labelStatus.textAlignment = NSTextAlignment.Center;
        
//        self.triggerRefreshPercent = -UIScreen.mainScreen().bounds.size.height * CGFloat(0.5) / bounds.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ballView.frame = self.bounds
        labelStatus.frame = self.bounds
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if self.state != DYRefreshState.Idle || self.frame.origin.y == 0 {
            return
        }
        
        if let scrollView = self.scrollView {
            if scrollView.contentInset.top + scrollView.contentSize.height > scrollView.frame.size.height {
                let idleToPullPercent = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom - self.frame.size.height)
            }
        }
    }
    
    func setTitle(title: String, forState state:DYRefreshState) {
        stateTitles[state] = title
        self.labelStatus.text = self.stateTitles[self.state];
    }
    
    func setBallColors(colors: [UIColor]) {
        ballView.setBallColors(colors)
    }
    
    override func endRefreshing() {
//        ballView.stopAnimation()
        super.endRefreshing()
    }
}
