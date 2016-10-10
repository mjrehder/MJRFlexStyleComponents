//
//  ImageShapeLayerFactory.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 04.10.2016.
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

public class ImageShapeLayerFactory {

    public static func createImageShapeInView(imageViewRect: CGRect, viewBounds: CGRect, image: UIImage?, viewStyle: ShapeStyle, imageStyle: ShapeStyle, imageFitting: FlexImageShapeFit) -> CALayer {
        let bgLayer = CALayer()
        bgLayer.frame = imageViewRect
        let clipRect = CGRectOffset(viewBounds, -imageViewRect.origin.x, -imageViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(viewStyle, bounds: clipRect, color: UIColor.blackColor())
        bgLayer.mask = maskShapeLayer
        
        if let img = image {
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: img, imageStyle: imageStyle, imageFitting: imageFitting)
            bgLayer.addSublayer(imgLayer)
        }
        
        return bgLayer
    }
    
    public static func createImageShape(imageViewRect: CGRect, image: UIImage, imageStyle: ShapeStyle, imageFitting: FlexImageShapeFit) -> CALayer {
        let imgLayer = CALayer()
        var imgRect = CGRect(origin: CGPointZero, size: imageViewRect.size)
        switch imageFitting {
        case .Center:
            let iSize = image.size
            let bgOffset = CGPointMake((imgRect.size.width - iSize.width) * 0.5, (imgRect.size.height - iSize.height) * 0.5)
            imgRect = CGRectMake(bgOffset.x, bgOffset.y, iSize.width, iSize.height)
        case .ScaleToFill:
            break
        case .ScaleToFit:
            let imageR = CGRect(origin: CGPointZero, size: image.size)
            imgRect = CGRectHelper.AspectFitRectInRect(imageR, rtarget: imgRect)
        }
        imgLayer.bounds = imgRect
        imgLayer.contents = image.CGImage
        imgLayer.position = CGPointMake(CGRectGetMidX(imgRect), CGRectGetMidY(imgRect))
        let maskPath = StyledShapeLayer.shapePathForStyle(imageStyle, bounds: imgRect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        imgLayer.mask = maskLayer
        
        return imgLayer
    }

}
