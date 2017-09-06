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

    open dynamic var textContainerInsets: UIEdgeInsets = .zero {
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
            if let text = item.text, let tvItem = item as? FlexTextViewCollectionItem, self.isDisplayModeNormal() {
                self.setupTextLabel(self.textLabel, text: tvItem.textTitle)
                var textArea = area
                if let tt = tvItem.textTitle {
                    let height = tt.heightWithConstrainedWidth(area.size.width)
                    let tlf = CGRect(x: area.origin.x, y: area.origin.y, width: area.size.width, height: height)
                    self.textLabel?.frame = tlf
                    textArea = CGRect(x: area.origin.x, y: area.origin.y + height, width: area.size.width, height: area.size.height - height)
                }
                if let tv = self.textView {
                    tv.frame = UIEdgeInsetsInsetRect(textArea, tvItem.textViewInsets)
                    tv.backgroundColor = self.textViewBackgroundColor
                    tv.delegate = tvItem.textViewDelegate ?? self
                    tv.prepareDefault()
                    tv.isEditable = tvItem.textIsMutable
                    tv.isHidden = false
                    tv.isUserInteractionEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.showsVerticalScrollIndicator = tvItem.textIsMutable || tvItem.textIsScrollable
                    tv.isScrollEnabled = tvItem.textIsMutable || tvItem.textIsScrollable
                    if tvItem.autodetectRTLTextAlignment {
                        tv.applyAutoTextAlignment()
                    }
                    tv.textContainerInset = self.textContainerInsets
                    
                    // Calculate truncated text last, when all sizes and parameters have been set
                    tv.attributedText = self.truncateTextForTextArea(item: item, string: text)
                    if let textColor = self.textColor {
                        tv.textColor = textColor
                    }
                }
            }
            else {
                self.textView?.isHidden = true
            }
        }
    }
    
    open func truncateTextForTextArea(item: FlexBaseCollectionItem, string: NSAttributedString) -> NSAttributedString {
        if let tvItem = item as? FlexTextViewCollectionItem, let addOnStr = tvItem.autodetectTextSizeFittingAndTruncateWithString {
            let maxLength = self.numberOfCharactersThatFitTextArea(string: string)
            if maxLength > addOnStr.length && maxLength < string.length {
                let compiledText = NSMutableAttributedString(attributedString: string.attributedSubstring(from: NSMakeRange(0, maxLength - addOnStr.length)))
                compiledText.append(addOnStr)
                return compiledText
            }
        }
        return string
    }
    
    open func numberOfCharactersThatFitTextArea(string: NSAttributedString) -> Int {
        if let tv = self.textView {
            let frameSetterRef = CTFramesetterCreateWithAttributedString(string as CFAttributedString)
            var characterFitRange:CFRange = CFRange()
            CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, CGSize(width: tv.bounds.size.width, height: tv.bounds.size.height + 4), &characterFitRange)
            return characterFitRange.length
        }
        return 0
    }
    
    open override func layoutIconifiedIconView(_ item: FlexBaseCollectionItem, area: CGRect) {
        super.layoutIconifiedIconView(item, area: area)
        self.textView?.isHidden = true
    }
    
    open func cellTextAreaTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item {
            let relPos = self.getRelPosFromTapGesture(recognizer)
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
        }
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
            item.textChangingHandler?(textView.text)
        }
    }
}
