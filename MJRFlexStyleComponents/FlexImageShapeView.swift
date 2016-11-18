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
    case center
    case scaleToFill
    case scaleToFit
}

open class FlexImageShapeView: FlexView {
    fileprivate var backgroundShape = CALayer()
    fileprivate var imageShape = CALayer()
    
    open var image: UIImage? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var backgroundImageFit: FlexImageShapeFit = .scaleToFit {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var imageStyle: ShapeStyle = .box {
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupImageView()
    }
    
    func setupImageView() {
        let imageViewRect = self.getViewRect()
        
        if self.backgroundShape.superlayer != nil {
            self.backgroundShape.removeFromSuperlayer()
        }

        let bgLayer = ImageShapeLayerFactory.createImageShapeInView(imageViewRect, viewBounds: self.bounds, image: self.image, viewStyle: self.getStyle(), imageStyle: self.imageStyle, imageFitting: self.backgroundImageFit)
        
        self.styleLayer.insertSublayer(bgLayer, at: 0)
        self.backgroundShape = bgLayer
    }
}
