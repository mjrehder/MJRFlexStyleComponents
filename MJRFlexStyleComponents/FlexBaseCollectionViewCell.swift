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

open class FlexBaseCollectionViewCell: FlexCollectionViewCell {
    public var imageView: UIView?
    public var textLabel: FlexBaseCollectionViewCellTextLabel?
    public var detailTextLabel: FlexBaseCollectionViewCellDetailTextLabel?
    public var infoTextLabel: FlexBaseCollectionViewCellInfoTextLabel?
    public var auxTextLabel: FlexBaseCollectionViewCellAuxTextLabel?
    public var accessoryView: UIView?

    open var flexContentView: FlexCellView?

    open dynamic var controlInsets: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var controlSize: CGSize = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var imageViewInsets: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var imageViewSize: CGSize = CGSize(width: 64, height: 64) {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var imageViewStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var accessoryViewInsets: UIEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5) {
        didSet {
            self.setNeedsLayout()
        }
    }

    open dynamic var accessoryViewSize: CGSize = CGSize(width: 32, height: 32) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open dynamic var accessoryViewStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var imageViewFitting: FlexImageShapeFit = .scaleToFit {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open override func initialize() {
        super.initialize()
        let baseRect = self.bounds
        
        self.flexContentView = FlexCellView(frame: baseRect)
        if let pcv = self.flexContentView {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.cellTouched(_:)))
            pcv.addGestureRecognizer(tapGest)
            self.contentView.addSubview(pcv)

            // Just allocate and hide subviews for now, in order to avoid re-creating this all the time
            
            self.textLabel = self.createTextLabel(label: FlexBaseCollectionViewCellTextLabel(frame: .zero))
            self.detailTextLabel = self.createTextLabel(label: FlexBaseCollectionViewCellDetailTextLabel(frame: .zero))
            self.infoTextLabel = self.createTextLabel(label: FlexBaseCollectionViewCellInfoTextLabel(frame: .zero))
            self.auxTextLabel = self.createTextLabel(label: FlexBaseCollectionViewCellAuxTextLabel(frame: .zero))
            
            self.accessoryView = UIView()
            if let av = self.accessoryView {
                av.isHidden = true
                pcv.addSubview(av)
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.accessoryViewTouched(_:)))
                av.addGestureRecognizer(tapGest)
            }

            self.imageView = UIView()
            if let iv = self.imageView {
                iv.isHidden = true
                pcv.addSubview(iv)
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTouched(_:)))
                iv.addGestureRecognizer(tapGest)
            }
        }
    }

    open func cellTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
        }
    }
    
    open func accessoryViewTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            if item.contentInteractionWillSelectItem {
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
            }
            item.accessoryImageActionHandler?()
        }
    }
    
    open func imageViewTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            if item.contentInteractionWillSelectItem {
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item)
            }
            item.imageViewActionHandler?()
        }
    }
    
    /// This is the area that remains when the image view area and the accessory view area is subtracted from the total view area
    open func getControlArea() -> CGRect {
        if let item = self.item as? FlexBaseCollectionItem, let fcv = self.flexContentView {
            var remainingCellArea = fcv.getViewRect()
            if item.icon != nil {
                let iconInsets = self.imageViewInsets
                let iconSize = self.imageViewSize
                let imageViewRect = CGRect(origin: CGPoint.zero, size: iconSize)
                let imageLayerTotalWidth = imageViewRect.size.width + iconInsets.left + iconInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: imageLayerTotalWidth * 0.5, dy: 0)
            }
            if item.accessoryImage != nil {
                let accessoryImageInsets = self.accessoryViewInsets
                let accessoryImageSize = self.accessoryViewSize
                let imageViewRect = CGRect(origin: CGPoint.zero, size: accessoryImageSize)
                let imageLayerTotalWidth = imageViewRect.size.width + accessoryImageInsets.left + accessoryImageInsets.right
                remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -imageLayerTotalWidth*0.5, dy: 0)
            }
            if let s = item.controlSize {
                return CGRect(x: remainingCellArea.origin.x, y: remainingCellArea.origin.y, width: s.width, height: s.height)
            }
            if self.controlSize.width != 0 && self.controlSize.height != 0 {
                return CGRect(x: remainingCellArea.origin.x, y: remainingCellArea.origin.y, width: self.controlSize.width, height: self.controlSize.height)
            }
            return remainingCellArea
        }
        return .zero
    }
    
    open func layoutIconView(_ item: FlexBaseCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let icon = item.icon, let iv = self.imageView {
            let iconInsets = self.imageViewInsets
            let iconSize = self.imageViewSize
            
            let imageViewRect = CGRect(origin: CGPoint.zero, size: iconSize)
            let sizeFit = item.imageViewFitting ?? self.imageViewFitting
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: self.imageViewStyle.style, imageFitting: sizeFit)
            
            iv.frame = CGRect(x: remainingCellArea.origin.x + iconInsets.left, y: remainingCellArea.origin.y + (remainingCellArea.size.height - iconSize.height) * 0.5, width: iconSize.width, height: iconSize.height)
            iv.layer.sublayers?.removeAll()
            iv.layer.addSublayer(imgLayer)
            iv.isHidden = false
            let imageLayerTotalWidth = imageViewRect.size.width + iconInsets.left + iconInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: imageLayerTotalWidth * 0.5, dy: 0)
        }
        else {
            self.imageView?.isHidden = true
        }
        return remainingCellArea
    }
    
    open func layoutAccessoryView(_ item: FlexBaseCollectionItem, area: CGRect) -> CGRect {
        var remainingCellArea = area
        
        if let aim = item.accessoryImage, let av = self.accessoryView {
            let accessoryImageInsets = self.accessoryViewInsets
            let accessoryImageSize = self.accessoryViewSize
            
            let imageViewRect = CGRect(origin: CGPoint.zero, size: accessoryImageSize)
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: aim, imageStyle: self.accessoryViewStyle.style, imageFitting: .scaleToFit)
            
            av.frame = CGRect(x: remainingCellArea.origin.x + (remainingCellArea.size.width - (accessoryImageInsets.right + accessoryImageSize.width)), y: remainingCellArea.origin.y + (remainingCellArea.size.height - accessoryImageSize.height) * 0.5, width: accessoryImageSize.width, height: accessoryImageSize.height)
            av.layer.sublayers?.removeAll()
            av.layer.addSublayer(imgLayer)
            av.isHidden = item.showAccessoryImageOnlyWhenSelected ? !self.isSelected : false
            let imageLayerTotalWidth = imageViewRect.size.width + accessoryImageInsets.left + accessoryImageInsets.right
            remainingCellArea = remainingCellArea.insetBy(dx: imageLayerTotalWidth*0.5, dy: 0).offsetBy(dx: -imageLayerTotalWidth*0.5, dy: 0)
        }
        else {
            self.accessoryView?.isHidden = true
        }
        return remainingCellArea
    }
    
    open func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        if area.size.width < 0 || area.size.height < 0 {
            return
        }
        self.setupTextLabel(self.textLabel, text: item.text)
        self.setupTextLabel(self.detailTextLabel, text: item.detailText)
        self.setupTextLabel(self.infoTextLabel, text: item.infoText)
        self.setupTextLabel(self.auxTextLabel, text: item.auxText)
        
        if let ul = self.textLabel, let ll = self.detailTextLabel, let ur = self.infoTextLabel, let lr = self.auxTextLabel {
            FlexControlLayoutHelper.layoutFourLabelsInArea(ul, lowerLeft: ll, upperRight: ur, lowerRight: lr, area: area)
        }
    }
    
    func createTextLabel<T: FlexLabel>(label: T) -> T {
        if let fcv = self.flexContentView {
            label.isHidden = true
            fcv.addSubview(label)
        }
        return label
    }
    
    func setupTextLabel(_ label: FlexLabel?, text: NSAttributedString?) {
        if let label = label {
            if let aText = text {
                label.isHidden = false
                label.label.attributedText = aText
            }
            else {
                label.isHidden = true
            }
        }
    }
    
    open func applySelectionStyles(_ fcv: FlexView) {
        fcv.styleColor = self.isSelected ? self.selectedStyleColor : self.styleColor
        fcv.borderColor = self.isSelected ? self.selectedBorderColor : self.borderColor
        fcv.borderWidth = self.isSelected ? self.selectedBorderWidth : self.borderWidth
    }
    
    open override func assignBorderLayout() {
        // Intentionally left blank
    }
    
    override open func applyStyles() {
        super.applyStyles()
  
        if let item = self.item as? FlexBaseCollectionItem, let fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            fcv.footerAttributedText = item.subTitle
            if let hImage = item.headerImage {
                fcv.header.imageView.image = hImage
                fcv.header.imageView.isHidden = false
                fcv.header.imageViewPosition = item.headerImagePosition ?? fcv.header.imageViewPosition
                fcv.header.imageViewInsets = item.headerImageInsets ?? fcv.header.imageViewInsets
                
                if let cr = item.headerImageCornerRadius {
                    fcv.header.imageView.layer.cornerRadius = cr
                }
                if let mtb = item.headerImageMasksToBounds {
                    fcv.header.imageView.layer.masksToBounds = mtb
                }
                if let bw = item.headerImageBorderWidth {
                    fcv.header.imageView.layer.borderWidth = bw
                }
                if let bc = item.headerImageBorderColor {
                    fcv.header.imageView.layer.borderColor = bc.cgColor
                }
            }
            if let hp = item.headerPosition {
                fcv.headerPosition = hp
            }
            self.applySelectionStyles(fcv)
            var remainingCellArea = fcv.getViewRect()
            remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
            let _ = self.layoutAccessoryView(item, area: remainingCellArea)
            remainingCellArea = self.getControlArea()
            
            let controlInsets = item.controlInsets ?? self.controlInsets
            self.layoutControl(item, area: UIEdgeInsetsInsetRect(remainingCellArea, controlInsets))
        }
    }
}
