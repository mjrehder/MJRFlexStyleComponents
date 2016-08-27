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
import SnappingStepper

public protocol FlexMenuDataSource {
    func numberOfMenuItems(menu: FlexMenu) -> Int
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem
    func menuItemSelected(menu: FlexMenu, index: Int)
}

public enum FlexMenuThumbPosition {
    case Left
    case Top
    case Right
    case Bottom
}

public enum FlexMenuItemGravity {
    case Normal
    case Left
    case Right
}

public enum FlexMenuStyle {
    case Compact
    case EquallySpaces(thumbPos: FlexMenuThumbPosition)
    case DynamicallySpaces(thumbPos: FlexMenuThumbPosition)
}

@IBDesignable
public class FlexMenu: GenericStyleSlider, GenericStyleSliderTouchDelegate, GenericStyleSliderDelegate, GenericStyleSliderSeparatorTouchDelegate {

    public var menuDataSource: FlexMenuDataSource? {
        didSet {
            self.reloadMenu()
        }
    }

    /*
     Set the menu style. The default is the compact style, which uses sliding thumbs to reduce the size of the menu.
     */
    @IBInspectable public var menuStyle: FlexMenuStyle = .Compact {
        didSet {
            self.reloadMenu()
        }
    }
    
    /*
     Set the menu item style. The default is the Box style. This is only applied when not using the Compact menu style
     */
    @IBInspectable public var menuItemStyle: ShapeStyle = .Box {
        didSet {
            self.layoutComponents()
        }
    }
    
    /*
     Set the menu inter item spacing. The default value is 0. This is only applied when not using the Compact menu style
     */
    @IBInspectable public var menuInterItemSpacing: CGFloat = 0 {
        didSet {
            self.layoutComponents()
        }
    }
    
    /*
     Set the menu item gravity. The default value is 'normal'. This is applied when using vertical direction to rotate the labels and
     should be set to other than 'normal' when the menu is in vertical orientation.
     */
    @IBInspectable public var menuItemGravity: FlexMenuItemGravity = .Normal {
        didSet {
            self.layoutComponents()
        }
    }
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRectMake(0,0,90,30)
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

    public func reloadMenu() {
        self.setupMenu()
    }
    
    func initMenu() {
        self.backgroundColor = .clearColor()
        self.continuous = false
        self.style = .Rounded
        self.thumbStyle = .Rounded
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbSnappingBehaviour = .SnapToLowerAndHigher
        
        self.addTarget(self, action: #selector(FlexMenu.notifyValueChanged), forControlEvents: .ValueChanged)
    }
    
    func notifyValueChanged() {
        self.menuDataSource?.menuItemSelected(self, index: self.selectedItem())
    }
    
    func setupMenu() {
        self.thumbTouchDelegate = self
        self.separatorTouchDelegate = self
        self.sliderDelegate = self
        var vals: [Double] = []
        if let ds = self.menuDataSource {
            for _ in 0..<ds.numberOfMenuItems(self) {
                vals.append(0)
            }
        }
        self.values = vals
    }
    
    // MARK: - Public functions
    
    public func selectedItem() -> Int {
        for idx in 1..<self.values.count {
            if self.values[idx] >= 0.5 {
                return idx-1
            }
        }
        return self.values.count-1
    }
    
    public func setSelectedItem(index: Int) {
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
        case .Compact:
            super.layoutComponents()
        case .EquallySpaces(let thumbPos):
            let miFrames = self.getEquallySpacedMenuItemFrames()
            self.layoutNonCompactMenuItems(thumbPos, menuItemFrames: miFrames)
            self.applyStylesAndText()
        case .DynamicallySpaces(let thumbPos):
            let miFrames = self.getDynamicallySpacedMenuItemFrames()
            self.layoutNonCompactMenuItems(thumbPos, menuItemFrames: miFrames)
            self.applyStylesAndText()
        }
    }
    
    func applyStylesAndText() {
        applyThumbStyle(thumbStyle)
        applySeparatorStyle(separatorStyle)
        applyStyle(style)
        
        self.assignThumbTexts()
        self.assignSeparatorTexts()
    }
    
    func getEquallySpacedMenuItemFrames() -> [CGRect] {
        var rects: [CGRect] = []
        if let ds = self.menuDataSource {
            let numSep = ds.numberOfMenuItems(self)
            let maxExt = self.thumbList.getPrincipalSizeValue(self.bounds.size)
            let itemExt = (maxExt - (self.menuInterItemSpacing * (CGFloat(numSep-1)))) / CGFloat(numSep)
            let itemOffset = itemExt + self.menuInterItemSpacing
            for i in 0..<numSep {
                let rect: CGRect
                if self.direction == .Horizontal {
                    rect = CGRectMake(CGFloat(i) * itemOffset, 0, itemExt, self.bounds.height)
                }
                else {
                    rect = CGRectMake(0, CGFloat(i) * itemOffset, self.bounds.width, itemExt)
                }
                rects.append(rect)
            }
        }
        return rects
    }
    
