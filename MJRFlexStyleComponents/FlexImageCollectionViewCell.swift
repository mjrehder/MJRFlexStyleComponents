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

public class FlexImageCollectionViewCell: FlexCollectionViewCell {
    public var flexContentView: FlexImageShapeView?
    
    override public var cellAppearance: FlexStyleCollectionCellAppearance? {
        didSet {
            self.flexContentView?.flexViewAppearance = cellAppearance?.viewAppearance
            self.refreshLayout()
        }
    }
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexImageShapeView(frame: baseRect)
        self.flexContentView?.flexViewAppearance = self.getCellAppearance().viewAppearance
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func cellTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexImageCollectionItem {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    public func applySelectionStyles(fcv: FlexView) {
        fcv.header.labelBackgroundColor = self.selected ? self.getCellAppearance().selectedBackgroundColor : self.getCellAppearance().viewAppearance.headerAppearance.backgroundColor
        fcv.styleColor = self.selected ? self.getCellAppearance().selectedStyleColor : self.getCellAppearance().styleColor
        fcv.borderColor = self.selected ? self.getCellAppearance().selectedBorderColor : self.getCellAppearance().borderColor
        fcv.borderWidth = self.selected ? self.getCellAppearance().selectedBorderWidth : self.getCellAppearance().borderWidth
    }
    
    override public func applyStyles() {
        super.applyStyles()
        
        if let item = self.item as? FlexImageCollectionItem, fcv = self.flexContentView {
            fcv.image = item.image
            fcv.headerAttributedText = item.text
            fcv.imageStyle = self.getCellAppearance().controlStyle
            fcv.contentViewMargins = self.getCellAppearance().controlInsets
            fcv.backgroundImageFit = item.imageFit
            self.applySelectionStyles(fcv)
        }
    }
}
