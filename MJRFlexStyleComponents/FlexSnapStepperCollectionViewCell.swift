//
//  FlexSnapStepperCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 30.06.2017.
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

open class FlexSnapStepperCollectionViewCell: FlexBaseCollectionViewCell {
    var flexSnapStepper: FlexSnapStepper?
    
    open override func initialize() {
        super.initialize()
        
        if let pcv = self.flexContentView {
            self.flexSnapStepper = FlexSnapStepper()
            if let fs = self.flexSnapStepper {
                fs.isHidden = true
                fs.stepValueChangeHandler = {
                    value in
                    if let item = self.item as? FlexSnapStepperCollectionItem {
                        item.value = value
                        item.valueChangedHandler?(value)
                    }
                }
                pcv.addSubview(fs)
            }
        }
    }
    
    open func layoutSliderView(_ item: FlexSnapStepperCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let fs = self.flexSnapStepper {
            let controlInsets = item.controlInsets ?? self.controlInsets
            let imageViewRect = self.getControlArea()
            fs.isHidden = false
            fs.value = item.value
            fs.minStepperValue = item.minValue
            fs.maxStepperValue = item.maxValue
            fs.valueSteps = item.valueSteps
            fs.valueSlideFactor = item.valueSlideFactor
            fs.controlInsets = controlInsets
            fs.thumbText = item.thumbText
            fs.numberFormatString = item.numberFormatString
            fs.thumbRatio = item.thumbRatio
            fs.thumbSize = item.thumbSize
            fs.frame = UIEdgeInsetsInsetRect(imageViewRect, controlInsets)
            let sliderTotalWidth = imageViewRect.size.width + controlInsets.left + controlInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: sliderTotalWidth*0.5, dy: 0).offsetBy(dx: -sliderTotalWidth*0.5, dy: 0)
        }
        else {
            self.flexSnapStepper?.isHidden = true
        }
        return remainingCellArea
    }
    
    override open func applyStyles() {
        self.applyContentViewInfo()
        if let item = self.item as? FlexSnapStepperCollectionItem, let fcv = self.flexContentView {
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            // TODO: missing case for text inside slider
            if item.text != nil {
                let _ = self.layoutSliderView(item, area: remainingCellArea)
                self.layoutControl(item, area: remainingCellArea)
                if let fs = self.flexSnapStepper, let tc = self.textLabel {
                    FlexControlLayoutHelper.horizontallyAlignTwoFlexControls(tc, lowerControl: fs, area: remainingCellArea)
                }
            }
            else {
                let _ = self.layoutSliderView(item, area: remainingCellArea)
            }
        }
    }

}
