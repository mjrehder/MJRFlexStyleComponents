//
//  FlexImageCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 20.10.2016.
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

open class FlexImageCollectionViewCell: FlexCollectionViewCell {
    open var flexContentView: FlexImageShapeView?
    
    open override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexImageShapeView(frame: baseRect)
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open func cellTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexImageCollectionItem {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    open func applySelectionStyles(_ fcv: FlexView) {
        fcv.styleColor = self.isSelected ? self.selectedStyleColor : self.styleColor
        fcv.borderColor = self.isSelected ? self.selectedBorderColor : self.borderColor
        fcv.borderWidth = self.isSelected ? self.selectedBorderWidth : self.borderWidth
    }
    
    override open func applyStyles() {
        super.applyStyles()
        
        if let item = self.item as? FlexImageCollectionItem, let fcv = self.flexContentView {
            fcv.image = item.image
            fcv.headerAttributedText = item.text
            fcv.backgroundImageFit = item.imageFit
            fcv.contentViewMargins = item.controlInsets
            if let hp = item.headerPosition {
                fcv.headerPosition = hp
            }
            self.applySelectionStyles(fcv)
        }
    }
}
