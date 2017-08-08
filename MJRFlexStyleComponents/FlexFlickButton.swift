//
//  FlexFlickButton.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 25.07.2017.
/*
 * Copyright 2017-present Martin Jacob Rehder.
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

public enum FlexFlickActionActivationType {
    case upper
    case primary
    case lower
}

open class FlexFlickButton: FlexMutableSlider {
    open var upperActionItem = FlexFlickActionItem() {
        didSet {
            self.createItems()
        }
    }
    
    open var primaryActionItem = FlexFlickActionItem() {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerActionItem = FlexFlickActionItem() {
        didSet {
            self.createItems()
        }
    }
    
    open var sizingType: ThumbSizingType = .relativeToSlider(min: 10, max: 32) {
        didSet {
            self.createItems()
        }
    }
    
    open var separatorFactory: ((Int)->MutableSliderSeparatorItem) = {
        index in
        let sep = MutableSliderSeparatorItem()
        sep.color = .clear
        sep.useOpacityForSizing = false
        return sep
        }
        {
        didSet {
            self.createItems()
        }
    }
    
    open var thumbFactory: ((Int)->MutableSliderThumbItem) = {
        index in
        let thumb = MutableSliderThumbItem()
        thumb.color = .clear
        thumb.triggerEventAbove = 0.9
        thumb.triggerEventBelow = 0.1
        return thumb
        }
        {
        didSet {
            self.createItems()
        }
    }
    
    open var actionActivationHandler: ((FlexFlickActionActivationType) -> Void)?
    
    open override func thumbRelativeSizeFunction(_ offset: Double) -> CGFloat {
        return CGFloat(1 - abs(cos(offset)))
    }
    
    override func setupSlider() {
        super.setupSlider()
        
        self.upperActionItem.shouldUpdateActionHandler = {
            self.createItems()
        }
        self.primaryActionItem.shouldUpdateActionHandler = {
            self.createItems()
        }
        self.lowerActionItem.shouldUpdateActionHandler = {
            self.createItems()
        }
        
        self.separatorSwipeEnabled = true
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbRatio = 0.5
        self.continuous = false
        
        self.valueChangedBlockWhileSliding = {
            _, _ in
        }
        
        self.separatorTouchHandler = {
            _ in
            self.actionActivationHandler?(.primary)
        }
        
        self.thumbTouchHandler = {
            _ in
            self.actionActivationHandler?(.primary)
        }
        
        self.eventTriggerHandler = {
            (index, value) in
            if let thumb = self.getThumb(at: index), let lowerThreshold = thumb.triggerEventBelow, let upperThreshold = thumb.triggerEventAbove {
                if value <= lowerThreshold {
                    self.actionActivationHandler?(.lower)
                }
                else if value >= upperThreshold {
                    self.actionActivationHandler?(.upper)
                }
            }
        }
        
        self.createItems()
    }
    
    open func createItems() {
        self.removeAll()
        
        let hasLowerFunction = self.lowerActionItem.icon != nil || self.lowerActionItem.text != nil || self.attributedTextOfSeparatorLabel(at: 1, rect: self.bounds, relativeCenter: 1) != nil
        
        let primarySizeInfo = SliderThumbSizeInfo()
        primarySizeInfo.sizingType = self.sizingType
        primarySizeInfo.maxFontSize = self.primaryActionItem.textMaxFontSize
        primarySizeInfo.maxIconSize = self.primaryActionItem.maxIconSize
        primarySizeInfo.iconSizingType = self.primaryActionItem.iconSizingType
        primarySizeInfo.textSizingType = self.primaryActionItem.textSizingType
        
        let thumb = self.thumbFactory(0)
        thumb.behaviour = .snapToValue(v: 0.5)
        thumb.initialValue = 0.5
        if !hasLowerFunction {
            thumb.lowerLimit = 0.5
        }
        thumb.text = self.primaryActionItem.text
        thumb.icon = self.primaryActionItem.icon
        thumb.sizeInfo = primarySizeInfo
        
        let upperSepSizeInfo = SliderSeparatorSizeInfo()
        upperSepSizeInfo.maxFontSize = self.upperActionItem.textMaxFontSize
        upperSepSizeInfo.maxIconSize = self.upperActionItem.maxIconSize
        upperSepSizeInfo.iconSizingType = self.upperActionItem.iconSizingType
        upperSepSizeInfo.textSizingType = self.upperActionItem.textSizingType
        
        let sep0 = self.separatorFactory(0)
        sep0.useOpacityForSizing = false
        sep0.text = self.upperActionItem.text
        sep0.icon = self.upperActionItem.icon
        sep0.sizeInfo = upperSepSizeInfo
        self.addSeparator(sep0)
        
        let sep = self.separatorFactory(1)
        sep.useOpacityForSizing = false
        if hasLowerFunction {
            let lowerSepSizeInfo = SliderSeparatorSizeInfo()
            lowerSepSizeInfo.maxFontSize = self.lowerActionItem.textMaxFontSize
            lowerSepSizeInfo.maxIconSize = self.lowerActionItem.maxIconSize
            lowerSepSizeInfo.iconSizingType = self.lowerActionItem.iconSizingType
            lowerSepSizeInfo.textSizingType = self.lowerActionItem.textSizingType
            
            sep.text = self.lowerActionItem.text
            sep.icon = self.lowerActionItem.icon
            sep.sizeInfo = lowerSepSizeInfo
        }
        self.addThumb(thumb, separator: sep)
        self.recreateThumbs()
    }
    
}
