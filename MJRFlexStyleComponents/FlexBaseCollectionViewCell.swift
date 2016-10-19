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
    
    override public var cellAppearance: FlexStyleCollectionCellAppearance? {
        didSet {
            self.flexContentView?.flexViewAppearance = cellAppearance?.viewAppearance
            self.applyTextAppearance()
            self.refreshLayout()
        }
    }

    func applyTextAppearance() {
        if self.textLabel?.labelAppearance == nil {
            self.textLabel?.labelAppearance = self.getCellAppearance().textAppearance
        }
    }
    
    public override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexView(frame: baseRect)
        self.flexContentView?.flexViewAppearance = self.getCellAppearance().viewAppearance
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)

            // Just allocate and hide for now, in order to avoid re-creating this all the time
            self.textLabel = FlexLabel(frame: CGRectZero)
            if let tl = self.textLabel {
                self.applyTextAppearance()
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
            if item.contentInteractionWillSelectItem {
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
            }
            item.accessoryImageActionHandler?()
        }
    }
    
    public func imageViewTouched(recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            if item.contentInteractionWillSelectItem {
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
            }
            item.imageViewActionHandler?()
        }
    }
    
    public func layoutIconView(item: FlexBaseCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let icon = item.icon, iv = self.imageView {
            let appe = self.getCellAppearance()
            let iconInsets = appe.iconInsets
            let iconSize = appe.iconSize

            let imageViewRect = CGRect(origin: CGPointZero, size: iconSize)
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: appe.iconStyle, imageFitting: .ScaleToFit)
            
            iv.frame = CGRectMake(remainingCellArea.origin.x + iconInsets.left, remainingCellArea.origin.y + (remainingCellArea.size.height - iconSize.height) * 0.5, iconSize.width, iconSize.height)
            iv.layer.sublayers?.removeAll()
            iv.layer.addSublayer(imgLayer)
            iv.hidden = false
            let imageLayerTotalWidth = imageViewRect.size.width + iconInsets.left + iconInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: imageLayerTotalWidth * 0.5, dy: 0)
        }
        else {
            self.imageView?.hidden = true
        }
        return remainingCellArea
    }
    
    public func layoutAccessoryView(item: FlexBaseCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let aim = item.accessoryImage, av = self.accessoryView {
            let appe = self.getCellAppearance()
            let accessoryImageInsets = appe.accessoryImageInsets
            let accessoryImageSize = appe.accessoryImageSize
            
            let imageViewRect = CGRect(origin: CGPointZero, size: accessoryImageSize)
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: aim, imageStyle: appe.accessoryStyle, imageFitting: .ScaleToFit)
            
            av.frame = CGRectMake(remainingCellArea.origin.x + (remainingCellArea.size.width - (accessoryImageInsets.right + accessoryImageSize.width)), remainingCellArea.origin.y + (remainingCellArea.size.height - accessoryImageSize.height) * 0.5, accessoryImageSize.width, accessoryImageSize.height)
            av.layer.sublayers?.removeAll()
            av.layer.addSublayer(imgLayer)
            av.hidden = item.showAccessoryImageOnlyWhenSelected ? !self.selected : false
            let imageLayerTotalWidth = imageViewRect.size.width + accessoryImageInsets.left + accessoryImageInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -imageLayerTotalWidth*0.5, dy: 0)
        }
        else {
            self.accessoryView?.hidden = true
        }
        return remainingCellArea
    }
    
    public func layoutText(item: FlexBaseCollectionItem, area: CGRect) {
        if let text = item.text {
            let appe = self.getCellAppearance()
            let textRect =  UIEdgeInsetsInsetRect(area, appe.textAppearance.insets)
            self.textLabel?.frame = textRect
            self.textLabel?.hidden = false
            self.textLabel?.labelAppearance = appe.textAppearance
            self.textLabel?.label.attributedText = text
            self.textLabel?.labelAppearance = self.textLabel?.labelAppearance ?? appe.textAppearance
        }
        else {
            self.textLabel?.hidden = true
        }
    }
    
    public func applySelectionStyles(fcv: FlexView) {
        fcv.header.labelBackgroundColor = self.selected ? self.getCellAppearance().selectedBackgroundColor : self.getCellAppearance().viewAppearance.headerAppearance.backgroundColor
        fcv.styleColor = self.selected ? self.getCellAppearance().selectedStyleColor : self.getCellAppearance().styleColor
        fcv.borderColor = self.selected ? self.getCellAppearance().selectedBorderColor : self.getCellAppearance().borderColor
        fcv.borderWidth = self.selected ? self.getCellAppearance().selectedBorderWidth : self.getCellAppearance().borderWidth
    }
    
    override public func applyStyles() {
        super.applyStyles()
  
        if let item = self.item as? FlexBaseCollectionItem, fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            self.applySelectionStyles(fcv)
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            remainingCellArea = self.layoutAccessoryView(item, area: remainingCellArea)
            self.layoutText(item, area: remainingCellArea)
        }
    }
}
