//
//  FlexMenu.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
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
import StyledLabel

public protocol FlexMenuDataSource {
    func numberOfMenuItems(_ menu: FlexMenu) -> Int
    func menuItemForIndex(_ menu: FlexMenu, index: Int) -> FlexMenuItem
    func menuItemSelected(_ menu: FlexMenu, index: Int)
}

public enum FlexMenuThumbPosition {
    case left
    case top
    case right
    case bottom
}

public enum FlexMenuItemGravity {
    case normal
    case left
    case right
}

public enum FlexMenuStyle {
    case compact
    case equallySpaces(thumbPos: FlexMenuThumbPosition)
    case dynamicallySpaces(thumbPos: FlexMenuThumbPosition)
}

@IBDesignable
open class FlexMenu: GenericStyleSlider, GenericStyleSliderTouchDelegate, GenericStyleSliderDelegate, GenericStyleSliderSeparatorTouchDelegate {
    fileprivate var touchedMenuItem: Int?
    
    open var menuItems: [FlexMenuItem]? {
        didSet {
            self.reloadMenu()
        }
    }
    
    open var menuDataSource: FlexMenuDataSource? {
        didSet {
            self.reloadMenu()
        }
    }

    /*
     Set the menu style. The default is the compact style, which uses sliding thumbs to reduce the size of the menu.
     */
    open var menuStyle: FlexMenuStyle = .compact {
        didSet {
            self.reloadMenu()
        }
    }
    
    /*
     Set the menu item style. The default is the Box style. This is only applied when not using the Compact menu style
     */
    open var menuItemStyle: ShapeStyle = .box {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /*
     Set the menu inter item spacing. The default value is 0. This is only applied when not using the Compact menu style
     */
    @IBInspectable open var menuInterItemSpacing: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /*
     Set the menu item gravity. The default value is 'normal'. This is applied when using vertical direction to rotate the labels and
     should be set to other than 'normal' when the menu is in vertical orientation.
     */
    open var menuItemGravity: FlexMenuItemGravity = .normal {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if frame.isNull || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRect(x: 0,y: 0,width: 90,height: 30)
        }
        super.init(frame: targetFrame)
        self.initMenu()
        self.setupMenuGestures()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initMenu()
        self.setupMenuGestures()
    }

    open func reloadMenu() {
        self.setupMenu()
    }
    
