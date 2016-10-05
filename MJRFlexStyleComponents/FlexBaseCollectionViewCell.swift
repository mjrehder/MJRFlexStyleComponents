//
//  FlexBaseCollectionViewCell.swift
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

public class FlexBaseCollectionViewCell: FlexCollectionViewCell {
    var imageLayer: CALayer?
    var textLabel: StyledLabel?
    var accessoryLayer: CALayer?

    public var flexContentView: FlexView?
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexView(frame: baseRect)
        if let pcv = self.flexContentView {
            self.contentView.addSubview(pcv)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
/*
    public var cellStyle: ShapeStyle = .RoundedFixed(cornerRadius: 5.0)
    public var cellIconSize: CGSize = CGSizeMake(48, 48)
    public var cellIconInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellAccessoryImageSize: CGSize = CGSizeMake(24, 24)
    public var cellAccessoryImageInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellTitleInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellTitleTextColor = UIColor.whiteColor()
    public var cellTitleTextFont = UIFont.boldSystemFontOfSize(14.0)
    public var cellTitleAlignment: NSTextAlignment = .Center
    public var cellTextInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public var cellTextTextColor = UIColor.blackColor()
    public var cellTextTextFont = UIFont.boldSystemFontOfSize(16.0)
    public var cellTextAlignment: NSTextAlignment = .Left
*/
    override func applyStyles() {
        super.applyStyles()
  
        let appe = self.getAppearance()
        self.flexContentView?.style = appe.cellStyle
        self.flexContentView?.headerSize = appe.headerSize
        
        if let item = self.item as? FlexBaseCollectionItem {
            if let icon = item.icon {
                let imageViewRect = CGRectMake(0, 0, 50, 50) // TODO
                // TODO
                self.imageLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: .Rounded, imageFitting: .ScaleToFit)
            }
        }
    }
}
