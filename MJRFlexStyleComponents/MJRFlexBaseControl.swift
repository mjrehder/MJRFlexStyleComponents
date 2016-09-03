//
//  MJRFlexBaseControl.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 03.08.16.
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

public class MJRFlexBaseControl: UIControl {
    var styleLayer = CAShapeLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Laying out Subviews
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutComponents()
    }
    
    // MARK: - Control Style
    
    /// The view's style. Default's to box.
    @IBInspectable public var style: ShapeStyle = .Box {
        didSet {
            self.applyStyle(self.style)
        }
    }
    
    /// The view’s background color.
    @IBInspectable public var styleColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
        }
    }
    
    /// The view's border color.
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
        }
    }
    
    /// The view's border width. Default's to 1.0
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.applyStyle(self.style)
        }
    }
    
    /// The view’s background color.
    override public var backgroundColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
        }
    }

    /// The controls background insets, also known as border margins. Defaults to UIEdgeInsetsZero
    @IBInspectable public var backgroundMargins: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.layoutComponents()
        }
    }
    
    // MARK: - Internal View
    
    func marginsForRect(rect: CGRect, margins: UIEdgeInsets) -> CGRect {
        return CGRectMake(rect.origin.x + margins.left, rect.origin.y + margins.top, rect.size.width - (margins.left + margins.right), rect.size.height - (margins.top + margins.bottom))
    }

    func layoutComponents() {
        self.applyStyle(self.style)
    }
    
    func applyStyle(style: ShapeStyle) {
        if self.styleLayer.superlayer == nil {
            self.layer.addSublayer(styleLayer)
        }
        
        let layerRect = self.marginsForRect(bounds, margins: backgroundMargins)
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clearColor()
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        
        // Add layer with border, if required
        if let borderColor = borderColor {
            let bLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: .clearColor(), borderColor: borderColor, borderWidth: borderWidth)
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        styleLayer = bgsLayer
        styleLayer.frame = layerRect
    }
}