    func initMenu() {
        self.backgroundColor = .clear
        self.continuous = false
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbSnappingBehaviour = .snapToLowerAndHigher
        
        self.addTarget(self, action: #selector(FlexMenu.notifyValueChanged), for: .valueChanged)
    }
    
    @objc func notifyValueChanged() {
        let selItem = self.selectedItem()
        self.menuDataSource?.menuItemSelected(self, index: selItem)
        if let menuItem = self.getMenuItemForIndex(selItem) {
            menuItem.selectionHandler?()
        }
    }
    
    func setupMenu() {
        self.thumbTouchDelegate = self
        self.separatorTouchDelegate = self
        self.sliderDelegate = self
        var vals: [Double] = []
        for _ in 0..<self.getMenuItemsCount() {
            vals.append(0)
        }
        self.values = vals
    }
    
    // MARK: - Public functions
    
    open func selectedItem() -> Int {
        for idx in 1..<self.values.count {
            if self.values[idx] >= 0.5 {
                return idx-1
            }
        }
        return self.values.count-1
    }
    
    open func setSelectedItem(_ index: Int) {
        let selIdx = self.selectedItem()
        if selIdx != index {
            var newVals: [Double] = []
            for _ in 0...index {
                newVals.append(0)
            }
            for _ in (index+1)..<self.values.count {
                newVals.append(1)
            }
            self.values = newVals
        }
    }
    
    // MARK: - Menu Style
    
    override func layoutComponents() {
        switch self.menuStyle {
        case .compact:
            super.layoutComponents()
        case .equallySpaces(let thumbPos):
            let miFrames = self.getEquallySpacedMenuItemFrames()
            self.layoutNonCompactMenuItems(thumbPos, menuItemFrames: miFrames)
            self.applyStylesAndText()
        case .dynamicallySpaces(let thumbPos):
            let miFrames = self.getDynamicallySpacedMenuItemFrames()
            self.layoutNonCompactMenuItems(thumbPos, menuItemFrames: miFrames)
            self.applyStylesAndText()
        }
    }
    
    func applyStylesAndText() {
        applyThumbStyle(thumbStyle)
        applySeparatorStyle(separatorStyle)
        applyStyle(self.getStyle())
        
        self.assignThumbTexts()
        self.assignSeparatorTexts()
    }
    
    func getEquallySpacedMenuItemFrames() -> [CGRect] {
        var rects: [CGRect] = []
        let numSep = self.getMenuItemsCount()
        let maxExt = self.direction.principalSize(self.bounds.size)
        let itemExt = (maxExt - (self.menuInterItemSpacing * (CGFloat(numSep-1)))) / CGFloat(numSep)
        let itemOffset = itemExt + self.menuInterItemSpacing
        for i in 0..<numSep {
            let rect: CGRect
            if self.direction == .horizontal {
                rect = CGRect(x: CGFloat(i) * itemOffset, y: 0, width: itemExt, height: self.bounds.height)
            }
            else {
                rect = CGRect(x: 0, y: CGFloat(i) * itemOffset, width: self.bounds.width, height: itemExt)
            }
            rects.append(rect)
        }
        return rects
    }
    
    fileprivate func getTotalTextWidth() -> CGFloat {
        var totalWidth: CGFloat = 0
        let numSep = self.getMenuItemsCount()
        for i in 0..<numSep {
            let sep = self.separatorForThumb(i)
            if let tSize = self.sizeOfTextLabel(sep) {
                totalWidth += self.direction.principalSize(tSize)
            }
        }
        return totalWidth
    }
    
    func getDynamicallySpacedMenuItemFrames() -> [CGRect] {
        var rects: [CGRect] = []
        let numSep = self.getMenuItemsCount()
        let maxExt = self.direction.principalSize(self.bounds.size)
        let ttWidth = self.getTotalTextWidth()
        let textScaling = ttWidth > 0 ? (maxExt - (self.menuInterItemSpacing * (CGFloat(numSep-1)))) / ttWidth : 1.0
        
        var lastOffset: CGFloat = 0
        for i in 0..<numSep {
            let sep = self.separatorForThumb(i)
            
            let itemExt: CGFloat
            if let tSize = self.sizeOfTextLabel(sep) {
                itemExt = self.direction.principalSize(tSize) * textScaling
            }
            else {
                let thumb = self.thumbList.thumbs[i]
                itemExt = self.direction.principalSize(self.getThumbSize(thumb))
            }
            
            let rect: CGRect
            if self.direction == .horizontal {
                rect = CGRect(x: lastOffset, y: 0, width: itemExt, height: self.bounds.height)
            }
            else {
                rect = CGRect(x: 0, y: lastOffset, width: self.bounds.width, height: itemExt)
            }
            rects.append(rect)
            
            lastOffset += itemExt + self.menuInterItemSpacing
        }
        return rects
    }

    fileprivate func separatorLabelRotation() -> CGFloat {
        switch self.menuItemGravity {
        case .normal:
            return 0
        case .left:
            return CGFloat(Double.pi / 2.0)
        case .right:
            return -CGFloat(Double.pi / 2.0)
            
        }
    }
    
    func layoutNonCompactMenuItems(_ thumbPos: FlexMenuThumbPosition, menuItemFrames: [CGRect]) {
        for idx in 0..<self.getMenuItemsCount() {
            let sep = self.separatorForThumb(idx)
            let thumb = self.thumbList.thumbs[idx]
            let miFrame = menuItemFrames[idx]
            
            let ts = self.getThumbSize(thumb)
            let tp = self.thumbPosInsideSpacedRect(thumb, targetRect: miFrame, thumbPos: thumbPos)
            let tr = CGRect(x: tp.x, y: tp.y, width: ts.width, height: ts.height)
            thumb.frame = tr
            
            let sepRect = self.separatorRectInsideSpacedRect(thumb, targetRect: miFrame, thumbPos: thumbPos)
            sep.frame = sepRect
            sep.rotationInRadians = self.separatorLabelRotation()
        }
    }
    
    func thumbPosInsideSpacedRect(_ thumb: StyledSliderThumb, targetRect: CGRect, thumbPos: FlexMenuThumbPosition) -> CGPoint {
        var tPos = CGPoint.zero
        let ts = self.getThumbSize(thumb)
        let sic = self.direction.principalSize(targetRect.size)
        let sicNP = self.direction.nonPrincipalSize(targetRect.size)
        let tSic = self.direction.principalSize(ts)
        let tSicNP = self.direction.nonPrincipalSize(ts)
        // Center the icon, if there is an empty text
        if let sepText = self.sliderDelegate?.textOfSeparatorLabel(thumb.index+1), sepText == "" {
            tPos = CGPoint(x: (sic - tSic) * 0.5, y: (sicNP - tSicNP) * 0.5)
        }
        else {
            switch thumbPos {
            case .left:
                tPos = CGPoint(x: 0, y: (sicNP - tSicNP) * 0.5)
            case .right:
                tPos = CGPoint(x: sic - tSic, y: (sicNP - tSicNP) * 0.5)
            case .top:
                tPos = CGPoint(x: (sic - tSic) * 0.5, y: 0.0)
            case .bottom:
                tPos = CGPoint(x: (sic - tSic) * 0.5, y: sicNP - tSicNP)
            }
        }
        if self.direction == .vertical && self.menuItemGravity == .right {
            tPos = CGPoint(x: tPos.y, y: (sic - tSic) - tPos.x)
        }
        else if self.direction == .vertical && self.menuItemGravity == .left {
            tPos = CGPoint(x: (sicNP - tSicNP) - tPos.y, y: tPos.x)
        }
        tPos = CGPoint(x: tPos.x + targetRect.origin.x, y: tPos.y + targetRect.origin.y)
        return tPos
    }
    
    func separatorRectInsideSpacedRect(_ thumb: StyledSliderThumb, targetRect: CGRect, thumbPos: FlexMenuThumbPosition) -> CGRect {
        var tRect = targetRect
        let ts = self.getThumbSize(thumb)
        let tSic = self.direction.principalSize(ts)
        let tSicNP = self.direction.nonPrincipalSize(ts)
        if (thumb.text == nil || thumb.text == "" ) && thumb.backgroundIcon == nil {
            // If there is no thumb, then use the entire targetRect for the separator
            return targetRect
        }
        else {
            if self.direction == .vertical && self.menuItemGravity == .right {
                switch thumbPos {
                case .left:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                case .right:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .top:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                case .bottom:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                }
            }
            else if self.direction == .vertical && self.menuItemGravity == .left {
                switch thumbPos {
                case .left:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .right:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                case .top:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                case .bottom:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                }
            }
            else {
                switch thumbPos {
                case .left:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                case .right:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                case .top:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .bottom:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                }
            }
        }
        return tRect
    }
    
    fileprivate func getActiveMenuFrames() -> [CGRect]? {
        switch self.menuStyle {
        case .compact:
            return nil
        case .equallySpaces(_):
            return self.getEquallySpacedMenuItemFrames()
        case .dynamicallySpaces(_):
            return self.getDynamicallySpacedMenuItemFrames()
        }
    }
    
    override func createSeparatorLayer(_ layerRect: CGRect) -> CAShapeLayer {
        var rectColors: [(CGRect, UIColor)] = []
        if let menuItemFrames = self.getActiveMenuFrames() {
            // Add layer with separator background colors
            for idx in 0..<self.getMenuItemsCount() {
                let miFrame = menuItemFrames[idx]
                let bgColor = self.colorOfSeparatorLabel(idx+1) ?? separatorBackgroundColor
                rectColors.append((miFrame, bgColor ?? .clear))
            }
        }
        else {
            return super.createSeparatorLayer(layerRect)
        }

        let sepLayer = StyledShapeLayer.createShape(self.getStyle(), bounds: layerRect, shapeStyle: self.menuItemStyle, colorRects: rectColors)
        return sepLayer
    }

    override func sliderPanned(_ sender: UIPanGestureRecognizer) {
        switch self.menuStyle {
        case .compact:
            super.sliderPanned(sender)
        default:
            break
        }
    }
    
    func setupMenuGestures() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(FlexMenu.menuTouched))
        self.addGestureRecognizer(touchGesture)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let menuFrames = self.getActiveMenuFrames(), let touch = touches.first {
            let p = touch.location(in: self)
            var index = 0
            for f in menuFrames {
                if f.contains(p) {
                    self.touchedMenuItem = index
                    self.layoutComponents()
                    let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        self.touchedMenuItem = nil
                        self.layoutComponents()
                    }
                    return
                }
                index += 1
            }
        }
    }
    
    @objc func menuTouched(_ sender: UITapGestureRecognizer) {
        if let menuFrames = self.getActiveMenuFrames() {
            let p = sender.location(in: self)
            var index = 0
            for f in menuFrames {
                if f.contains(p) {
                    switch sender.state {
                    case .ended:
                        self.onSeparatorTouchEnded(index+1)
                    default:
                        break
                    }
                    return
                }
                index += 1
            }
        }
    }
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    open func onThumbTouchEnded(_ index: Int) {
        if let menuItem = self.getMenuItemForIndex(index), menuItem.enabled {
            self.setSelectedItem(index)
            self.notifyValueChanged()
        }
    }
    
    // MARK: - GenericStyleSliderSeparatorTouchDelegate
    
    open func onSeparatorTouchEnded(_ index: Int) {
        if index > 0 {
            if let menuItem = self.getMenuItemForIndex(index-1), menuItem.enabled {
                self.setSelectedItem(index-1)
                self.notifyValueChanged()
            }
        }
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    open func iconOfThumb(_ index: Int) -> UIImage? {
        if let mi = self.getMenuItemForIndex(index) {
            if mi.hidden {
                return nil
            }
            return mi.activeThumbIcon()
        }
        return nil
    }
    
    open func iconOfSeparator(_ index: Int) -> UIImage? {
        return nil
    }
    
    open func textOfThumb(_ index: Int) -> String? {
        if let mi = self.getMenuItemForIndex(index) {
            if mi.hidden {
                return nil
            }
            return mi.titleShortcut
        }
        return nil
    }
    
    open func attributedTextOfThumb(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return nil
    }
    
    open func textOfSeparatorLabel(_ index: Int) -> String? {
        if index > 0 {
            if let mi = self.getMenuItemForIndex(index-1) {
                if mi.hidden {
                    return nil
                }
                return mi.title
            }
        }
        return nil
    }
    
    open func attributedTextOfSeparatorLabel(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return nil
    }
    
    open func colorOfThumb(_ index: Int) -> UIColor? {
        if let mi = self.getMenuItemForIndex(index) {
            if mi.hidden {
                return .clear
            }
            return self.selectedItem() == index ? mi.selectedThumbColor : mi.thumbColor
        }
        return nil
    }
    
    open func colorOfSeparatorLabel(_ index: Int) -> UIColor? {
        if index > 0 {
            if let mi = self.getMenuItemForIndex(index-1) {
                if mi.hidden {
                    return .clear
                }
                let color = self.selectedItem() == index - 1 ? mi.selectedColor : mi.color
                if let si = self.touchedMenuItem, si == index - 1 {
                    return color.lighter()
                }
                return color
            }
        }
        return nil
    }
    
    open func adaptOpacityForSeparatorLabel(_ index: Int) -> Bool {
        return true
    }

    open func behaviourOfThumb(_ index: Int) -> StyledSliderThumbBehaviour? {
        return index == 0 ? .fixateToLower : .snapToLowerAndHigher
    }
    
    open func sizeInfoOfThumb(_ index: Int) -> SliderThumbSizeInfo? {
        return nil
    }
    
    open func sizeInfoOfSeparator(_ index: Int) -> SliderSeparatorSizeInfo? {
        return nil
    }

    open func triggerEventValues(_ index: Int) -> (Double?, Double?) {
        return (nil, nil)
    }
    
    open func thumbValueLimits(_ index: Int) -> (Double?, Double?) {
        return (nil, nil)
    }
    
    // MARK: - Menu Items
    
    open func getMenuItemForIndex(_ index: Int) -> FlexMenuItem? {
        if let menuItems = self.menuItems {
            if index < menuItems.count {
                return menuItems[index]
            }
        }
        return self.menuDataSource?.menuItemForIndex(self, index: index)
    }
    
    open func getMenuItemsCount() -> Int {
        if let menuItems = self.menuItems {
            return menuItems.count
        }
        if let ds = self.menuDataSource {
            return ds.numberOfMenuItems(self)
        }
        return 0
    }
}
