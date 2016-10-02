//
//  FlexImageShapeView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 02/10/2016.
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

public enum FlexImageShapeFit {
    case Center
    case ScaleToFill
    case ScaleToFit
}

public class FlexImageShapeView: FlexView {
    private var backgroundShape = CALayer()
    private var imageShape = CALayer()
    
    public var image: UIImage? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var backgroundImageFit: FlexImageShapeFit = .ScaleToFit {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var imageStyle: ShapeStyle = .Box {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    override func initView() {
        super.initView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setupImageView()
    }
    
    func setupImageView() {
        let imageViewRect = self.getViewRect()
        
        if self.backgroundShape.superlayer != nil {
            self.backgroundShape.removeFromSuperlayer()
        }

        let bgLayer = CALayer()
        bgLayer.frame = imageViewRect
        let clipRect = CGRectOffset(self.bounds, -imageViewRect.origin.x, -imageViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(self.style, bounds: clipRect, color: UIColor.blackColor())
        bgLayer.mask = maskShapeLayer

        if let bgi = self.image {
            let imgLayer = CALayer()
            var imgRect = CGRect(origin: CGPointZero, size: imageViewRect.size)
            switch self.backgroundImageFit {
            case .Center:
                let iSize = bgi.size
                let bgOffset = CGPointMake((imgRect.size.width - iSize.width) * 0.5, (imgRect.size.height - iSize.height) * 0.5)
                imgRect = CGRectMake(bgOffset.x, bgOffset.y, iSize.width, iSize.height)
            case .ScaleToFill:
                break
            case .ScaleToFit:
                let imageR = CGRect(origin: CGPointZero, size: bgi.size)
                imgRect = CGRectHelper.AspectFitRectInRect(imageR, rtarget: imgRect)
            }
            imgLayer.bounds = imgRect
            imgLayer.contents = bgi.CGImage
            imgLayer.position = CGPointMake(CGRectGetMidX(imgRect), CGRectGetMidY(imgRect))
            let maskPath = StyledShapeLayer.shapePathForStyle(self.imageStyle, bounds: imgRect)
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            imgLayer.mask = maskLayer
            bgLayer.addSublayer(imgLayer)
        }
        
        self.styleLayer.insertSublayer(bgLayer, atIndex: 0)
        self.backgroundShape = bgLayer
    }
}
