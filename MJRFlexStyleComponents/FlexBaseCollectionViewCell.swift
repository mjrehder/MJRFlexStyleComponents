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
    
    @objc open dynamic var controlInsets: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var controlSize: CGSize = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var imageViewInsets: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var imageViewSize: CGSize = CGSize(width: 64, height: 64) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var imageViewStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var accessoryViewInsets: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 5) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var accessoryViewSize: CGSize = CGSize(width: 32, height: 32) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var accessoryViewStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
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
    
    @objc open func cellTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            let relPos = self.getRelPosFromTapGesture(recognizer)
            self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
        }
    }
    
    @objc open func accessoryViewTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            if item.contentInteractionWillSelectItem {
                let relPos = self.getRelPosFromTapGesture(recognizer)
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
            }
            item.accessoryImageActionHandler?()
        }
    }
    
    @objc open func imageViewTouched(_ recognizer: UITapGestureRecognizer) {
        if let item = self.item as? FlexBaseCollectionItem {
            if item.contentInteractionWillSelectItem {
                let relPos = self.getRelPosFromTapGesture(recognizer)
                self.flexCellTouchDelegate?.onFlexCollectionViewCellTouched(item, xRelPos: relPos.x, yRelPos: relPos.y)
            }
            item.imageViewActionHandler?()
        }
    }
    
    /// This is the rect for placing base controls. Normally equals the getViewRect(). Override to change default.
    open func getBaseViewRect() -> CGRect {
        return self.getViewRect()
    }
    
    /// This is the total rect inside the FlexCellView
    open func getViewRect() -> CGRect {
        if let fcv = self.flexContentView {
            return fcv.getViewRect()
        }
        return self.bounds
    }
    
    /// This is the area that remains when the image view area and the accessory view area are subtracted from the total view area
    open func getControlArea() -> CGRect {
        if let item = self.item as? FlexBaseCollectionItem {
            var remainingCellArea = self.getBaseViewRect()
            if item.icon != nil || item.placeholderIcon != nil {
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
        
        if let icon = self.getIcon(item), let iv = self.imageView {
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
    
    open func layoutIconifiedIconView(_ item: FlexBaseCollectionItem, area: CGRect) {
        if let icon = self.getIcon(item), let iv = self.imageView {
            let iconSize = self.imageViewSize
            let imageViewRect = CGRect(origin: CGPoint.zero, size: iconSize)
            let sizeFit = item.imageViewFitting ?? self.imageViewFitting
            let imgLayer = ImageShapeLayerFactory.createImageShape(imageViewRect, image: icon, imageStyle: self.imageViewStyle.style, imageFitting: sizeFit)
            
            let xo = area.origin.x + (area.size.width - iconSize.width) * 0.5
            let yo = area.origin.y + (area.size.height - iconSize.height) * 0.5
            
            iv.frame = CGRect(x: xo, y: yo, width: iconSize.width, height: iconSize.height)
            iv.layer.sublayers?.removeAll()
            iv.layer.addSublayer(imgLayer)
            iv.isHidden = false
        }
        else {
            self.imageView?.isHidden = true
        }
    }
    
    open func getIcon(_ item: FlexBaseCollectionItem) -> UIImage? {
        if let icon = item.icon {
            return icon
        }
        if let lip = item.imageViewLazyImageProvider {
            DispatchQueue.main.async {
                if let icon = lip(item.reference) {
                    item.icon = icon
                    self.applyStyles()
                }
            }
        }
        if let cbip = item.imageViewCallbackImageProvider {
            cbip.provideImage(forReference: item.reference) { icon in
                DispatchQueue.main.async {
                    if let icon = icon {
                        item.icon = icon
                        self.applyStyles()
                    }
                }
            }
        }
        if let placeholder = item.placeholderIcon {
            return placeholder
        }
        return nil
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
    
    open override func refreshLayout() {
        self.flexContentView?.frame = self.bounds
        super.refreshLayout()
    }
    
    func isDisplayModeNormal() -> Bool {
        switch self.displayMode {
        case .normal:
            return true
        case .iconified(_):
            return false
        }
    }
    
    open func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        if area.size.width < 0 || area.size.height < 0 {
            return
        }
        
        self.setupAllTextLabels(item)
        if let ul = self.textLabel, let ll = self.detailTextLabel, let ur = self.infoTextLabel, let lr = self.auxTextLabel {
            FlexControlLayoutHelper.layoutFourLabelsInArea(ul, lowerLeft: ll, upperRight: ur, lowerRight: lr, area: area)
        }
    }
    
    func setupAllTextLabels(_ item: FlexBaseCollectionItem) {
        self.setupTextLabel(self.textLabel, text: item.text)
        self.setupTextLabel(self.detailTextLabel, text: item.detailText)
        self.setupTextLabel(self.infoTextLabel, text: item.infoText)
        self.setupTextLabel(self.auxTextLabel, text: item.auxText)
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
            if let aText = text, self.isDisplayModeNormal() {
                label.isHidden = false
                label.label.attributedText = aText
            }
            else {
                label.isHidden = true
                label.label.attributedText = nil
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
    
    open func applyContentViewInfo() {
        if let item = self.item as? FlexBaseCollectionItem, let fcv = self.flexContentView {
            fcv.headerAttributedText = item.title
            fcv.subHeaderAttributedText = item.underTitle
            if self.isDisplayModeNormal() {
                fcv.footerAttributedText = item.subTitle
                if let hp = item.headerPosition {
                    fcv.headerPosition = hp
                }
            }
            else {
                fcv.footerAttributedText = item.subTitle ?? item.text
                if self.forceHeaderTopWhenIconifiedDisplayMode {
                    fcv.headerPosition = .top
                }
                else if let hp = item.headerPosition {
                    fcv.headerPosition = hp
                }
            }
            fcv.footerSecondaryAttributedText = item.secondarySubTitle
            self.applyHeaderImage(fcv: fcv, item: item)
            self.applySelectionStyles(fcv)
        }
    }
    
    override open func applyStyles() {
        self.applyContentViewInfo()
        if let item = self.item as? FlexBaseCollectionItem {
            switch self.displayMode {
            case .normal:
                var remainingCellArea = self.getBaseViewRect()
                remainingCellArea = self.layoutIconView(item, area: remainingCellArea)
                let _ = self.layoutAccessoryView(item, area: remainingCellArea)
                remainingCellArea = self.getControlArea()
                
                let controlInsets = item.controlInsets ?? self.controlInsets
                self.layoutControl(item, area: remainingCellArea.inset(by: controlInsets))
            case .iconified(_):
                self.accessoryView?.isHidden = true
                self.setupAllTextLabels(item)
                self.layoutIconifiedIconView(item, area: self.getBaseViewRect())
            }
        }
        super.applyStyles()
    }
    
    open func applyHeaderImage(fcv: FlexCellView, item: FlexBaseCollectionItem) {
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
    }
}
