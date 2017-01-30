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

open class FlexTextViewCollectionViewCell: FlexBaseCollectionViewCell, UITextViewDelegate {
    open var textView: UITextView?

    open dynamic var textViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var textColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }

    open override func initialize() {
        super.initialize()
        
        self.textView = UITextView()
        if let tv = self.textView, let pcv = self.flexContentView {
            tv.isHidden = true
            pcv.addSubview(tv)
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTextAreaTouched(_:)))
            tv.addGestureRecognizer(tapGest)
        }
    }
    
    open override func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        DispatchQueue.main.async {
            if let text = item.text, let tvItem = item as? FlexTextViewCollectionItem {
                if let tv = self.textView {
                    tv.attributedText = text
                    if let textColor = self.textColor {
                        tv.textColor = textColor
                    }
                    tv.backgroundColor = self.textViewBackgroundColor
                    tv.delegate = tvItem.textViewDelegate ?? self
                    self.prepareTextView(tv)
                    tv.isEditable = tvItem.textIsMutable
                    tv.frame = area
                    tv.isHidden = false
                    tv.isUserInteractionEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.showsVerticalScrollIndicator = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.isScrollEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
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
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let item = self.item as? FlexTextViewCollectionItem {
            item.attributedTextChangedHandler?(textView.attributedText)
            item.textChangedHandler?(textView.text)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let item = self.item as? FlexTextViewCollectionItem {
            item.text = textView.attributedText
        }
    }
}
