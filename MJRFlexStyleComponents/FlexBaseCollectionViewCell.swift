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
    var textLabel: FlexLabel?
    var accessoryLayer: CALayer?

    public var flexContentView: FlexView?
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexView(frame: baseRect)
        if let pcv = self.flexContentView {
            self.contentView.addSubview(pcv)

            // Just allocate and hide for now, in order to avoid re-creating this all the time
            self.textLabel = FlexLabel(frame: CGRectZero)
            if let tl = self.textLabel {
                tl.hidden = true
                pcv.addSubview(tl)
            }
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
        if let item = self.item as? FlexBaseCollectionItem, fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            
            var remainingCellArea = fcv.getViewRect() //UIEdgeInsetsInsetRect(fcv.getViewRect(), ...)

            if let icon = item.icon {
                let imageViewRect = CGRect(origin: CGPointZero, size: appe.cellIconSize)
                let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: appe.cellIconStyle, imageFitting: .ScaleToFit)
                imgLayer.frame = CGRectMake(remainingCellArea.origin.x + appe.cellIconInsets.left, remainingCellArea.origin.y + (remainingCellArea.size.height - appe.cellIconSize.height) * 0.5, appe.cellIconSize.width, appe.cellIconSize.height)
                
                if let il = self.imageLayer {
                    self.layer.replaceSublayer(il, with: imgLayer)
                }
                else {
                    self.layer.addSublayer(imgLayer)
                }
                self.imageLayer = imgLayer
                let imageLayerTotalWidth = imageViewRect.size.width + appe.cellIconInsets.left + appe.cellIconInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: imageLayerTotalWidth * 0.5, dy: 0)
            }

            if let aim = item.accessoryImage {
                let imageViewRect = CGRect(origin: CGPointZero, size: appe.cellAccessoryImageSize)
                let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: aim, imageStyle: appe.cellAccessoryStyle, imageFitting: .ScaleToFit)
                imgLayer.frame = CGRectMake(remainingCellArea.origin.x + (remainingCellArea.size.width - (appe.cellAccessoryImageInsets.right + appe.cellAccessoryImageSize.width)), remainingCellArea.origin.y + (remainingCellArea.size.height - appe.cellAccessoryImageSize.height) * 0.5, appe.cellAccessoryImageSize.width, appe.cellAccessoryImageSize.height)
                
                if let il = self.accessoryLayer {
                    self.layer.replaceSublayer(il, with: imgLayer)
                }
                else {
                    self.layer.addSublayer(imgLayer)
                }
                self.accessoryLayer = imgLayer
                let imageLayerTotalWidth = imageViewRect.size.width + appe.cellAccessoryImageInsets.left + appe.cellAccessoryImageInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -imageLayerTotalWidth*0.5, dy: 0)
            }

            if let text = item.text {
                let textRect =  UIEdgeInsetsInsetRect(remainingCellArea, appe.cellTextInsets)
                self.textLabel?.label.frame = textRect
                self.textLabel?.hidden = false
                self.textLabel?.appearance = appe
                self.textLabel?.labelTextAlignment = appe.cellTextAlignment
                self.textLabel?.label.attributedText = text
            }
            else {
                self.textLabel?.hidden = true
            }
        }
    }
}
