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
    var imageView: UIView?
    var textLabel: FlexLabel?
    var accessoryView: UIView?

    public var flexContentView: FlexView?
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexView(frame: baseRect)
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)

            // Just allocate and hide for now, in order to avoid re-creating this all the time
            self.textLabel = FlexLabel(frame: CGRectZero)
            if let tl = self.textLabel {
                tl.hidden = true
                pcv.addSubview(tl)
            }
            
            self.accessoryView = UIView()
            if let av = self.accessoryView {
                av.hidden = true
                pcv.addSubview(av)
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.accessoryViewTouched(_:)))
                av.addGestureRecognizer(tapGest)
            }

            self.imageView = UIView()
            if let iv = self.imageView {
                iv.hidden = true
                pcv.addSubview(iv)
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTouched(_:)))
                iv.addGestureRecognizer(tapGest)
            }
}
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    public func cellTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    public func accessoryViewTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            item.accessoryImageActionHandler?()
        }
    }
    
    public func imageViewTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            item.imageViewActionHandler?()
        }
    }
    
    override func applyStyles() {
        super.applyStyles()
  
        let appe = self.getAppearance()
        if let item = self.item as? FlexBaseCollectionItem, fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            
            var remainingCellArea = fcv.getViewRect() //UIEdgeInsetsInsetRect(fcv.getViewRect(), ...)

            if let icon = item.icon, iv = self.imageView {
                let imageViewRect = CGRect(origin: CGPointZero, size: appe.cellIconSize)
                let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: appe.cellIconStyle, imageFitting: .ScaleToFit)

                iv.frame = CGRectMake(remainingCellArea.origin.x + appe.cellIconInsets.left, remainingCellArea.origin.y + (remainingCellArea.size.height - appe.cellIconSize.height) * 0.5, appe.cellIconSize.width, appe.cellIconSize.height)
                iv.layer.sublayers?.removeAll()
                iv.layer.addSublayer(imgLayer)
                iv.hidden = false
                let imageLayerTotalWidth = imageViewRect.size.width + appe.cellIconInsets.left + appe.cellIconInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: imageLayerTotalWidth * 0.5, dy: 0)
            }
            else {
                self.imageView?.hidden = true
            }

            if let aim = item.accessoryImage, av = self.accessoryView {
                let imageViewRect = CGRect(origin: CGPointZero, size: appe.cellAccessoryImageSize)
                let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: aim, imageStyle: appe.cellAccessoryStyle, imageFitting: .ScaleToFit)

                av.frame = CGRectMake(remainingCellArea.origin.x + (remainingCellArea.size.width - (appe.cellAccessoryImageInsets.right + appe.cellAccessoryImageSize.width)), remainingCellArea.origin.y + (remainingCellArea.size.height - appe.cellAccessoryImageSize.height) * 0.5, appe.cellAccessoryImageSize.width, appe.cellAccessoryImageSize.height)
                av.layer.sublayers?.removeAll()
                av.layer.addSublayer(imgLayer)
                av.hidden = false
                let imageLayerTotalWidth = imageViewRect.size.width + appe.cellAccessoryImageInsets.left + appe.cellAccessoryImageInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -imageLayerTotalWidth*0.5, dy: 0)
            }
            else {
                self.accessoryView?.hidden = true
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
