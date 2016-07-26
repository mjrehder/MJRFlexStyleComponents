//
//  FlexMenu.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

public protocol FlexMenuDataSource {
    func numberOfMenuItems(menu: FlexMenu) -> Int
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem
    func menuItemSelected(menu: FlexMenu, index: Int)
}

@IBDesignable
public class FlexMenu: GenericStyleSlider, GenericStyleSliderTouchDelegate, GenericStyleSliderDelegate {

    public var menuDataSource: FlexMenuDataSource? {
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
    
    public func selectedItem() -> Int {
        for idx in 1..<self.values.count {
            if self.values[idx] >= 0.5 {
                return idx-1
            }
        }
        return self.values.count-1
    }
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    public func onThumbTouchBegan(index: Int) {
    }
    
    public func onThumbTouchEnded(index: Int) {
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
        self.notifyValueChanged()
    }
    
    // MARK: - GenericStyleSliderDelegate
    
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
}
