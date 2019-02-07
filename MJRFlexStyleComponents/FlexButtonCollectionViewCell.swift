//
//  FlexButtonCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 16.01.2017.
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

open class FlexButtonCollectionViewCell: FlexCollectionViewCell {
    public var textLabel: FlexBaseCollectionViewCellTextLabel?
    
    open var flexContentView: FlexCellView?
    
    @objc open dynamic var controlInsets: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5) {
        didSet {
            self.setNeedsLayout()
        }
    }
 
    open override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexCellView(frame: baseRect)
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)
            self.textLabel = self.createTextLabel(label: FlexBaseCollectionViewCellTextLabel(frame: .zero))
        }
    }
    
    @objc open func cellTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexButtonCollectionItem {
            let relPos = self.getRelPosFromTapGesture(recognizer)
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
        }
    }
    
    open func layoutText(_ item: FlexButtonCollectionItem, area: CGRect) {
        self.setupTextLabel(self.textLabel, text: item.text)
        self.textLabel?.frame = area
    }
    
    func createTextLabel<T: FlexLabel>(label: T) -> T {
        if let fcv = self.flexContentView {
            label.isHidden = true
            fcv.addSubview(label)
        }
        return label
    }
    
    func setupTextLabel(_ label: FlexLabel?, text: NSAttributedString?) {
        if let label = label {
            if let aText = text {
                label.isHidden = false
                label.label.attributedText = aText
            }
            else {
                label.isHidden = true
            }
        }
    }
    
    open func applySelectionStyles(_ fcv: FlexView) {
        fcv.styleColor = self.isSelected ? self.selectedStyleColor : self.styleColor
        fcv.borderColor = self.isSelected ? self.selectedBorderColor : self.borderColor
        fcv.borderWidth = self.isSelected ? self.selectedBorderWidth : self.borderWidth
    }
    
    open override func assignBorderLayout() {
        // Intentionally left blank
    }
    
    open override func refreshLayout() {
        self.flexContentView?.frame = self.bounds
        super.refreshLayout()
    }
    
    override open func applyStyles() {
        if let item = self.item as? FlexButtonCollectionItem, let fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            if let hp = item.headerPosition {
                fcv.headerPosition = hp
            }
            self.applySelectionStyles(fcv)
            let remainingCellArea = fcv.getViewRect()
            let controlInsets = item.controlInsets ?? self.controlInsets
            self.layoutText(item, area: remainingCellArea.inset(by: controlInsets))
        }
        super.applyStyles()
    }
}
