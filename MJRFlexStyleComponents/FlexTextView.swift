//
//  FlexTextView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 06.09.16.
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

open class FlexTextView: FlexView {
    fileprivate var _textView: UITextView?
    
    open var textView: UITextView {
        get {
            return _textView!
        }
        set {
            self._textView?.removeFromSuperview()
            self._textView = newValue
            self.addSubview(self._textView!)
            self.setupTextView()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    override func initView() {
        super.initView()
        self._textView = UITextView()
        self.addSubview(self._textView!)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupTextView()
    }
    
    func setupTextView() {
        let textViewRect = self.getViewRect()
        self.textView.frame = textViewRect
        
        let clipRect = self.bounds.offsetBy(dx: -textViewRect.origin.x, dy: -textViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(self.getStyle(), bounds: clipRect, color: UIColor.black)
        
        self.textView.layer.mask = maskShapeLayer
    }}