    private func getTotalTextWidth() -> CGFloat {
        var totalWidth: CGFloat = 0
        if let ds = self.menuDataSource {
            let numSep = ds.numberOfMenuItems(self)
            for i in 0..<numSep {
                let sep = self.separatorForThumb(i)
                if let tSize = self.sizeOfTextLabel(sep) {
                    totalWidth += self.thumbList.getPrincipalSizeValue(tSize)
                }
            }
        }
        return totalWidth
    }
    
    func getDynamicallySpacedMenuItemFrames() -> [CGRect] {
        var rects: [CGRect] = []
        if let ds = self.menuDataSource {
            let numSep = ds.numberOfMenuItems(self)
            let maxExt = self.thumbList.getPrincipalSizeValue(self.bounds.size)
            let ttWidth = self.getTotalTextWidth()
            let textScaling = ttWidth > 0 ? (maxExt - (self.menuInterItemSpacing * (CGFloat(numSep-1)))) / ttWidth : 1.0
            
            var lastOffset: CGFloat = 0
            for i in 0..<numSep {
                let sep = self.separatorForThumb(i)

                let itemExt: CGFloat
                if let tSize = self.sizeOfTextLabel(sep) {
                    itemExt = self.thumbList.getPrincipalSizeValue(tSize) * textScaling
                }
                else {
                    itemExt = self.thumbList.getPrincipalSizeValue(self.getThumbSize())
                }
                
                let rect: CGRect
                if self.direction == .Horizontal {
                    rect = CGRectMake(lastOffset, 0, itemExt, self.bounds.height)
                }
                else {
                    rect = CGRectMake(0, lastOffset, self.bounds.width, itemExt)
                }
                rects.append(rect)
                
                lastOffset += itemExt + self.menuInterItemSpacing
            }
        }
        return rects
    }

    private func separatorLabelRotation() -> CGFloat {
        switch self.menuItemGravity {
        case .Normal:
            return 0
        case .Left:
            return CGFloat(M_PI_2)
        case .Right:
            return -CGFloat(M_PI_2)
            
        }
    }
    
    func layoutNonCompactMenuItems(thumbPos: FlexMenuThumbPosition, menuItemFrames: [CGRect]) {
        if let ds = self.menuDataSource {
            for idx in 0..<ds.numberOfMenuItems(self) {
                let sep = self.separatorForThumb(idx)
                let thumb = self.thumbList.thumbs[idx]
                let miFrame = menuItemFrames[idx]
                
                let ts = self.getThumbSize()
                let tp = self.thumbPosInsideSpacedRect(thumb, targetRect: miFrame, thumbPos: thumbPos)
                let tr = CGRectMake(tp.x, tp.y, ts.width, ts.height)
                thumb.frame = tr
                
                let sepRect = self.separatorRectInsideSpacedRect(thumb, targetRect: miFrame, thumbPos: thumbPos)
                sep.frame = sepRect
                sep.rotationInRadians = self.separatorLabelRotation()
            }
        }
    }
    
    func thumbPosInsideSpacedRect(thumb: StyledSliderThumb, targetRect: CGRect, thumbPos: FlexMenuThumbPosition) -> CGPoint {
        var tPos = CGPointZero
        let ts = self.getThumbSize()
        let sic = self.thumbList.getPrincipalSizeValue(targetRect.size)
        let sicNP = self.thumbList.getNonPrincipalSizeValue(targetRect.size)
        let tSic = self.thumbList.getPrincipalSizeValue(ts)
        let tSicNP = self.thumbList.getNonPrincipalSizeValue(ts)
        // Center the icon, if there is an empty text
        if let sepText = self.sliderDelegate?.textOfSeparatorLabel(thumb.index+1) where sepText == "" {
            tPos = CGPointMake((sic - tSic) * 0.5, (sicNP - tSicNP) * 0.5)
        }
        else {
            switch thumbPos {
            case .Left:
                tPos = CGPointMake(0, (sicNP - tSicNP) * 0.5)
            case .Right:
                tPos = CGPointMake(sic - tSic, (sicNP - tSicNP) * 0.5)
            case .Top:
                tPos = CGPointMake((sic - tSic) * 0.5, 0.0)
            case .Bottom:
                tPos = CGPointMake((sic - tSic) * 0.5, sicNP - tSicNP)
            }
        }
        if self.direction == .Vertical && self.menuItemGravity == .Right {
            tPos = CGPointMake(tPos.y, (sic - tSic) - tPos.x)
        }
        else if self.direction == .Vertical && self.menuItemGravity == .Left {
            tPos = CGPointMake((sicNP - tSicNP) - tPos.y, tPos.x)
        }
        tPos = CGPointMake(tPos.x + targetRect.origin.x, tPos.y + targetRect.origin.y)
        return tPos
    }
    
