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

    open var upperIcon: UIImage? = nil {
        didSet {
            self.createItems()
        }
    }

    open var upperMaxIconSize: CGSize = CGSize(width: 42, height: 42) {
        didSet {
            self.createItems()
        }
    }
    
    open var upperIconSizingType: SliderIconSizingType = .relativeToSlider(minSize: CGSize(width: 16, height: 16)) {
        didSet {
            self.createItems()
        }
    }
    
    open var upperText: String? = "B" {
        didSet {
            self.createItems()
        }
    }
    
    open var upperTextMaxFontSize: CGFloat = 48 {
        didSet {
            self.createItems()
        }
    }
    
    open var upperTextSizingType: SliderFontSizingType = .relativeToSlider(minSize: 5) {
        didSet {
            self.createItems()
        }
    }

    open var primaryIcon: UIImage? = nil {
        didSet {
            self.createItems()
        }
    }
    
    open var primaryMaxIconSize: CGSize = CGSize(width: 48, height: 48) {
        didSet {
            self.createItems()
        }
    }
    
    open var primaryIconSizingType: SliderIconSizingType = .relativeToSlider(minSize: CGSize(width: 16, height: 16)) {
        didSet {
            self.createItems()
        }
    }
    
    open var primaryText: String? = "A" {
        didSet {
            self.createItems()
        }
    }

    open var primaryTextSizingType: SliderFontSizingType = .relativeToSlider(minSize: 16) {
        didSet {
            self.createItems()
        }
    }

    open var primaryTextMaxFontSize: CGFloat = 32 {
        didSet {
            self.createItems()
        }
    }
    
    open var primarySizingType: ThumbSizingType = .relativeToSlider(min: 10, max: 32) {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerIcon: UIImage? = nil {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerMaxIconSize: CGSize = CGSize(width: 42, height: 42) {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerIconSizingType: SliderIconSizingType = .relativeToSlider(minSize: CGSize(width: 16, height: 16)) {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerText: String? = nil {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerTextMaxFontSize: CGFloat = 48 {
        didSet {
            self.createItems()
        }
    }
    
    open var lowerTextSizingType: SliderFontSizingType = .relativeToSlider(minSize: 5) {
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
    
    func createItems() {
        self.removeAll()
        
        let hasLowerFunction = self.lowerIcon != nil || self.lowerText != nil
        
        let primarySizeInfo = SliderThumbSizeInfo()
        primarySizeInfo.sizingType = self.primarySizingType
        primarySizeInfo.maxFontSize = self.primaryTextMaxFontSize
        primarySizeInfo.maxIconSize = self.primaryMaxIconSize
        primarySizeInfo.iconSizingType = self.primaryIconSizingType
        primarySizeInfo.textSizingType = self.primaryTextSizingType

        let thumb = self.thumbFactory(0)
        thumb.behaviour = .snapToValue(v: 0.5)
        thumb.initialValue = 0.5
        if !hasLowerFunction {
            thumb.lowerLimit = 0.5
        }
        thumb.text = self.primaryText
        thumb.icon = self.primaryIcon
        thumb.sizeInfo = primarySizeInfo
        
        let upperSepSizeInfo = SliderSeparatorSizeInfo()
        upperSepSizeInfo.maxFontSize = self.upperTextMaxFontSize
        upperSepSizeInfo.maxIconSize = self.upperMaxIconSize
        upperSepSizeInfo.iconSizingType = self.upperIconSizingType
        upperSepSizeInfo.textSizingType = self.upperTextSizingType

        let sep0 = self.separatorFactory(0)
        sep0.useOpacityForSizing = false
        sep0.text = self.upperText
        sep0.icon = self.upperIcon
        sep0.sizeInfo = upperSepSizeInfo
        self.addSeparator(sep0)

        let sep = self.separatorFactory(1)
        sep.useOpacityForSizing = false
        if hasLowerFunction {
            let lowerSepSizeInfo = SliderSeparatorSizeInfo()
            lowerSepSizeInfo.maxFontSize = self.lowerTextMaxFontSize
            lowerSepSizeInfo.maxIconSize = self.lowerMaxIconSize
            lowerSepSizeInfo.iconSizingType = self.lowerIconSizingType
            lowerSepSizeInfo.textSizingType = self.lowerTextSizingType

            sep.text = self.lowerText
            sep.icon = self.lowerIcon
            sep.sizeInfo = lowerSepSizeInfo
        }
        self.addThumb(thumb, separator: sep)
        self.recreateThumbs()
    }

}
