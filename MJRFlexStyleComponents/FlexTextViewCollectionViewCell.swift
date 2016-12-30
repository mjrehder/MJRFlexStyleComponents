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

open class FlexTextViewCollectionViewCell: FlexBaseCollectionViewCell {
    open var textView: UITextView?
    
    open override func initialize() {
        super.initialize()
        
        self.textView = UITextView()
        if let tv = self.textView, let pcv = self.flexContentView {
            tv.isHidden = true
            pcv.addSubview(tv)
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.accessoryViewTouched(_:)))
            tv.addGestureRecognizer(tapGest)
        }
    }
    
    open override func layoutText(_ item: FlexBaseCollectionItem, area: CGRect) {
        DispatchQueue.main.async {
            if let text = item.text {
                if let tv = self.textView {
                    tv.attributedText = text
                    tv.backgroundColor = .clear
                    self.prepareTextView(tv)
                    let controlInsets = item.controlInsets ?? self.controlInsets
                    let textRect =  UIEdgeInsetsInsetRect(area, controlInsets)
                    tv.frame = textRect
                    tv.isHidden = false
                    tv.isUserInteractionEnabled = false
                }
            }
            else {
                self.textView?.isHidden = true
            }
        }
    }

    open func cellTextAreaTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    fileprivate func prepareTextView(_ textView: UITextView) {
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = UIDataDetectorTypes()
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = UIEdgeInsets.zero
        textView.contentOffset = CGPoint.zero
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }
}
