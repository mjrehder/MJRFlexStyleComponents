//
//  FlexLabel.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 18.09.16.
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

/// This class wraps a StyledLabel and adds features for placement, layout, etc.
@IBDesignable
open class FlexLabel: MJRFlexBaseControl {
    fileprivate lazy var _label = LabelFactory.defaultStyledLabel()
    
    open var label: StyledLabel {
        get {
            return _label
        }
    }
    
    open var labelAppearance: FlexLabelAppearance? {
        didSet {
            self.labelBackgroundColor = self.labelBackgroundColor ?? self.getLabelAppearance().backgroundColor
            self.style = self.style ?? self.getLabelAppearance().style
            self.applyStyle()
        }
    }
    /// The return of this is either the local labelAppearance or the getAppearance().labelAppearance.
    open func getLabelAppearance() -> FlexLabelAppearance {
        return self.labelAppearance ?? flexStyleAppearance.textAppearance
    }
    
    /// The background color. If nil the color will be clear color. Defaults to nil.
    @IBInspectable open var labelBackgroundColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The font of the label
    @IBInspectable open var labelFont: UIFont? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The text alignment of the label
    @IBInspectable open var labelTextAlignment: NSTextAlignment? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The text color.
    @IBInspectable open var labelTextColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The border color.
    @IBInspectable open var labelBorderColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The border width
    @IBInspectable open var labelBorderWidth: CGFloat? {
        didSet {
            self.applyStyle()
        }
    }
    
    override func applyStyle(_ style: ShapeStyle) {
        if self.label.superview == nil {
            self.addSubview(self.label)
        }
        self.label.style = style
        self.label.backgroundColor = styleColor ?? self.getLabelAppearance().styleColor
        self.label.borderColor = labelBorderColor ?? self.getLabelAppearance().borderColor
        self.label.borderWidth = labelBorderWidth ?? self.getLabelAppearance().borderWidth
        self.label.textColor = labelTextColor ?? self.getLabelAppearance().textColor
        self.label.font = labelFont ?? self.getLabelAppearance().textFont
        self.label.textAlignment = labelTextAlignment ?? self.getLabelAppearance().textAlignment
        
        self.label.frame = UIEdgeInsetsInsetRect(self.bounds, self.controlInsets ?? self.getLabelAppearance().insets)
    }
    
    func applyStyle() {
        self.applyStyle(self.style ?? self.getLabelAppearance().style)
    }
}
