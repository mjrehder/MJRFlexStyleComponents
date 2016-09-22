//
//  FlexImageView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 28.08.16.
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

@IBDesignable
public class FlexImageView: FlexView {
    private var _imageView: UIImageView?
    
    public var imageView: UIImageView {
        get {
            return _imageView!
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
        self._imageView = UIImageView()
        self.addSubview(self._imageView!)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setupImageView()
    }
    
    func setupImageView() {
        let imageViewRect = self.getViewRect()
        self.imageView.frame = imageViewRect

        let clipRect = CGRectOffset(self.bounds, -imageViewRect.origin.x, -imageViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(self.style, bounds: clipRect, color: UIColor.blackColor())
        
        self.imageView.layer.mask = maskShapeLayer
    }
}
