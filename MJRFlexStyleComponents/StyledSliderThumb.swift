//
//  StyledSliderThumb.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 10.07.16.
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

public class StyledSliderThumb: StyledLabel {
    var snappingBehavior = SnappingThumbBehaviour(item: nil, snapToPoint: CGPointZero)
    var behaviour: StyledSliderThumbBehaviour = .Freeform
    var index = 0
    var backgroundIcon: UIImage?
    
    private var backgroundShape = CALayer()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.backgroundShape.superlayer == nil {
            // Insert this layer above the styled label style and below the text label
            self.layer.insertSublayer(self.backgroundShape, atIndex: 1)
        }
        
        let bgLayer = CALayer()
        if let bgi = self.backgroundIcon {
            let iSize = bgi.size
            let bgOffset = CGPointMake((self.bounds.size.width - iSize.width) * 0.5, (self.bounds.size.height - iSize.height) * 0.5)
            bgLayer.bounds = CGRectMake(bgOffset.x, bgOffset.y, iSize.width, iSize.height)
            bgLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            bgLayer.contents = bgi.CGImage
            let maskPath = StyledShapeLayer.shapePathForStyle(style, bounds: bounds)
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            bgLayer.mask = maskLayer
        }
        self.layer.replaceSublayer(self.backgroundShape, with: bgLayer)
        self.backgroundShape = bgLayer
    }
}
