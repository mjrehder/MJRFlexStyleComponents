//
//  StyledSliderItem.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 22.06.2017.
/*
 * Copyright 2017-present Martin Jacob Rehder.
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

open class StyledSliderItem: StyledLabel {
    var index = 0
    var backgroundIcon: UIImage?
    var sizeInfo: SliderItemSizeInfo?
    // Relative offset within the slider towards the boundaries in the principal direction. Centered in slider == 1, at the edge == 0
    var relativeEdgeOffset: CGFloat?

    fileprivate var backgroundShape = CALayer()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.backgroundShape.superlayer == nil {
            // Insert this layer above the styled label style and below the text label
            self.layer.insertSublayer(self.backgroundShape, at: 1)
        }
        
        let visibleBounds = self.labelBounds ?? self.bounds
        let bgLayer = CALayer()
        if let bgi = self.backgroundIcon {
            let iSize: CGSize
            if let si = self.sizeInfo {
                if si.autoAdjustIconSize {
                    switch si.iconSizingType {
                    case .relativeToSliderItem:
                        let minSize = CGSize(width: min(si.maxIconSize?.width ?? CGFloat.infinity, visibleBounds.size.width), height: min(si.maxIconSize?.height ?? CGFloat.infinity, visibleBounds.size.height))
                        let maxSize = UIEdgeInsetsInsetRect(CGRect(origin: visibleBounds.origin, size: minSize), si.iconInsetsForAutoSize).size
                        let ws = maxSize.width/bgi.size.width
                        let hs = maxSize.height/bgi.size.height
                        let scale = min( ws, hs)
                        iSize = CGSize(width: bgi.size.width * scale, height: bgi.size.height * scale)
                    case .relativeToSlider(let minSize):
                        let iMaxSize = CGSize(width: min(si.maxIconSize?.width ?? CGFloat.infinity, visibleBounds.size.width), height: min(si.maxIconSize?.height ?? CGFloat.infinity, visibleBounds.size.height))
                        let reo = self.relativeEdgeOffset ?? 1.0
                        let pSize = CGSize(width: iMaxSize.width * reo, height: iMaxSize.height * reo)
                        let iMinSize = CGSize(width: max(minSize.width, pSize.width), height: max(minSize.height, pSize.height))
                        let maxSize = UIEdgeInsetsInsetRect(CGRect(origin: visibleBounds.origin, size: iMinSize), si.iconInsetsForAutoSize).size
                        let ws = maxSize.width/bgi.size.width
                        let hs = maxSize.height/bgi.size.height
                        let scale = min( ws, hs)
                        iSize = CGSize(width: bgi.size.width * scale, height: bgi.size.height * scale)
                    }
                }
                else {
                    iSize = bgi.size
                }
            }
            else {
                iSize = bgi.size
            }
            let bgOffset = CGPoint(x: (visibleBounds.size.width - iSize.width) * 0.5, y: (visibleBounds.size.height - iSize.height) * 0.5)
            bgLayer.bounds = CGRect(x: bgOffset.x, y: bgOffset.y, width: iSize.width, height: iSize.height)
            bgLayer.position = CGPoint(x: visibleBounds.midX, y: visibleBounds.midY)
            bgLayer.contents = bgi.cgImage
            let maskPath = StyledShapeLayer.shapePathForStyle(style, bounds: bounds)
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            bgLayer.mask = maskLayer
        }
        self.layer.replaceSublayer(self.backgroundShape, with: bgLayer)
        self.backgroundShape = bgLayer
    }
}
