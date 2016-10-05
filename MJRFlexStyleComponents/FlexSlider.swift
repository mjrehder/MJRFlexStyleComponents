//
//  FlexSlider.swift
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

@IBDesignable
public class FlexSlider: GenericStyleSlider, GenericStyleSliderDelegate {

    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.setupSlider()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSlider()
    }
    
    public var value: Double {
        get {
            return self.values[0]
        }
        set(newValue) {
            self.values[0] = newValue
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor? = UISlider.appearance().thumbTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    @IBInspectable public var minimumTrackTintColor: UIColor? = UISlider.appearance().minimumTrackTintColor {
        didSet {
            self.applyStyle(self.getStyle())
        }
    }
    
    @IBInspectable public var maximumTrackTintColor: UIColor? = UISlider.appearance().maximumTrackTintColor {
        didSet {
            self.applyStyle(self.getStyle())
        }
    }

    @IBInspectable public var maximumTrackText: String? = nil {
        didSet {
            self.applyStyle(self.getStyle())
        }
    }

    func setupSlider() {
        self.continuous = true
        self.style = .Tube
        self.thumbStyle = .Tube
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.borderColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.thumbSnappingBehaviour = .Freeform
        self.values = [0]
        self.sliderDelegate = self
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    public func iconOfThumb(index: Int) -> UIImage? {
        return nil
    }
    
    public func textOfThumb(index: Int) -> String? {
        return nil
    }
    
    public func textOfSeparatorLabel(index: Int) -> String? {
        if index == self.values.count {
            return self.maximumTrackText
        }
        return nil
    }
    
    public func colorOfThumb(index: Int) -> UIColor? {
        return self.thumbTintColor
    }
    
    public func colorOfSeparatorLabel(index: Int) -> UIColor? {
        return index == 0 ? self.minimumTrackTintColor : self.maximumTrackTintColor
    }

    public func behaviourOfThumb(index: Int) -> StyledSliderThumbBehaviour? {
        return nil
    }

}
