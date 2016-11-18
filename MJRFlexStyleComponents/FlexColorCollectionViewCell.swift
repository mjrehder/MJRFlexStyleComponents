//
//  FlexColorCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 07.10.2016.
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
import StyledLabel

open class FlexColorCollectionViewCell: FlexBaseCollectionViewCell {
    var colorView: UIView?

    open override func initialize() {
        super.initialize()
        
        if let pcv = self.flexContentView {
            self.colorView = UIView()
            if let cv = self.colorView {
                cv.isHidden = true
                pcv.addSubview(cv)
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.colorViewTouched(_:)))
                cv.addGestureRecognizer(tapGest)
            }
        }
    }
    
    open func colorViewTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexColorCollectionItem {
            item.colorActionHandler?()
        }
    }
    
    open func layoutColorView(_ item: FlexColorCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let cv = self.colorView {
            let appe = self.getCellAppearance()
            let controlInsets = appe.controlInsets
            let controlSize = appe.controlSize

            let imageViewRect = CGRect(origin: CGPoint.zero, size: controlSize)
            let colorLayer = StyledShapeLayer.createShape(appe.controlStyle, bounds: imageViewRect, color: item.color, borderColor: appe.controlBorderColor, borderWidth: appe.controlBorderWidth)

            cv.frame = CGRect(x: remainingCellArea.origin.x + (remainingCellArea.size.width - (controlInsets.right + controlSize.width)), y: remainingCellArea.origin.y + (remainingCellArea.size.height - controlSize.height) * 0.5, width: controlSize.width, height: controlSize.height)
            cv.layer.sublayers?.removeAll()
            cv.layer.addSublayer(colorLayer)
            cv.isHidden = false
            let colorLayerTotalWidth = imageViewRect.size.width + controlInsets.left + controlInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: colorLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -colorLayerTotalWidth*0.5, dy: 0)
        }
        else {
            self.colorView?.isHidden = true
        }
        return remainingCellArea
    }
    
    override open func applyStyles() {
        if let item = self.item as? FlexColorCollectionItem, let fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            self.applySelectionStyles(fcv)
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            remainingCellArea = self.layoutColorView(item, area: remainingCellArea)
            self.layoutText(item, area: remainingCellArea)
        }
    }
}
