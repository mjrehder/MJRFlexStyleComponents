//
//  FlexImageCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 20.10.2016.
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

open class FlexImageCollectionViewCell: FlexBaseCollectionViewCell {
    fileprivate var backgroundShape = CALayer()
    
    open override func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        if let item = self.item as? FlexImageCollectionItem, let fcv = self.flexContentView {
            let controlInsets = item.controlInsets ?? self.controlInsets
            let imageRect =  UIEdgeInsetsInsetRect(area, controlInsets)

            if self.backgroundShape.superlayer != nil {
                self.backgroundShape.removeFromSuperlayer()
            }
            
            let bgLayer = ImageShapeLayerFactory.createImageShapeInView(imageRect, viewBounds: self.bounds, image: item.image, viewStyle: self.style.style, imageStyle: item.imageStyle.style, imageFitting: item.imageFit)
            
            fcv.layer.addSublayer(bgLayer)
            self.backgroundShape = bgLayer
        }
    }
}
