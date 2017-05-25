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

open class ImageShapeLayerFactory {

    open static func createImageShapeInView(_ imageViewRect: CGRect, viewBounds: CGRect, image: UIImage?, viewStyle: ShapeStyle, imageStyle: ShapeStyle, imageFitting: FlexImageShapeFit, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) -> CALayer {
        let bgLayer = CALayer()
        bgLayer.frame = imageViewRect
        let clipRect = viewBounds.offsetBy(dx: -imageViewRect.origin.x, dy: -imageViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(viewStyle, bounds: clipRect, color: UIColor.black)
        bgLayer.mask = maskShapeLayer
        
        if let img = image {
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: img, imageStyle: imageStyle, imageFitting: imageFitting)
            
            if let bw = borderWidth, bw > 0 && borderColor != nil {
                let bLayer = StyledShapeLayer.createShape(imageStyle, bounds: imgLayer.bounds.insetBy(dx: bw * 0.5, dy: bw * 0.5), color: .clear, borderColor: borderColor ?? .clear, borderWidth: bw)
                imgLayer.addSublayer(bLayer)
            }
            bgLayer.addSublayer(imgLayer)
        }
        
        return bgLayer
    }
    
    open static func createImageShape(_ imageViewRect: CGRect, image: UIImage, imageStyle: ShapeStyle, imageFitting: FlexImageShapeFit) -> CALayer {
        let imgLayer = CALayer()
        var imgRect = CGRect(origin: CGPoint.zero, size: imageViewRect.size)
        switch imageFitting {
        case .center:
            let iSize = image.size
            let bgOffset = CGPoint(x: (imgRect.size.width - iSize.width) * 0.5, y: (imgRect.size.height - iSize.height) * 0.5)
            imgRect = CGRect(x: bgOffset.x, y: bgOffset.y, width: iSize.width, height: iSize.height)
        case .scaleToFill:
            break
        case .scaleToFit:
            let imageR = CGRect(origin: CGPoint.zero, size: image.size)
            imgRect = CGRectHelper.AspectFitRectInRect(imageR, rtarget: imgRect)
        }
        imgLayer.bounds = imgRect
        imgLayer.contents = image.cgImage
        imgLayer.position = CGPoint(x: imgRect.midX, y: imgRect.midY)
        let maskPath = StyledShapeLayer.shapePathForStyle(imageStyle, bounds: imgRect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        imgLayer.mask = maskLayer
        
        return imgLayer
    }

}
