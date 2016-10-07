//
//  FlexStyleAppearance.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 21.09.16.
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

public let flexStyleAppearance = FlexStyleAppearance()

public class FlexStyleAppearance  {
	static var initialized: Bool = false

    public var style: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var backgroundInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var contentInsets: UIEdgeInsets = UIEdgeInsetsZero

    // Styles and colors. Selected styles and colors are for collection views etc.
    public var borderWidth: CGFloat = 0
	public var selectedBorderWidth: CGFloat = 0

	public var borderColor: UIColor = UIColor.grayColor()
    public var selectedBorderColor: UIColor = UIColor.blackColor()
    
    public var styleColor = UIColor.lightGrayColor()
    public var selectedStyleColor = UIColor.blackColor()
    
    public var backgroundColor = UIColor.clearColor()
    public var selectedBackgroundColor = UIColor.clearColor()

    // Flex Switch
    public var switchOnColor: UIColor = UIColor.redColor().darkerColor()
    public var switchThumbColor: UIColor = .grayColor()
    
    // Used for collection view cells
    public var cellStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var cellIconSize: CGSize = CGSizeMake(32, 32)
    public var cellIconInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellIconStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var cellAccessoryImageSize: CGSize = CGSizeMake(18, 18)
    public var cellAccessoryImageInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellAccessoryStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var cellTextInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var cellTextTextColor = UIColor.blackColor()
    public var cellTextTextFont = UIFont.boldSystemFontOfSize(16.0)
    public var cellTextAlignment: NSTextAlignment = .Left
    public var cellControlSize: CGSize = CGSizeMake(32, 32)
    public var cellControlInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellControlStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var cellControlStyleColor = UIColor.lightGrayColor()

    // Header and Footer
    public var headerStyle: ShapeStyle = .Box
    public var headerTextColor = UIColor.whiteColor()
    public var headerTextFont = UIFont.boldSystemFontOfSize(12.0)
    public var headerSize: CGFloat = 18
    public var headerAlignment: NSTextAlignment = .Center
    public var headerInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var headerBackgroundColor: UIColor = .grayColor()

    public var footerStyle: ShapeStyle = .Box
    public var footerTextColor = UIColor.whiteColor()
    public var footerTextFont = UIFont.boldSystemFontOfSize(10.0)
    public var footerSize: CGFloat = 18
    public var footerAlignment: NSTextAlignment = .Center
    public var footerInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var footerBackgroundColor: UIColor = .grayColor()
    
    // Menus
    public var menuBackgroundColor: UIColor = UIColor.blackColor()
    public var menuItemStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var menuInterItemSpacing: CGFloat = 5.0
    public var menuItemSize: CGSize = CGSizeMake(18, 18)
    public var menuSize: CGSize = CGSizeMake(100, 18)
    public var menuStyle:FlexMenuStyle = .EquallySpaces(thumbPos: .Top)

    public init() {
    }
}
