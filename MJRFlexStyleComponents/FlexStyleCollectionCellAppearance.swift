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
open class FlexStyleCollectionCellAppearance: FlexStyleContainerAppearance {
    open var viewAppearance = FlexViewAppearance()
    
    open var detailTextAppearance = FlexLabelAppearance(style: .box, textColor: .black, textFont: UIFont.systemFont(ofSize: 10), textAlignment: .left, size: 16, insets: UIEdgeInsets.zero, backgroundColor: .clear, borderColor: .black, borderWidth: 0)
    open var infoTextAppearance = FlexLabelAppearance(style: .box, textColor: .black, textFont: UIFont.systemFont(ofSize: 12), textAlignment: .left, size: 16, insets: UIEdgeInsets.zero, backgroundColor: .clear, borderColor: .black, borderWidth: 0)
    open var auxTextAppearance = FlexLabelAppearance(style: .box, textColor: .black, textFont: UIFont.systemFont(ofSize: 8), textAlignment: .left, size: 16, insets: UIEdgeInsets.zero, backgroundColor: .clear, borderColor: .black, borderWidth: 0)
    
    open var selectedBorderWidth: CGFloat = 0
    open var selectedBorderColor: UIColor = UIColor.black
    open var selectedStyleColor = UIColor.lightGray
    open var selectedBackgroundColor = UIColor.gray

    open var iconSize: CGSize = CGSize(width: 32, height: 32)
    open var iconInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    open var iconStyle: ShapeStyle = .roundedFixed(cornerRadius: 5.0)

    open var accessoryImageSize: CGSize = CGSize(width: 18, height: 18)
    open var accessoryImageInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    open var accessoryStyle: ShapeStyle = .roundedFixed(cornerRadius: 5.0)

    open var controlSize: CGSize = CGSize(width: 32, height: 32)
    open var controlInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var controlStyle: ShapeStyle = .roundedFixed(cornerRadius: 5.0)
    open var controlStyleColor = UIColor.lightGray
    open var controlBorderWidth: CGFloat = 0
    open var controlBorderColor: UIColor = UIColor.gray
    
    public override init() {
        super.init(style: .roundedFixed(cornerRadius: 5.0), styleColor: .gray, backgroundColor: .lightGray, borderColor: .black, borderWidth: 0.0)
        self.viewAppearance.styleColor = .clear
    }
}
