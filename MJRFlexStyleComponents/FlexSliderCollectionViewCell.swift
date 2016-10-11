//
//  FlexSliderCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 08.10.2016.
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

public class FlexSliderCollectionViewCell: FlexBaseCollectionViewCell {
    var flexSlider: FlexSlider?
    
    public override func initialize() {
        super.initialize()
        
        if let pcv = self.flexContentView {
            self.flexSlider = FlexSlider()
            if let fs = self.flexSlider {
                fs.hidden = true
                fs.valueChangedBlock = {
                    (value, index) in
                    if let item = self.item as? FlexSliderCollectionItem {
                        item.valueChangedHandler?(value: value)
                    }
                }
                pcv.addSubview(fs)
            }
        }
    }
    
    override public var appearance: FlexStyleAppearance? {
        didSet {
            self.flexContentView?.appearance = appearance
            self.applyTextAppearance()
            self.applySliderAppearance()
            self.refreshLayout()
        }
    }
    
    func applySliderAppearance() {
        if self.flexSlider?.appearance == nil {
            self.flexSlider?.appearance = self.appearance
        }
    }
    
    public func layoutSliderView(item: FlexSliderCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let fs = self.flexSlider {
            let appe = self.getAppearance()
            let imageViewRect = CGRect(origin: CGPointZero, size: appe.cellAppearance.controlSize)
            
            fs.appearance = appe
            fs.style = appe.cellAppearance.controlStyle
            fs.thumbStyle = appe.cellAppearance.controlStyle
            fs.styleColor = appe.cellAppearance.controlStyleColor
            fs.controlInsets = appe.cellAppearance.controlInsets
            
            let controlInsets = appe.cellAppearance.controlInsets
            let controlSize = appe.cellAppearance.controlSize
            
            fs.frame = CGRectMake(remainingCellArea.origin.x + (remainingCellArea.size.width - (controlInsets.right + controlSize.width)), remainingCellArea.origin.y + (remainingCellArea.size.height - controlSize.height) * 0.5, controlSize.width, controlSize.height)
            fs.hidden = false
            fs.minimumValue = item.minValue
            fs.maximumValue = item.maxValue
            fs.value = item.value
            let switchTotalWidth = imageViewRect.size.width + controlInsets.left + controlInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: switchTotalWidth*0.5, dy: 0).offsetBy(dx: -switchTotalWidth*0.5, dy: 0)
        }
        else {
            self.flexSlider?.hidden = true
        }
        return remainingCellArea
    }
    
    override public func applyStyles() {
        if let item = self.item as? FlexSliderCollectionItem, fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            self.applySelectionStyles(fcv)
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            // TODO: missing case for text inside slider
            if item.text != nil {
                self.layoutSliderView(item, area: remainingCellArea)
                self.layoutText(item, area: remainingCellArea)
                if let fs = self.flexSlider, tc = self.textLabel {
                    FlexControlLayoutHelper.horizontallyAlignTwoFlexControls(tc, lowerControl: fs, area: remainingCellArea)
                }
            }
            else {
                self.layoutSliderView(item, area: remainingCellArea)
            }
        }
    }

}