    func separatorRectInsideSpacedRect(thumb: StyledSliderThumb, targetRect: CGRect, thumbPos: FlexMenuThumbPosition) -> CGRect {
        var tRect = targetRect
        let ts = self.getThumbSize()
        let tSic = self.thumbList.getPrincipalSizeValue(ts)
        let tSicNP = self.thumbList.getNonPrincipalSizeValue(ts)
        if (thumb.text == nil || thumb.text == "" ) && thumb.backgroundIcon == nil {
            // If there is no thumb, then use the entire targetRect for the separator
            return targetRect
        }
        else {
            if self.direction == .Vertical && self.menuItemGravity == .Right {
                switch thumbPos {
                case .Left:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                case .Right:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .Top:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                case .Bottom:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                }
            }
            else if self.direction == .Vertical && self.menuItemGravity == .Left {
                switch thumbPos {
                case .Left:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .Right:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                case .Top:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                case .Bottom:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                }
            }
            else {
                switch thumbPos {
                case .Left:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * 0.5, dy: 0)
                case .Right:
                    tRect = tRect.insetBy(dx: tSic * 0.5, dy: 0).offsetBy(dx: tSic * -0.5, dy: 0)
                case .Top:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * 0.5)
                case .Bottom:
                    tRect = tRect.insetBy(dx: 0, dy: tSicNP * 0.5).offsetBy(dx: 0, dy: tSicNP * -0.5)
                }
            }
        }
        return tRect
    }
    
    override func createSeparatorLayer(layerRect: CGRect) -> CAShapeLayer {
        let menuItemFrames: [CGRect]

        switch self.menuStyle {
        case .Compact:
            return super.createSeparatorLayer(layerRect)
        case .EquallySpaces(_):
            menuItemFrames = self.getEquallySpacedMenuItemFrames()
        case .DynamicallySpaces(_):
            menuItemFrames = self.getDynamicallySpacedMenuItemFrames()
        }
        // Add layer with separator background colors
        var rectColors: [(CGRect, UIColor)] = []
        if let ds = self.menuDataSource {
            for idx in 0..<ds.numberOfMenuItems(self) {
                let miFrame = menuItemFrames[idx]
                let bgColor = self.colorOfSeparatorLabel(idx+1) ?? separatorBackgroundColor
                rectColors.append((miFrame, bgColor ?? .clearColor()))
            }
        }
        
        let sepLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.menuItemStyle, colorRects: rectColors)
        return sepLayer
    }

    override func sliderPanned(sender: UIPanGestureRecognizer) {
        switch self.menuStyle {
        case .Compact:
            super.sliderPanned(sender)
        default:
            break
        }
    }
    
    func setupMenuGestures() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(FlexMenu.menuTouched))
        self.addGestureRecognizer(touchGesture)
    }
    
    func menuTouched(sender: UITapGestureRecognizer) {
        let menuFrames: [CGRect]
        switch self.menuStyle {
        case .Compact:
            return
        case .EquallySpaces(_):
            menuFrames = self.getEquallySpacedMenuItemFrames()
        case .DynamicallySpaces(_):
            menuFrames = self.getDynamicallySpacedMenuItemFrames()
        }
        let p = sender.locationInView(self)
        var index = 0
        for f in menuFrames {
            if CGRectContainsPoint(f, p) {
                switch sender.state {
                case .Ended:
                    self.onSeparatorTouchEnded(index)
                default:
                    break
                }
                return
            }
            index += 1
        }
    }
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    public func onThumbTouchEnded(index: Int) {
        self.setSelectedItem(index)
        self.notifyValueChanged()
    }
    
    // MARK: - GenericStyleSliderSeparatorTouchDelegate
    
    public func onSeparatorTouchEnded(index: Int) {
        if index > 0 {
            self.setSelectedItem(index-1)
            self.notifyValueChanged()
        }
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    public func iconOfThumb(index: Int) -> UIImage? {
        return self.menuDataSource?.menuItemForIndex(self, index: index).thumbIcon
    }
    
    public func textOfThumb(index: Int) -> String? {
        return self.menuDataSource?.menuItemForIndex(self, index: index).titleShortcut
    }
    
    public func textOfSeparatorLabel(index: Int) -> String? {
        if index > 0 {
            return self.menuDataSource?.menuItemForIndex(self, index: index-1).title
        }
        return nil
    }
    
    public func colorOfThumb(index: Int) -> UIColor? {
        return self.menuDataSource?.menuItemForIndex(self, index: index).thumbColor
    }
    
    public func colorOfSeparatorLabel(index: Int) -> UIColor? {
        if index > 0 {
            return self.menuDataSource?.menuItemForIndex(self, index: index-1).color
        }
        return nil
    }
    
    public func behaviourOfThumb(index: Int) -> StyledSliderThumbBehaviour? {
        return index == 0 ? .FixateToLower : .SnapToLowerAndHigher
    }

}
