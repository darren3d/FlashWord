//
//  DYColorTab.swift
//  ColorMatchTabs
//
//  Created by Sergey Butenko on 13/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol DYColorTabDataSource: class {
    
    func numberOfItems(inTabSwitcher tabSwitcher: DYColorTab) -> Int
    func tabSwitcher(tabSwitcher: DYColorTab, titleAt index: Int) -> String
    func tabSwitcher(tabSwitcher: DYColorTab, iconAt index: Int) -> UIImage
    func tabSwitcher(tabSwitcher: DYColorTab, hightlightedIconAt index: Int) -> UIImage
    func tabSwitcher(tabSwitcher: DYColorTab, tintColorAt index: Int) -> UIColor
    
}

public class DYColorTab: UIControl {
    
    private struct Const {
        private static let kHighlighterViewOffScreenOffset: CGFloat = 44
        private static let kSwitchAnimationDuration: NSTimeInterval = 0.3
        private static let kHighlighterAnimationDuration: NSTimeInterval = kSwitchAnimationDuration / 2
    }
    
    public weak var dataSource: DYColorTabDataSource?
    
    /// Text color for titles.
    public var titleTextColor: UIColor = .whiteColor()
    
    /// Font for titles.
    public var titleFont: UIFont = .systemFontOfSize(14)
    
