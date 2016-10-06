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
public class FlexLabel: UIControl {
    private lazy var _label = LabelFactory.defaultStyledLabel()
    
    public var label: StyledLabel {
        get {
            return _label
        }
    }
    
    public var appearance: FlexStyleAppearance? {
        didSet {
            self.setNeedsLayout()
        }
    }
    public func getAppearance() -> FlexStyleAppearance {
        return self.appearance ?? flexStyleAppearance
    }
    
    /// The style of the label
    @IBInspectable public var style: ShapeStyle? {
        didSet {
            self.applyStyle()
        }
    }
    // Convenience valid style getter
    public func getStyle() -> ShapeStyle {
        return self.style ?? self.getAppearance().style
    }
    
    /// The background color. If nil the color will be clear color. Defaults to nil.
    @IBInspectable public var labelBackgroundColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The font of the label
    @IBInspectable public var labelFont: UIFont? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The text alignment of the label
    @IBInspectable public var labelTextAlignment: NSTextAlignment? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The text color.
    @IBInspectable public var labelTextColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The border color.
    @IBInspectable public var labelBorderColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    /// The border width
    @IBInspectable public var labelBorderWidth: CGFloat? {
        didSet {
            self.applyStyle()
        }
    }
    
    public var labelInsets: UIEdgeInsets? {
        didSet {
            self.applyStyle()
        }
    }
    
    func applyStyle(style: ShapeStyle) {
        if self.label.superview == nil {
            self.addSubview(self.label)
        }
        self.label.style = style
        self.label.backgroundColor = self.labelBackgroundColor ?? .clearColor()
        self.label.borderColor = labelBorderColor ?? self.getAppearance().borderColor
        self.label.borderWidth = labelBorderWidth ?? self.getAppearance().borderWidth
        self.label.textColor = labelTextColor ?? UIColor.blackColor()
        self.label.font = labelFont
        self.label.textAlignment = labelTextAlignment ?? .Center
    }
    
    func applyStyle() {
        self.applyStyle(self.getStyle())
    }
}
