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

public class FlexTextViewCollectionViewCell: FlexCollectionViewCell {
    public var textContentView: FlexTextView?
    
    override public var appearance: FlexStyleAppearance? {
        didSet {
            self.textContentView?.appearance = appearance
            self.refreshLayout()
        }
    }
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.textContentView = FlexTextView(frame: baseRect)
        self.textContentView?.appearance = self.getAppearance()
        if let pcv = self.textContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)
        }
    }
    
    public override func refreshLayout() {
        super.refreshLayout()
        dispatch_async(dispatch_get_main_queue()) {
            if let tc = self.item as? FlexTextViewCollectionItem {
                self.textContentView?.headerAttributedText = tc.title
                self.textContentView?.textView.attributedText = tc.text
            }
            if let pcv = self.textContentView {
                pcv.textView.backgroundColor = .clearColor()
                self.prepareTextView(pcv.textView)
                pcv.header.labelBackgroundColor = self.selected ? self.getAppearance().cellAppearance.selectedBackgroundColor : self.getAppearance().headerAppearance.backgroundColor
                pcv.styleColor = self.selected ? self.getAppearance().cellAppearance.selectedStyleColor : self.getAppearance().styleColor
                pcv.borderColor = self.selected ? self.getAppearance().cellAppearance.selectedBorderColor : self.getAppearance().borderColor
                pcv.borderWidth = self.selected ? self.getAppearance().cellAppearance.selectedBorderWidth : self.getAppearance().borderWidth
                pcv.userInteractionEnabled = false
            }
        }
    }
    
    public func cellTouched(recognizer: UITapGestureRecognizer) {
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
