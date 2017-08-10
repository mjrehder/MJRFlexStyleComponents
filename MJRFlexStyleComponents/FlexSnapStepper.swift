//
//  FlexSnapStepper.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 27.06.17.
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

open class FlexSnapStepper: FlexMutableSlider {

    /// The value of the stepper
    open var value: Double = 0.0
    /// The stepper min value. This is the value updated by the relative motion of the slider and pressing the minus and plus areas.
    open var minStepperValue: Double = 0
    /// The stepper max value. This is the value updated by the relative motion of the slider and pressing the minus and plus areas.
    open var maxStepperValue: Double = 1
    /// Use the value steps in order to control the fractional amount of change when pressing plus and minus. For example, if you specify 10, then it will take 10 taps on the plus button to step from minStepperValue to maxStepperValue.
    open var valueSteps: Double = 10
    /// Use the value slider factor in order to control the 'speed' of the value updates.
    open var valueSlideFactor: Double = 10.0
    
    open var stepValueChangeHandler: ((Double)->Void)?
    
    @IBInspectable open dynamic var thumbTintColor: UIColor? {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    @IBInspectable open dynamic var separatorTintColor: UIColor? {
        didSet {
            self.applyStyle(self.getStyle())
        }
    }
    
    open var separatorFactory: ((Int)->MutableSliderSeparatorItem) = {
        index in
        let sep = MutableSliderSeparatorItem()
        sep.text = index == 0 ? "-" : "+"
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
        return thumb
        }
        {
        didSet {
            self.createItems()
        }
    }
    
    override func setupSlider() {
        super.setupSlider()

        self.minimumValue = -0.5
        self.maximumValue = 0.5
        self.thumbText = nil
        self.numberFormatString = "%0.1lf"
        self.thumbRatio = 0.5
        
        self.valueChangedBlockWhileSliding = {
            newValue, index in
            let range = (self.maxStepperValue - self.minStepperValue) / self.valueSlideFactor
            let valChange = range * newValue * abs(newValue)
            self.value += valChange
            self.clampStepValue()
            self.stepValueChangeHandler?(self.value)
        }
        
        self.separatorTouchHandler = {
            index in
            let range = (self.maxStepperValue - self.minStepperValue) / self.valueSteps
            self.value += index == 0 ? -range : range
            self.clampStepValue()
            self.stepValueChangeHandler?(self.value)
        }
        
        self.createItems()
    }
    
    func createItems() {
        self.removeAll()
        
        let thumb = self.thumbFactory(0)
        thumb.behaviour = .snapToValue(v: 0.0)
        thumb.initialValue = 0

        let sep0 = self.separatorFactory(0)
        sep0.useOpacityForSizing = false
        self.addSeparator(sep0)
        let sep = self.separatorFactory(1)
        sep.useOpacityForSizing = false
        self.addThumb(thumb, separator: sep)
        self.recreateThumbs()
    }
    
    func clampStepValue() {
        if self.value < self.minStepperValue {
            self.value = self.minStepperValue
        }
        if self.value > self.maxStepperValue {
            self.value = self.maxStepperValue
        }
    }
    
    open override func valueAsText(_ value: Double) -> String {
        if let formatStr = self.numberFormatString {
            return String(format: formatStr, self.value)
        }
        return self.value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(self.value))" : "\(self.value)"
    }
    
    open override func colorOfThumb(_ index: Int) -> UIColor? {
        return self.getThumb(at: index)?.color ?? self.thumbTintColor ?? .lightGray
    }
    
    open override func colorOfSeparatorLabel(_ index: Int) -> UIColor? {
        return self.getSeparator(at: index)?.color ?? self.separatorTintColor ?? .white
    }
}
