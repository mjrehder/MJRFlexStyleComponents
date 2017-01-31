//
//  FlexBaseControl.swift
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

open class FlexBaseControl: FlexBaseStylingControl {
    var styleLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Laying out Subviews
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutComponents()
    }
    
    // MARK: - Internal View
    
    func marginsForRect(_ rect: CGRect, margins: UIEdgeInsets) -> CGRect {
        return CGRect(x: rect.origin.x + margins.left, y: rect.origin.y + margins.top, width: rect.size.width - (margins.left + margins.right), height: rect.size.height - (margins.top + margins.bottom))
    }

    func layoutComponents() {
        self.applyStyle(self.getStyle())
    }
    
    func applyStyle(_ style: ShapeStyle) {
        if self.styleLayer.superlayer == nil {
            self.layer.addSublayer(styleLayer)
        }
        
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clear
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        
        // Add layer with border, if required
        if let bLayer = self.createBorderLayer(style, layerRect: layerRect) {
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        styleLayer = bgsLayer
        styleLayer.frame = layerRect
    }
}
