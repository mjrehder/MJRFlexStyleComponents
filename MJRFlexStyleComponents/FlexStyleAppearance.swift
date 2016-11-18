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

open class FlexStyleAppearance: FlexStyleContainerAppearance {
	static var initialized: Bool = false
    
    open var viewAppearance = FlexViewAppearance()
    open var collectionViewAppearance = FlexCollectionViewAppearance()
    
    // Menus
    open var menuBackgroundColor: UIColor = UIColor.black
    open var menuItemStyle: ShapeStyle = .roundedFixed(cornerRadius: 5.0)
    open var menuInterItemSpacing: CGFloat = 5.0
    open var menuItemSize: CGSize = CGSize(width: 18, height: 18)
    open var menuSize: CGSize = CGSize(width: 100, height: 18)
    open var menuStyle:FlexMenuStyle = .equallySpaces(thumbPos: .top)

    public override init() {
        super.init(style: .roundedFixed(cornerRadius: 5.0), styleColor: .black, backgroundColor: .clear, borderColor: .gray, borderWidth: 0)
    }
}
