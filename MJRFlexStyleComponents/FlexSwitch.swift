//
//  FlexSwitch.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 23.07.16.
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
import DynamicColor

public protocol FlexSwitchDelegate {
    func switchStateChanged(_ flexSwitch: FlexSwitch, on: Bool)
}

// The FlexSwitch is only supporting horizontal layout
@IBDesignable open class FlexSwitch: GenericStyleSlider, GenericStyleSliderDelegate, GenericStyleSliderTouchDelegate {

    open var switchDelegate: FlexSwitchDelegate?
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if frame.isNull || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRect(x: 0,y: 0,width: 90,height: 30)
        }
        super.init(frame: targetFrame)
        self.setupSwitch()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSwitch()
    }

    func setupSwitch() {
        self.continuous = false
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbSnappingBehaviour = .snapToLowerAndHigher
        self.values = [0]
        self.sliderDelegate = self
        self.thumbTouchDelegate = self

        self.addTarget(self, action: #selector(FlexSwitch.switchChanged), for: .valueChanged)
    }

    @IBInspectable open dynamic var onTintColor: UIColor? {
        didSet {
            self.applySeparatorStyle(self.separatorStyle)
        }
    }
    
    @IBInspectable open dynamic var thumbTintColor: UIColor? {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    open var on: Bool {
        get {
            return self.values[0] > 0.5
        }
    }
    
    open func setOn(_ isOn: Bool) {
        let targetValue = isOn ? 1.0 : 0.0
        self.values = [targetValue]
    }
    
    @objc func switchChanged() {
        self.switchDelegate?.switchStateChanged(self, on: self.on)
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    open func iconOfThumb(_ index: Int) -> UIImage? {
        return nil
    }
    
    open func iconOfSeparator(_ index: Int) -> UIImage? {
        return nil
    }
    
    open func textOfThumb(_ index: Int) -> String? {
        return nil
    }
    
    open func attributedTextOfThumb(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return nil
    }
    
    open func textOfSeparatorLabel(_ index: Int) -> String? {
        return nil
    }
    
    open func attributedTextOfSeparatorLabel(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return nil
    }
    
    open func colorOfThumb(_ index: Int) -> UIColor? {
        return self.thumbTintColor ?? .lightGray
    }
    
    open func colorOfSeparatorLabel(_ index: Int) -> UIColor? {
        return index == 0 ? self.onTintColor ?? UIColor.red.darkened(amount: 0.2) : self.styleColor
    }
    
    open func adaptOpacityForSeparatorLabel(_ index: Int) -> Bool {
        return true
    }
 
    open func behaviourOfThumb(_ index: Int) -> StyledSliderThumbBehaviour? {
        return nil
    }
    
    open func sizeInfoOfThumb(_ index: Int) -> SliderThumbSizeInfo? {
        return nil
    }
    
    open func triggerEventValues(_ index: Int) -> (Double?, Double?) {
        return (nil, nil)
    }
    
    open func thumbValueLimits(_ index: Int) -> (Double?, Double?) {
        return (nil, nil)
    }

    open func sizeInfoOfSeparator(_ index: Int) -> SliderSeparatorSizeInfo? {
        return nil
    }

    // MARK: - GenericStyleSliderTouchDelegate
    
    open func onThumbTouchEnded(_ index: Int) {
        self.setOn(!self.on)
        self.switchChanged()
    }
}
