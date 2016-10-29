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
    func onFlexCollectionViewCellTouched(item : FlexCollectionItem?)
}

enum FlexCollectionViewCellSwipeState {
    case None
    case Left
    case Right
    case Swiping
}

public class FlexCollectionViewCell: UICollectionViewCell {
    public var reference : String?
    
    public var flexCellTouchDelegate: FlexCollectionViewCellTouchedDelegate?
    
    var _item: FlexCollectionItem? = nil
    public var item: FlexCollectionItem? {
        get {
            return _item
        }
    }
    
    var swipeLeftRightState: FlexCollectionViewCellSwipeState = .None
    var swipeMenuTapRecognizer: UITapGestureRecognizer?
    
    public var cellAppearance: FlexStyleCollectionCellAppearance? {
        didSet {
            self.refreshLayout()
        }
    }
    public func getCellAppearance() -> FlexStyleCollectionCellAppearance {
        return self.cellAppearance ?? flexStyleAppearance.collectionViewAppearance.cellAppearance
    }
    
    public override var selected: Bool {
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
    
    public func initialize() {
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: self.bounds)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.gestureRecognizers?.removeAll()
        swipeLeftRightState = .None
    }

    // MARK: - Swipe Left / Right Menu
    
    func swipeLeft() {
        if self.swipeLeftRightState != .None {
            self.animateSwipeReset()
            return
        }
        self.animateSwipeLeft()
    }
    
    func swipeRight() {
        if self.swipeLeftRightState != .None {
            self.animateSwipeReset()
            return
        }
        self.animateSwipeRight()
    }
    
    private func animateSwipeLeft() {
        self.swipeLeftRightState = .Swiping
        let swipeLength = self.layoutRightSideMenu()
        if let items = item?.swipeLeftMenuItems {
            self.showSwipeMenuItems(items, visible: true)
        }
        let cellContentViewRect = self.contentView.bounds.offsetBy(dx: swipeLength, dy: 0)
        UIView.animateWithDuration(0.4, animations: {
            self.contentView.bounds = cellContentViewRect
        }) { (completed) in
            self.swipeLeftRightState = .Left
            self.swipeMenuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.swipeMenuRightTapped(_:)))
            self.addGestureRecognizer(self.swipeMenuTapRecognizer!)
        }
    }

    private func animateSwipeRight() {
        self.swipeLeftRightState = .Swiping
        let swipeLength = self.layoutLeftSideMenu()
        if let items = item?.swipeRightMenuItems {
            self.showSwipeMenuItems(items, visible: true)
        }
        let cellContentViewRect = self.contentView.bounds.offsetBy(dx: -swipeLength, dy: 0)
        UIView.animateWithDuration(0.4, animations: {
            self.contentView.bounds = cellContentViewRect
        }) { (completed) in
            self.swipeLeftRightState = .Right
            self.swipeMenuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.swipeMenuLeftTapped(_:)))
            self.addGestureRecognizer(self.swipeMenuTapRecognizer!)
        }
    }
    
    func animateSwipeReset() {
        if let mtr = self.swipeMenuTapRecognizer {
            self.removeGestureRecognizer(mtr)
        }
        let cellContentViewRect = CGRectMake(0, 0, self.contentView.bounds.width, self.contentView.bounds.height)
        UIView.animateWithDuration(0.3, animations: {
            self.contentView.bounds = cellContentViewRect
        }) { (completed) in
            self.swipeLeftRightState = .None
            if let items = self.item?.swipeRightMenuItems {
                self.showSwipeMenuItems(items, visible: false)
            }
            if let items = self.item?.swipeLeftMenuItems {
                self.showSwipeMenuItems(items, visible: false)
            }
        }
    }

    private func layoutRightSideMenu() -> CGFloat {
        if let rsm = self.item?.swipeLeftMenuItems {
            self.addSwipeMenuItems(rsm)
            let maxWidth = self.bounds.size.width * 0.8
            let totalMenuRequestedWidth:CGFloat = CGFloat(rsm.count) * self.bounds.size.height
            let wScale:CGFloat = totalMenuRequestedWidth > maxWidth ? maxWidth / totalMenuRequestedWidth : 1
            var curPos = totalMenuRequestedWidth * wScale
            for mi in rsm {
                let pos = CGPointMake(self.bounds.size.width - curPos, 0)
                mi.frame = CGRect(origin: pos, size: CGSizeMake(wScale * self.bounds.size.height, self.bounds.size.height))
                curPos -= wScale * self.bounds.size.height
            }
            return totalMenuRequestedWidth * wScale
        }
        return 0
    }
    
    private func layoutLeftSideMenu() -> CGFloat {
        if let rsm = self.item?.swipeRightMenuItems {
            self.addSwipeMenuItems(rsm)
            let maxWidth = self.bounds.size.width * 0.8
            let totalMenuRequestedWidth:CGFloat = CGFloat(rsm.count) * self.bounds.size.height
            let wScale:CGFloat = totalMenuRequestedWidth > maxWidth ? maxWidth / totalMenuRequestedWidth : 1
            var curPos:CGFloat = 0
            for mi in rsm {
                let pos = CGPointMake(curPos, 0)
                mi.frame = CGRect(origin: pos, size: CGSizeMake(wScale * self.bounds.size.height, self.bounds.size.height))
                curPos += wScale * self.bounds.size.height
            }
            return totalMenuRequestedWidth * wScale
        }
        return 0
    }
    
    private func addSwipeMenuItems(items: [FlexLabel]) {
        for mi in items {
            mi.hidden = true
            if mi.superview == nil {
                self.backgroundView!.addSubview(mi)
            }
        }
    }
    
    private func showSwipeMenuItems(items: [FlexLabel], visible: Bool) {
        for mi in items {
            mi.hidden = !visible
        }
    }

    func swipeMenuLeftTapped(recognizer: UITapGestureRecognizer) {
        let touchedViewPos = recognizer.locationInView(self)
        if let item = self.item, rsm = item.swipeRightMenuItems {
            for mi in rsm {
                if CGRectContainsPoint(mi.frame, touchedViewPos) {
                    self.item?.swipeMenuDelegate?.swipeMenuSelected(item, menuItem: mi)
                }
            }
        }
        self.animateSwipeReset()
    }
    
    func swipeMenuRightTapped(recognizer: UITapGestureRecognizer) {
        let touchedViewPos = recognizer.locationInView(self)
        if let item = self.item, rsm = item.swipeLeftMenuItems {
            for mi in rsm {
                if CGRectContainsPoint(mi.frame, touchedViewPos) {
                    self.item?.swipeMenuDelegate?.swipeMenuSelected(item, menuItem: mi)
                }
            }
        }
        self.animateSwipeReset()
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshLayout()
    }
    
    public func refreshLayout() {
        self.assignBorderLayout()
        self.applyStyles()
        self.backgroundView?.frame = self.bounds
        if self.swipeLeftRightState != .Swiping {
            self.animateSwipeReset()
        }
    }
    
    public func applyStyles() {
    }

    public func assignBorderLayout() {
        let appe = self.getCellAppearance()
        self.layer.borderColor = self.selected ? appe.selectedBorderColor.CGColor : appe.borderColor.CGColor
        self.layer.borderWidth = self.selected ? appe.selectedBorderWidth : appe.borderWidth
    }

}
