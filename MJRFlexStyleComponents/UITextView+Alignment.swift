//
//  UITextView+Alignment.swift
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

public extension UITextView {
    
    /// Applies the UITextView text alignment based on detected contents language
    public func applyAutoTextAlignment() {
        let ta: NSTextAlignment
        if let t = self.text {
            ta = self.alignmentForString(t as NSString)
        }
        else if let at = self.attributedText {
            ta = self.alignmentForString(at.string as NSString)
        }
        else {
            ta = .left
        }
        self.textAlignment = ta
    }
    
    public func alignmentForString(_ astring: NSString) -> NSTextAlignment {
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
}
