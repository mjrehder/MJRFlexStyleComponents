//
//  FlexCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 23.09.16.
/*
 * Copyright 2016-present Martin Jacob Rehder.
 * http://www.rehsco.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


import UIKit

public protocol FlexCollectionViewCellTouchedDelegate {
    func onFlexCollectionViewCellTouched(_ item : FlexCollectionItem?)
}

enum FlexCollectionViewCellSwipeState {
    case none
    case left
    case right
    case swiping
}

open class FlexCollectionViewCell: UICollectionViewCell {
    open var reference : String?
    
    open var flexCellTouchDelegate: FlexCollectionViewCellTouchedDelegate?
    
    var _item: FlexCollectionItem? = nil
    open var item: FlexCollectionItem? {
        get {
            return _item
        }
    }
    
    var swipeLeftRightState: FlexCollectionViewCellSwipeState = .none
    var swipeMenuTapRecognizer: UITapGestureRecognizer?
    
    open override var isSelected: Bool {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var style: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.setNeedsLayout()
            style.styleChangeHandler = {
                newStyle in
                self.setNeedsLayout()
            }
        }
    }
    
    open dynamic var styleColor: UIColor = .gray {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var selectedStyleColor: UIColor = .lightGray {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var selectedBackgroundColor: UIColor = .lightGray {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var selectedBorderColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var borderColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var borderWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var selectedBorderWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    open func initialize() {
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: self.bounds)
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.gestureRecognizers?.removeAll()
        swipeLeftRightState = .none
    }

    // MARK: - Swipe Left / Right Menu
    
    func swipeLeft() {
        if self.swipeLeftRightState != .none {
            self.animateSwipeReset()
            return
        }
        self.animateSwipeLeft()
    }
    
    func swipeRight() {
        if self.swipeLeftRightState != .none {
            self.animateSwipeReset()
            return
        }
        self.animateSwipeRight()
    }
    
    fileprivate func animateSwipeLeft() {
        self.swipeLeftRightState = .swiping
        let swipeLength = self.layoutRightSideMenu()
        if let items = item?.swipeLeftMenuItems {
            self.showSwipeMenuItems(items, visible: true)
        }
        let cellContentViewRect = self.contentView.bounds.offsetBy(dx: swipeLength, dy: 0)
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.bounds = cellContentViewRect
        }, completion: { (completed) in
            self.swipeLeftRightState = .left
            self.swipeMenuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.swipeMenuRightTapped(_:)))
            self.addGestureRecognizer(self.swipeMenuTapRecognizer!)
        }) 
    }

    fileprivate func animateSwipeRight() {
        self.swipeLeftRightState = .swiping
        let swipeLength = self.layoutLeftSideMenu()
        if let items = item?.swipeRightMenuItems {
            self.showSwipeMenuItems(items, visible: true)
        }
        let cellContentViewRect = self.contentView.bounds.offsetBy(dx: -swipeLength, dy: 0)
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.bounds = cellContentViewRect
        }, completion: { (completed) in
            self.swipeLeftRightState = .right
            self.swipeMenuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.swipeMenuLeftTapped(_:)))
            self.addGestureRecognizer(self.swipeMenuTapRecognizer!)
        }) 
    }
    
    func animateSwipeReset() {
        if let mtr = self.swipeMenuTapRecognizer {
            self.removeGestureRecognizer(mtr)
        }
        let cellContentViewRect = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.bounds = cellContentViewRect
        }, completion: { (completed) in
            self.swipeLeftRightState = .none
            if let items = self.item?.swipeRightMenuItems {
                self.showSwipeMenuItems(items, visible: false)
            }
            if let items = self.item?.swipeLeftMenuItems {
                self.showSwipeMenuItems(items, visible: false)
            }
        }) 
    }

    fileprivate func layoutRightSideMenu() -> CGFloat {
        if let rsm = self.item?.swipeLeftMenuItems {
            self.addSwipeMenuItems(rsm)
            let maxWidth = self.bounds.size.width * 0.8
            let totalMenuRequestedWidth:CGFloat = CGFloat(rsm.count) * self.bounds.size.height
            let wScale:CGFloat = totalMenuRequestedWidth > maxWidth ? maxWidth / totalMenuRequestedWidth : 1
            var curPos = totalMenuRequestedWidth * wScale
            for mi in rsm {
                let pos = CGPoint(x: self.bounds.size.width - curPos, y: 0)
                mi.frame = CGRect(origin: pos, size: CGSize(width: wScale * self.bounds.size.height, height: self.bounds.size.height))
                curPos -= wScale * self.bounds.size.height
            }
            return totalMenuRequestedWidth * wScale
        }
        return 0
    }
    
    fileprivate func layoutLeftSideMenu() -> CGFloat {
        if let rsm = self.item?.swipeRightMenuItems {
            self.addSwipeMenuItems(rsm)
            let maxWidth = self.bounds.size.width * 0.8
            let totalMenuRequestedWidth:CGFloat = CGFloat(rsm.count) * self.bounds.size.height
            let wScale:CGFloat = totalMenuRequestedWidth > maxWidth ? maxWidth / totalMenuRequestedWidth : 1
            var curPos:CGFloat = 0
            for mi in rsm {
                let pos = CGPoint(x: curPos, y: 0)
                mi.frame = CGRect(origin: pos, size: CGSize(width: wScale * self.bounds.size.height, height: self.bounds.size.height))
                curPos += wScale * self.bounds.size.height
            }
            return totalMenuRequestedWidth * wScale
        }
        return 0
    }
    
    fileprivate func addSwipeMenuItems(_ items: [FlexLabel]) {
        for mi in items {
            mi.isHidden = true
            if mi.superview == nil {
                self.backgroundView!.addSubview(mi)
            }
        }
    }
    
    fileprivate func showSwipeMenuItems(_ items: [FlexLabel], visible: Bool) {
        for mi in items {
            mi.isHidden = !visible
        }
    }

    func swipeMenuLeftTapped(_ recognizer: UITapGestureRecognizer) {
        let touchedViewPos = recognizer.location(in: self)
        if let item = self.item, let rsm = item.swipeRightMenuItems {
            for mi in rsm {
                if mi.frame.contains(touchedViewPos) {
                    self.item?.swipeMenuDelegate?.swipeMenuSelected(item, menuItem: mi)
                }
            }
        }
        self.animateSwipeReset()
    }
    
    func swipeMenuRightTapped(_ recognizer: UITapGestureRecognizer) {
        let touchedViewPos = recognizer.location(in: self)
        if let item = self.item, let rsm = item.swipeLeftMenuItems {
            for mi in rsm {
                if mi.frame.contains(touchedViewPos) {
                    self.item?.swipeMenuDelegate?.swipeMenuSelected(item, menuItem: mi)
                }
            }
        }
        self.animateSwipeReset()
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshLayout()
    }
    
    open func refreshLayout() {
        self.assignBorderLayout()
        self.applyStyles()
        self.backgroundView?.frame = self.bounds
        if self.swipeLeftRightState != .swiping {
            self.animateSwipeReset()
        }
    }
    
    open func applyStyles() {
    }

    open func assignBorderLayout() {
        let borderColor = self.isSelected ? self.selectedBorderColor?.cgColor : self.borderColor?.cgColor
        self.layer.borderColor = borderColor
        if borderColor != nil {
            self.layer.borderWidth = self.isSelected ? self.selectedBorderWidth : self.borderWidth
        }
        else {
            self.layer.borderWidth = 0
        }
    }

}
