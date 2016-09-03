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

public protocol FlexSwitchDelegate {
    func switchStateChanged(flexSwitch: FlexSwitch, on: Bool)
}

// The FlexSwitch is only supporting horizontal layout
@IBDesignable public class FlexSwitch: GenericStyleSlider, GenericStyleSliderDelegate, GenericStyleSliderTouchDelegate {

    public var switchDelegate: FlexSwitchDelegate?
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRectMake(0,0,90,30)
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
        self.style = .Tube
        self.thumbStyle = .Tube
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.borderColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.thumbSnappingBehaviour = .SnapToLowerAndHigher
        self.values = [0]
        self.sliderDelegate = self
        self.thumbTouchDelegate = self

        self.addTarget(self, action: #selector(FlexSwitch.switchChanged), forControlEvents: .ValueChanged)
    }

    override func initComponent() {
        super.initComponent()
        if bounds.size.width > 0.0 {
            self.thumbRatio = (bounds.size.height - 1.0) / bounds.size.width
        }
    }
    
    @IBInspectable public var onTintColor: UIColor? = UISwitch.appearance().onTintColor {
        didSet {
            self.applySeparatorStyle(self.separatorStyle)
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor? = UISwitch.appearance().thumbTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    public var on: Bool {
        get {
            return self.values[0] > 0.5
        }
    }
    
    public func setOn(isOn: Bool) {
        let targetValue = isOn ? 1.0 : 0.0
        self.values = [targetValue]
    }
    
    func switchChanged() {
        self.switchDelegate?.switchStateChanged(self, on: self.on)
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    public func iconOfThumb(index: Int) -> UIImage? {
        return nil
    }
    
    public func textOfThumb(index: Int) -> String? {
        return nil
    }
    
    public func textOfSeparatorLabel(index: Int) -> String? {
        return nil
    }
    
    public func colorOfThumb(index: Int) -> UIColor? {
        return self.thumbTintColor
    }
    
    public func colorOfSeparatorLabel(index: Int) -> UIColor? {
        return index == 0 ? self.onTintColor : self.backgroundColor
    }
    
    public func behaviourOfThumb(index: Int) -> StyledSliderThumbBehaviour? {
        return nil
    }
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    public func onThumbTouchEnded(index: Int) {
        self.setOn(!self.on)
        self.switchChanged()
    }
}
