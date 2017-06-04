//
//  FlexSwitchCollectionViewCell.swift
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

open class FlexSwitchCollectionViewCell: FlexBaseCollectionViewCell, FlexSwitchDelegate {
    var flexSwitch: FlexSwitch?

    open override func initialize() {
        super.initialize()
        
        if let pcv = self.flexContentView {
            self.flexSwitch = FlexSwitch()
            if let fs = self.flexSwitch {
                fs.isHidden = true
                fs.switchDelegate = self
                pcv.addSubview(fs)
            }
        }
    }
    
    open func layoutSwitchView(_ item: FlexSwitchCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let fs = self.flexSwitch {
            let controlInsets = item.controlInsets ?? self.controlInsets
            let controlSize = self.getControlArea().size
            
            let imageViewRect = CGRect(origin: CGPoint.zero, size: controlSize)

            fs.frame = CGRect(x: remainingCellArea.origin.x + (remainingCellArea.size.width - (controlInsets.right + controlSize.width)), y: remainingCellArea.origin.y + (remainingCellArea.size.height - controlSize.height) * 0.5, width: controlSize.width, height: controlSize.height)
            fs.isHidden = false
            fs.setOn(item.value)
            let switchTotalWidth = imageViewRect.size.width + controlInsets.left + controlInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: switchTotalWidth*0.5, dy: 0).offsetBy(dx: -switchTotalWidth*0.5, dy: 0)
        }
        else {
            self.flexSwitch?.isHidden = true
        }
        return remainingCellArea
    }
    
    override open func applyStyles() {
        self.applyContentViewInfo()
        if let item = self.item as? FlexSwitchCollectionItem, let fcv = self.flexContentView {
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            remainingCellArea = self.layoutSwitchView(item, area: remainingCellArea)
            self.layoutControl(item, area: remainingCellArea)
        }
    }
    
    // MARK: - FlexSwitchDelegate
    
    open func switchStateChanged(_ flexSwitch: FlexSwitch, on: Bool) {
        if let item = self.item as? FlexSwitchCollectionItem {
            item.valueChangedHandler?(on)
        }
    }
}
