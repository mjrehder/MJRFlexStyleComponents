//
//  FlexStyleCollectionCellAppearance.swift
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

// Used for flex collection view cells
public class FlexStyleCollectionCellAppearance: NSObject {
    public var style: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)

    public var selectedBorderWidth: CGFloat = 0
    public var selectedBorderColor: UIColor = UIColor.blackColor()
    public var selectedStyleColor = UIColor.lightGrayColor()
    public var selectedBackgroundColor = UIColor.grayColor()

    public var iconSize: CGSize = CGSizeMake(32, 32)
    public var iconInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var iconStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)

    public var accessoryImageSize: CGSize = CGSizeMake(18, 18)
    public var accessoryImageInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var accessoryStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)

    public var textInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var textTextColor = UIColor.blackColor()
    public var textTextFont = UIFont.boldSystemFontOfSize(16.0)
    public var textAlignment: NSTextAlignment = .Left
    public var controlSize: CGSize = CGSizeMake(32, 32)

    public var controlInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var controlStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var controlStyleColor = UIColor.lightGrayColor()
    public var controlBorderWidth: CGFloat = 0
    public var controlBorderColor: UIColor = UIColor.grayColor()
}
