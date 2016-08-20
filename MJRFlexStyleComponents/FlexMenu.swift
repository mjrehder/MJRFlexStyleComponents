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

public enum FlexMenuStyle {
    case Compact
    case EquallySpaces(thumbPos: FlexMenuThumbPosition)
    case DynamicallySpaces(thumbPos: FlexMenuThumbPosition)
}

@IBDesignable
public class FlexMenu: GenericStyleSlider, GenericStyleSliderTouchDelegate, GenericStyleSliderDelegate {

    public var menuDataSource: FlexMenuDataSource? {
        didSet {
            self.reloadMenu()
        }
    }

    /*
     Set the menu style. The default is the compact style, which uses sliding thumbs to reduce the size of the menu.
     */
    public var menuStyle: FlexMenuStyle = .Compact {
        didSet {
            self.reloadMenu()
        }
    }
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.initMenu()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initMenu()
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
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    public func onThumbTouchBegan(index: Int) {
    }
    
    public func onThumbTouchEnded(index: Int) {
        self.setSelectedItem(index)
        self.notifyValueChanged()
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
