//
//  FlexTextFieldCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 07.02.2017.
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
import StyledLabel

open class FlexTextFieldCollectionViewCell: FlexBaseCollectionViewCell, UITextFieldDelegate {
    open var textField: UITextField?
    
    open dynamic var textFieldBackgroundColor: UIColor = .clear {
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
        
        self.textField = UITextField()
        if let tv = self.textField, let pcv = self.flexContentView {
            tv.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            tv.isHidden = true
            pcv.addSubview(tv)
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTextAreaTouched(_:)))
            tv.addGestureRecognizer(tapGest)
        }
    }
    
    open override func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        DispatchQueue.main.async {
            if let text = item.text, let tvItem = item as? FlexTextFieldCollectionItem {
                if let tv = self.textField {
                    tv.keyboardType = tvItem.keyboardType ?? .default
                    tv.attributedText = text
                    tv.attributedPlaceholder = tvItem.placeholderText
                    if let textColor = self.textColor {
                        tv.textColor = textColor
                    }
                    tv.isSecureTextEntry = tvItem.isPasswordField
                    tv.backgroundColor = self.textFieldBackgroundColor
                    tv.delegate = tvItem.textFieldDelegate ?? self
                    tv.frame = area
                    tv.isHidden = false
                    tv.isUserInteractionEnabled = tvItem.textIsMutable
                    if tvItem.autodetectRTLTextAlignment {
                        self.applyTextAlignmentForTextField(tv)
                    }
                }
            }
            else {
                self.textField?.isHidden = true
            }
        }
    }
    
    open func cellTextAreaTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    fileprivate func applyTextAlignmentForTextField(_ textField: UITextField) {
        let ta: NSTextAlignment
        if let t = textField.text {
            ta = self.alignmentForString(t as NSString)
        }
        else if let at = textField.attributedText {
            ta = self.alignmentForString(at.string as NSString)
        }
        else {
            ta = .left
        }
        textField.textAlignment = ta
    }
    
    fileprivate func alignmentForString(_ astring: NSString) -> NSTextAlignment {
        if astring.length > 0 {
            let rightLeftLanguages = ["ar","arc","bcc","bqi","ckb","dv","fa","glk","he","ku","mzn","pnb","ps","sd","ug","ur","yi"]
            if let lang = CFStringTokenizerCopyBestStringLanguage(astring,CFRangeMake(0,astring.length)) {
                if rightLeftLanguages.contains(lang as String) {
                    return .right
                }
            }
        }
        return .left
    }
    
    // MARK: - UITextViewDelegate
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        if let item = self.item as? FlexTextFieldCollectionItem, let text = textField.attributedText {
            item.textChangedHandler?(text)
        }
    }
    
    open func textFieldDidChange(_ textField: UITextField) {
        if let item = self.item as? FlexTextFieldCollectionItem, let text = textField.attributedText {
            item.text = textField.attributedText
            item.textChangingHandler?(text)
        }
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let item = self.item as? FlexTextFieldCollectionItem {
            return item.textIsMutable
        }
        return false
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let item = self.item as? FlexTextFieldCollectionItem, let returnHandler = item.textFieldShouldReturn {
            if returnHandler(textField) {
                self.textField?.resignFirstResponder()
                return true
            }
        }
        return false
    }
}
