//
//  FlexTextViewCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 23.09.16.
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

public class FlexTextViewCollectionViewCell: FlexBaseCollectionViewCell {
    public var textContentView: FlexTextView?
    
    override public var cellAppearance: FlexStyleCollectionCellAppearance? {
        didSet {
            self.textContentView?.flexViewAppearance = cellAppearance?.viewAppearance
            self.refreshLayout()
        }
    }
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.textContentView = FlexTextView(frame: baseRect)
        self.textContentView?.flexViewAppearance = self.getCellAppearance().viewAppearance
        if let pcv = self.textContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTextAreaTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)
        }
    }
    
    public override func layoutText(item: FlexBaseCollectionItem, area: CGRect) {
        dispatch_async(dispatch_get_main_queue()) {
            if let text = item.text {
                self.textContentView?.textView.attributedText = text
                if let pcv = self.textContentView {
                    pcv.textView.backgroundColor = .clearColor()
                    self.prepareTextView(pcv.textView)
                    let appe = self.getCellAppearance()
                    let textRect =  UIEdgeInsetsInsetRect(area, appe.textAppearance.insets)
                    pcv.frame = textRect
                    pcv.hidden = false
                    pcv.userInteractionEnabled = false
                }
            }
            else {
                self.textLabel?.hidden = true
            }
        }
    }

    public func cellTextAreaTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    private func prepareTextView(textView: UITextView) {
        textView.editable = false
        textView.selectable = true
        textView.userInteractionEnabled = true
        textView.dataDetectorTypes = .None
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.scrollEnabled = false
        textView.contentInset = UIEdgeInsetsZero
        textView.scrollIndicatorInsets = UIEdgeInsetsZero
        textView.contentOffset = CGPointZero
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
    }
}