    private let stackView = UIView()
    private var buttons: [UIButton] = []
    private var labels: [UILabel] = []
    private(set) lazy var highlighterView: UIView = {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: self.bounds.height))
        let highlighterView = UIView(frame: frame)
        highlighterView.layer.cornerRadius = self.bounds.height / 2
        self.addSubview(highlighterView)
        self.sendSubviewToBack(highlighterView)
        
        return highlighterView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public var frame: CGRect {
        didSet {
            stackView.frame = bounds
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            stackView.frame = bounds
        }
    }
    
    public var selectedSegmentIndex: Int = 0 {
        didSet {
            if oldValue != selectedSegmentIndex {
                transition(from: oldValue, to: selectedSegmentIndex)
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            layoutIfNeeded()
            let countItems = dataSource?.numberOfItems(inTabSwitcher: self) ?? 0
            if countItems > selectedSegmentIndex {
                transition(from: selectedSegmentIndex, to: selectedSegmentIndex)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        moveHighlighterView(toItemAt: selectedSegmentIndex)
    }
    
    public func centerOfItem(atIndex index: Int) -> CGPoint {
        return buttons[index].center
    }
    
    public func setIconsHidden(hidden: Bool) {
        buttons.forEach {
            $0.alpha = hidden ? 0 : 1
        }
    }
    
    public func setHighlighterHidden(hidden: Bool) {
        let sourceHeight = hidden ? bounds.height : 0
        let targetHeight = hidden ? 0 : bounds.height
        
        let animation: CAAnimation = {
            $0.fromValue = sourceHeight / 2
            $0.toValue = targetHeight / 2
            $0.duration = Const.kHighlighterAnimationDuration
            return $0
        }(CABasicAnimation(keyPath: "cornerRadius"))
        highlighterView.layer.addAnimation(animation, forKey: nil)
        highlighterView.layer.cornerRadius = targetHeight / 2
        
        UIView.animateWithDuration(Const.kHighlighterAnimationDuration) {
            self.highlighterView.frame.size.height = targetHeight
            self.highlighterView.alpha = hidden ? 0 : 1
            
            for label in self.labels  {
                label.alpha = hidden ? 0 : 1
            }
        }
    }
    
    public func reloadData() {
        guard let dataSource = dataSource else {
            return
        }
        
        buttons = []
        labels = []
        let count = dataSource.numberOfItems(inTabSwitcher: self)
        for index in 0..<count {
            let button = createButton(forIndex: index, withDataSource: dataSource)
            buttons.append(button)
            stackView.addSubview(button)
            
            let label = createLabel(forIndex: index, withDataSource: dataSource)
            labels.append(label)
            stackView.addSubview(label)
        }
        
        updateStackConstraints()
    }
    
    private func updateStackConstraints() {
        let count = min(buttons.count, labels.count)
        
        var visibleSubviews = [UIView]()
        for index in 0..<count {
            let btn = buttons[index]
            if !btn.hidden {
                visibleSubviews.append(btn)
            }
            
            let lbe = labels[index]
            if !lbe.hidden {
                visibleSubviews.append(lbe)
            }
        }
        let visibleCount = visibleSubviews.count
        if visibleCount <= 0 {
            return
        }
        
        var x : CGFloat = 0
        let subViewWidth = bounds.width / CGFloat(visibleCount)
        
        for subview in visibleSubviews {
            subview.snp_updateConstraints(closure: { (make) in
                make.centerY.equalTo(self)
                make.width.equalTo(subViewWidth)
                make.leading.equalTo(self.snp_leading).offset(x)
            })
            
            x += subViewWidth
        }
    }
    
}

/// Setup
private extension DYColorTab {
    
    private func commonInit() {
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
    
    func createButton(forIndex index: Int, withDataSource dataSource: DYColorTabDataSource) -> UIButton {
        let button = UIButton()
        
        button.setImage(dataSource.tabSwitcher(self, iconAt: index), forState: .Normal)
        button.setImage(dataSource.tabSwitcher(self, hightlightedIconAt: index), forState: .Selected)
        button.addTarget(self, action: #selector(selectButton(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func createLabel(forIndex index: Int, withDataSource dataSource: DYColorTabDataSource) -> UILabel {
        let label = UILabel()
        
        label.hidden = true
        label.textAlignment = .Left
        label.text = dataSource.tabSwitcher(self, titleAt: index)
        label.textColor = titleTextColor
        label.adjustsFontSizeToFitWidth = true
        label.font = titleFont
        
        return label
    }
    
}

private extension DYColorTab {
    
    @objc func selectButton(sender: UIButton) {
        if let index = buttons.indexOf(sender) {
            selectedSegmentIndex = index
        }
    }
    
    func transition(from fromIndex: Int, to toIndex: Int) {
        guard let fromLabel = labels[safe: fromIndex],
            fromIcon = buttons[safe: fromIndex],
            toLabel = labels[safe: toIndex],
            toIcon = buttons[safe: toIndex] else {
                return
        }
        
        let animation = {
            fromLabel.hidden = true
            fromLabel.alpha = 0
            fromIcon.selected = false
            
            toLabel.hidden = false
            toLabel.alpha = 1
            toIcon.selected = true
            
            self.updateStackConstraints()
            
            self.stackView.layoutIfNeeded()
            self.layoutIfNeeded()
            self.moveHighlighterView(toItemAt: toIndex)
        }
        
        UIView.animateWithDuration(
            Const.kSwitchAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 3,
            options: [],
            animations: animation
        ) { _ in
        }
    }
    
    func moveHighlighterView(toItemAt toIndex: Int) {
        guard let countItems = dataSource?.numberOfItems(inTabSwitcher: self) where countItems > toIndex else {
            return
        }
        
        let toLabel = labels[toIndex]
        let toIcon = buttons[toIndex]
        
        // offset for first item
        let point = convertPoint(toIcon.frame.origin, toView: self)
        let offsetForFirstItem: CGFloat = toIndex == 0 ? -Const.kHighlighterViewOffScreenOffset : 0
        highlighterView.frame.origin.x = point.x + offsetForFirstItem
        
        // offset for last item
        let offsetForLastItem: CGFloat = toIndex == countItems - 1 ? Const.kHighlighterViewOffScreenOffset : 0
        highlighterView.frame.size.width = toLabel.bounds.width + (toLabel.frame.origin.x - toIcon.frame.origin.x) + 10 - offsetForFirstItem + offsetForLastItem
        
        highlighterView.backgroundColor = dataSource!.tabSwitcher(self, tintColorAt: toIndex)
    }
    
}