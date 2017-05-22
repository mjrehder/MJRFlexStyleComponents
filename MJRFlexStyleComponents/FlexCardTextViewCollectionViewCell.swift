//
//  FlexCardTextViewCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 12.02.2017.
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

open class FlexCardTextViewCollectionViewCell: FlexCardViewCollectionViewCell, UITextViewDelegate {

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
    
    open dynamic var textContainerInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open override func initialize() {
        super.initialize()
        
        self.bodyView = FlexTextView(frame: .zero)
        if let tv = self.bodyView as? FlexTextView, let pcv = self.flexContentView {
            tv.isHidden = true
            pcv.addSubview(tv)
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTextAreaTouched(_:)))
            tv.textView.addGestureRecognizer(tapGest)
        }
    }
    
    open func cellTextAreaTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item {
            let relPos = self.getRelPosFromTapGesture(recognizer)
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
        }
    }
    
    open override func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        super.layoutControl(item, area: area)
        DispatchQueue.main.async {
            if let tvItem = item as? FlexCardTextViewCollectionItem, let text = tvItem.cardText {
                if let bv = self.bodyView as? FlexTextView {
                    let tv = bv.textView
                    tv.attributedText = text
                    if let textColor = self.textColor {
                        tv.textColor = textColor
                    }
                    tv.backgroundColor = self.textViewBackgroundColor
                    tv.delegate = tvItem.textViewDelegate ?? self
                    tv.prepareDefault()
                    tv.isEditable = tvItem.textIsMutable
                    tv.isUserInteractionEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.showsVerticalScrollIndicator = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.isScrollEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
                    if tvItem.autodetectRTLTextAlignment {
                        tv.applyAutoTextAlignment()
                    }
                    tv.textContainerInset = self.textContainerInsets
                    bv.isHidden = false
                }
            }
            else {
                self.bodyView?.isHidden = true
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let item = self.item as? FlexCardTextViewCollectionItem {
            item.textChangedHandler?(textView.attributedText.string)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let item = self.item as? FlexCardTextViewCollectionItem {
            item.text = textView.attributedText
            item.textChangingHandler?(textView.attributedText.string)
        }
    }
}
