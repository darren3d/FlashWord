//
//  DYRefreshBallHeader.swift
//  DYRefresh
//
//  Created by darrenyao on 2016/10/19.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYRefreshBallHeader: DYRefreshHeader {
    private var ballView:DYBallView!
    private var waveView:DYWaveView!
    
    var waveColor: UIColor? {
        get {
            return self.waveView.waveColor
        }
        set {
            self.waveView.waveColor = newValue
        }
    }
    
    override var state: DYRefreshState {
        didSet {
            let newState = state
            let oldState = oldValue
            if oldState == newState {
                return
            }
            
            switch newState {
            case DYRefreshState.Idle:
                break
//                waveView.alpha = 0
            case DYRefreshState.Pulling:
                ballView.resetAnimation()
//                waveView.alpha = 1
                break
            case DYRefreshState.Refreshing:
                let offset = self.pullingPercent * self.bounds.size.height
                wave(offset)
                didRelease(offset)
                break
            default: break
                
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            var percent = min(pullingPercent, 1.0)
            percent = max(percent, 0.0)
            let offset = self.pullingPercent * self.bounds.size.height
            wave(offset)
            
            if percent >= 0.01 && percent <= 0.99 {
                ballView.resetAnimation()
            }
        }
    }
    
    override class func header(frame:CGRect, block:DYRefreshComponentBlock) -> DYRefreshHeader {
        let header = DYRefreshBallHeader(frame: frame)
        header.refreshingBlock = block
        header.waveColor = UIColor.whiteColor()
        header.setBallColors([UIColor.brownColor(), UIColor.cyanColor(), UIColor.magentaColor(), UIColor.orangeColor()])
        return header
    }
    
    override class func header(frame:CGRect, target:AnyObject, selector:Selector) -> DYRefreshHeader {
        let header = DYRefreshBallHeader(frame: frame)
        header.target = target
        header.selector = selector
        header.waveColor = UIColor.whiteColor()
        header.setBallColors([UIColor.brownColor(), UIColor.cyanColor(), UIColor.magentaColor(), UIColor.orangeColor()])
        return header
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        waveView = DYWaveView(frame: bounds)
        addSubview(waveView)
        
        ballView = DYBallView(frame: bounds)
        addSubview(ballView)
        ballView.hidden = true
        
        waveView.didEndPull = { [weak self] in
            self?.ballView.hidden = false
            self?.ballView.startAnimation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        waveView.frame = self.bounds
        ballView.frame = self.bounds
    }
    
    override func endRefreshing() {
//        ballView.stopAnimation()
        super.endRefreshing()
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    func setBallColors(colors: [UIColor]) {
        ballView.setBallColors(colors)
    }
    
    func wave(y: CGFloat) {
        waveView.wave(y)
    }
    
    func didRelease(y: CGFloat) {
        waveView.didRelease(y)
    }
}
