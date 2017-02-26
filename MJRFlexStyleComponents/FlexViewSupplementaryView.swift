//
//  FlexViewSupplementaryView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 29.12.2016.
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

open class FlexViewSupplementaryView: FlexBaseStylingControl {
    fileprivate var _caption = FlexPrimaryLabel()
    open var caption: FlexPrimaryLabel {
        get {
            return _caption
        }
    }
    fileprivate var _subCaption = FlexSubPrimaryLabel()
    open var subCaption: FlexSubPrimaryLabel {
        get {
            return _subCaption
        }
    }
    fileprivate var _secondaryCaption = FlexSecondaryLabel()
    open var secondaryCaption: FlexSecondaryLabel {
        get {
            return _secondaryCaption
        }
    }
    
    fileprivate var _imageView = UIImageView()
    open var imageView: UIImageView {
        get {
            return _imageView
        }
    }
    
    open dynamic var imageViewPosition: NSTextAlignment = .left {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var imageViewInsets: UIEdgeInsets = .zero {
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
        self.addSubview(self.caption)
        self.addSubview(self.subCaption)
        self.addSubview(self.secondaryCaption)
        self.imageView.isHidden = true
        self.addSubview(self.imageView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.imageView.isHidden {
            if let imgSize = self.imageView.image?.size {
                let totalRect = UIEdgeInsetsInsetRect(self.bounds, self.imageViewInsets)
                let xOffset: CGFloat
                switch self.imageViewPosition {
                case .center:
                    xOffset = totalRect.origin.x + (totalRect.size.width - imgSize.width) * 0.5
                case .right:
                    xOffset = (totalRect.origin.x + totalRect.size.width) - imgSize.width
                default:
                    xOffset = totalRect.origin.x
                }
                let yOffset = totalRect.origin.y + (totalRect.size.height - imgSize.height) * 0.5
                imageView.frame = CGRect(x: xOffset, y: yOffset, width: imgSize.width, height: imgSize.height)
            }
        }
    }
}
