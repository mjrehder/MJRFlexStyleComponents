//
//  FlexFlickButtonCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 02.08.2017.
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
import MJRFlexStyleComponents

public typealias AttributedFlickButtonHandler = ((Int, CGRect, CGFloat)->NSAttributedString?)

open class FlexAttributableFlickButton: FlexFlickButton {
    open var attributedTextOfThumbHandler: AttributedFlickButtonHandler? {
        didSet {
            self.createItems()
        }
    }
    open var attributedTextOfSeparatorHandler: AttributedFlickButtonHandler? {
        didSet {
            self.createItems()
        }
    }
    
    open override func attributedTextOfThumb(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return attributedTextOfThumbHandler?(index, rect, relativeCenter)
    }
    
    open override func attributedTextOfSeparatorLabel(at index: Int, rect: CGRect, relativeCenter: CGFloat) -> NSAttributedString? {
        return attributedTextOfSeparatorHandler?(index, rect, relativeCenter)
    }
}

open class FlexFlickButtonCollectionViewCell: FlexBaseCollectionViewCell {
    var flexFlickButton: FlexAttributableFlickButton?
    
    open override func initialize() {
        super.initialize()
        
        if let pcv = self.flexContentView {
            self.flexFlickButton = FlexAttributableFlickButton()
            if let fs = self.flexFlickButton {
                fs.isHidden = true
                if let item = self.item as? FlexFlickButtonCollectionItem {
                    fs.actionActivationHandler = item.actionActivationHandler
                    fs.direction = .vertical
                }
                pcv.addSubview(fs)
            }
        }
    }
    
    open func layoutSliderView(_ item: FlexFlickButtonCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let fs = self.flexFlickButton {
            let controlInsets = item.controlInsets ?? self.controlInsets
            let imageViewRect = self.getControlArea()
            fs.isHidden = false
            fs.actionActivationHandler = item.actionActivationHandler
            fs.controlInsets = controlInsets
            fs.upperActionItem = item.upperActionItem
            fs.primaryActionItem = item.primaryActionItem
            fs.lowerActionItem = item.lowerActionItem
            fs.sizingType = item.sizingType
            fs.direction = .vertical
            fs.attributedTextOfThumbHandler = item.attributedTextOfThumbHandler
            fs.attributedTextOfSeparatorHandler = item.attributedTextOfSeparatorHandler
            
            fs.frame = UIEdgeInsetsInsetRect(imageViewRect, controlInsets)
            let sliderTotalWidth = imageViewRect.size.width + controlInsets.left + controlInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: sliderTotalWidth*0.5, dy: 0).offsetBy(dx: -sliderTotalWidth*0.5, dy: 0)
        }
        else {
            self.flexFlickButton?.isHidden = true
        }
        return remainingCellArea
    }
    
    override open func applyStyles() {
        self.applyContentViewInfo()
        if let item = self.item as? FlexFlickButtonCollectionItem, let fcv = self.flexContentView {
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            if item.text != nil {
                let _ = self.layoutSliderView(item, area: remainingCellArea)
                self.layoutControl(item, area: remainingCellArea)
                if let fs = self.flexFlickButton, let tc = self.textLabel {
                    FlexControlLayoutHelper.horizontallyAlignTwoFlexControls(tc, lowerControl: fs, area: remainingCellArea)
                }
            }
            else {
                let _ = self.layoutSliderView(item, area: remainingCellArea)
            }
        }
    }
}
