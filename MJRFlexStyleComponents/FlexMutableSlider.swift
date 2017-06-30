//
//  FlexMutableSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 18.06.2017.
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

open class FlexMutableSlider: GenericStyleSlider, GenericStyleSliderDelegate {
    private var thumbs: [MutableSliderThumbItem] = []
    private var separators: [MutableSliderSeparatorItem] = []

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
    
    func setupSlider() {
        let sep0 = MutableSliderSeparatorItem()
        self.separators.append(sep0)
        
        self.continuous = true
        self.minimumValue = 0
        self.maximumValue = 1
        self.thumbSnappingBehaviour = .freeform
        self.sliderDelegate = self
    }
    
    // MARK: - Public interface
    
    open func addThumb(_ thumb: MutableSliderThumbItem, separator: MutableSliderSeparatorItem) {
        self.thumbs.append(thumb)
        self.separators.append(separator)
        self.recreateThumbs()
    }
    
    open func addSeparator(_ separator: MutableSliderSeparatorItem) {
        self.separators.append(separator)
        self.recreateThumbs()
    }
    
    open func removeThumb(at idx: Int) {
        self.thumbs.remove(at: idx)
        self.separators.remove(at: idx+1)
        self.recreateThumbs()
    }
    
    open func getThumb(at idx: Int) -> MutableSliderThumbItem? {
        if idx < self.thumbs.count {
            return self.thumbs[idx]
        }
        return nil
    }
    
    open func getSeparator(at idx: Int) -> MutableSliderSeparatorItem? {
        if idx < self.separators.count {
            return self.separators[idx]
        }
        return nil
    }
    
    open func removeAll() {
        self.thumbs.removeAll()
        self.separators.removeAll()
    }
    
    // MARK: - Model Handling
    
    func recreateThumbs() {
        var vals:[Double] = []
        for thumb in self.thumbs {
            vals.append(thumb.initialValue)
        }
        self.values = vals
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    open func iconOfThumb(_ index: Int) -> UIImage? {
        if index < self.thumbs.count {
            return self.thumbs[index].icon
        }
        return nil
    }
    
    open func iconOfSeparator(_ index: Int) -> UIImage? {
        if index < self.separators.count {
            return self.separators[index].icon
        }
        return nil
    }
    
    open func textOfThumb(_ index: Int) -> String? {
        if index < self.thumbs.count {
            return self.thumbs[index].text
        }
        return nil
    }
    
    open func textOfSeparatorLabel(_ index: Int) -> String? {
        if index < self.separators.count {
            return self.separators[index].text
        }
        return nil
    }
    
    open func colorOfThumb(_ index: Int) -> UIColor? {
        if index < self.thumbs.count {
            return self.thumbs[index].color
        }
        return nil
    }
    
    open func colorOfSeparatorLabel(_ index: Int) -> UIColor? {
        if index < self.separators.count {
            return self.separators[index].color
        }
        return .clear
    }
    
    open func adaptOpacityForSeparatorLabel(_ index: Int) -> Bool {
        if index < self.separators.count {
            return self.separators[index].useOpacityForSizing
        }
        return true
    }

    open func behaviourOfThumb(_ index: Int) -> StyledSliderThumbBehaviour? {
        if index < self.thumbs.count {
            return self.thumbs[index].behaviour
        }
        return nil
    }
    
    open func attributedTextOfThumb(_ index: Int) -> NSAttributedString? {
        if index < self.thumbs.count {
            return self.thumbs[index].attributedText
        }
        return nil
    }
    
    open func attributedTextOfSeparatorLabel(_ index: Int) -> NSAttributedString? {
        if index < self.separators.count {
            return self.separators[index].attributedText
        }
        return nil
    }
    
    open func sizeInfoOfThumb(_ index: Int) -> SliderThumbSizeInfo? {
        if index < self.thumbs.count {
            return self.thumbs[index].sizeInfo
        }
        return nil
    }
    
    open func sizeInfoOfSeparator(_ index: Int) -> SliderSeparatorSizeInfo? {
        if index < self.separators.count {
            return self.separators[index].sizeInfo
        }
        return nil
    }
    
    open func triggerEventValues(_ index: Int) -> (Double?, Double?) {
        if index < self.thumbs.count {
            return (self.thumbs[index].triggerEventBelow, self.thumbs[index].triggerEventAbove)
        }
        return (nil, nil)
    }
    
    open func thumbValueLimits(_ index: Int) -> (Double?, Double?) {
        if index < self.thumbs.count {
            return (self.thumbs[index].lowerLimit, self.thumbs[index].upperLimit)
        }
        return (nil, nil)
    }
}
