//
//  FlexDoubleSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 26.07.16.
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

open class FlexDoubleSlider: FlexSlider {

    public override init(frame: CGRect) {
        var targetFrame = frame
        if frame.isNull || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRect(x: 0,y: 0,width: 90,height: 30)
        }
        super.init(frame: targetFrame)
        self.setupSlider()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSlider()
    }

    open var value2: Double {
        get {
            if self.values.count < 2 {
                self.values = [0,0]
            }
            return self.values[1]
        }
        set(newValue) {
            if self.values.count < 2 {
                self.values = [0,0]
            }
            self.values[1] = newValue
        }
    }

    @IBInspectable open dynamic var middleTrackTintColor: UIColor? {
        didSet {
            self.applyStyle(self.getStyle())
        }
    }

    override func setupSlider() {
        self.continuous = true
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbSnappingBehaviour = .freeform
        self.sliderDelegate = self
    }
    
    open override func colorOfSeparatorLabel(_ index: Int) -> UIColor? {
        switch index {
        case 0:
            return self.minimumTrackTintColor
        case 1:
            return self.middleTrackTintColor
        default:
            return self.maximumTrackTintColor
        }
    }
}
