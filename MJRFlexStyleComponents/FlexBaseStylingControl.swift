//
//  FlexBaseStylingControl.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 28.12.2016.
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

open class FlexBaseStylingControl: UIControl {
    open var styleLayer = CALayer()
    open var controlStyler: FlexControlStyler?
    
    /// The view's style.
    @IBInspectable open dynamic var style: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.setNeedsLayout()
            style.styleChangeHandler = {
                newStyle in
                self.setNeedsLayout()
            }
        }
    }
    
    /// Convenience for getting a valid style
    open func getStyle() -> ShapeStyle {
        return self.style.style
    }
    
    /// The view’s background color.
    @IBInspectable open dynamic var styleColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The view’s background color gradient. If set, this overrides the styleColor
    @objc open dynamic var styleColorGradient: CAGradientLayer? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The view's border color.
    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The view's border width.
    @IBInspectable open dynamic var borderWidth: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The view’s background color.
    override open dynamic var backgroundColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The controls background insets. These are margins for the inner background.
    @IBInspectable open dynamic var backgroundInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The controls insets, also known as border margins. This value is not used by this control, but by the embedding control
    @IBInspectable open dynamic var controlInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open var layerBorders: [StyledShapeLayerBorder] = [] {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    open func initView() {
        self.layer.addSublayer(self.styleLayer)
    }
    
    func createBorderLayer(_ style: ShapeStyle, layerRect: CGRect, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) -> CALayer? {
        let bw = borderWidth ?? self.borderWidth
        let bc = borderColor ?? self.borderColor
        if bw > 0 && bc != nil {
            let bLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: .clear, borderColor: bc ?? .clear, borderWidth: bw)
            return bLayer
        }
        return nil
    }

    open func getBackgroundLayer(_ style: ShapeStyle) -> CALayer {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clear
        let layerRect = CGRect(origin: .zero, size: UIEdgeInsetsInsetRect(bounds, backgroundInsets).size)
        let bgsLayer: CALayer
        
        if let gradientLayer = self.styleColorGradient {
            let maskLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: .black)
            let gradLayer = CAGradientLayer()
            gradLayer.locations = gradientLayer.locations
            gradLayer.colors = gradientLayer.colors
            gradLayer.startPoint = gradientLayer.startPoint
            gradLayer.endPoint = gradientLayer.endPoint
            gradLayer.type = gradientLayer.type
            bgsLayer = gradLayer
            bgsLayer.mask = maskLayer
        }
        else {
            bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        }
        return bgsLayer
    }

    open func applyStyle(_ style: ShapeStyle) {
        if self.styleLayer.superlayer == nil {
            self.layer.addSublayer(styleLayer)
        }
        
        let layerRect = CGRect(origin: .zero, size: UIEdgeInsetsInsetRect(bounds, backgroundInsets).size)
        let bgsLayer = self.getBackgroundLayer(style)
        
        // Add layer with border, if required
        if let bLayer = self.createBorderLayer(style, layerRect: layerRect) {
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        styleLayer = bgsLayer
        styleLayer.frame = bounds.offsetBy(dx: backgroundInsets.left, dy: backgroundInsets.top)
        
        for lBorder in self.layerBorders {
            lBorder.apply(toLayer: styleLayer)
        }
        
        self.controlStyler?.applyStyle(toControl: self)
    }

}
