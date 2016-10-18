//
//  FlexLabelAppearance.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.10.2016.
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

public class FlexLabelAppearance: FlexStyleBaseAppearance {
    public var textColor = UIColor.whiteColor()
    public var textFont = UIFont.boldSystemFontOfSize(12.0)
    public var size: CGFloat = 18
    public var textAlignment: NSTextAlignment = .Center
    public var insets: UIEdgeInsets = UIEdgeInsetsZero
    
    public override init() {
        super.init(style: .Box, styleColor: .clearColor(), backgroundColor: .grayColor(), borderColor: .grayColor(), borderWidth: 0.0)
    }
    
    public init(style: ShapeStyle, textColor: UIColor, textFont: UIFont, textAlignment: NSTextAlignment, size: CGFloat, insets: UIEdgeInsets, backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
        self.textColor = textColor
        self.textFont = textFont
        self.size = size
        self.textAlignment = textAlignment
        self.insets = insets
        
        super.init(style: style, styleColor: .clearColor(), backgroundColor: backgroundColor, borderColor: borderColor, borderWidth: borderWidth)
    }
}
