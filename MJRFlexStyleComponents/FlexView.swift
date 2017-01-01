//
//  MJRFlexView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 04.08.16.
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

public enum FlexViewHeaderPosition {
    case top
    case left
    case right
}

open class FlexView: FlexBaseControl {
    fileprivate var _header = FlexViewSupplementaryView()
    open var header: FlexViewSupplementaryView {
        get {
            return _header
        }
    }
    
    fileprivate var _footer = FlexViewSupplementaryView()
    open var footer: FlexViewSupplementaryView {
        get {
            return _footer
        }
    }
    
    var menus: [FlexViewMenu] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutComponents()
    }
    
    func initView() {
        if self.styleLayer.superlayer == nil {
            self.layer.insertSublayer(self.styleLayer, at: 0)
        }
    }
    
    /// The content view insets, also known as border margins.
    @IBInspectable open dynamic var contentViewMargins: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Header
    
    /// The position of the header. The footer, if used, is on the opposite end of the view.
    @IBInspectable open var headerPosition: FlexViewHeaderPosition = .top {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header text. Defaults to nil, which means no text.
    @IBInspectable open var headerText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header text. Defaults to nil, which means no text.
    @IBInspectable open dynamic var headerAttributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header size is either the height or the width of the header, depending on the header position.
    @IBInspectable open dynamic var headerSize: CGFloat = 18 {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// The header will be clipped to the background shape. Defaults to true.
    @IBInspectable open dynamic var headerClipToBackgroundShape: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    // MARK: - Footer
    
    /// The footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerAttributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer size is either the height or the width of the footer, depending on the footer position.
    @IBInspectable open dynamic var footerSize: CGFloat = 18 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer will be clipped to the background shape. Defaults to true.
    @IBInspectable open dynamic var footerClipToBackgroundShape: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    open func addMenu(_ menu: FlexViewMenu) {
        self.menus.append(menu)
        self.addSubview(menu.menu)
        layoutComponents()
    }
    
    open func removeMenu(_ menu: FlexViewMenu) {
        if let idx = self.menus.index(where: { (vmenu) -> Bool in
            menu.id == vmenu.id
        }) {
            self.menus.remove(at: idx)
            menu.menu.removeFromSuperview()
            layoutComponents()
        }
    }
    
    func hasHeaderText() -> Bool {
        return self.headerText != nil || self.headerAttributedText != nil
    }
    
    func hasFooterText() -> Bool {
        return self.footerText != nil || self.footerAttributedText != nil
    }
    
    open func getViewRect() -> CGRect {
        var heightReduce: CGFloat = 0
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        if self.hasHeaderText() {
            heightReduce += self.headerSize
            topOffset += self.headerSize
        }
        if self.hasFooterText() {
            bottomOffset += self.footerSize
            heightReduce += self.footerSize
        }
        let headerPos = self.headerPosition
        let margins = self.contentViewMargins
        switch headerPos {
        case .top:
            return UIEdgeInsetsInsetRect(CGRect(x: 0, y: topOffset, width: self.bounds.size.width, height: self.bounds.size.height - heightReduce), margins)
        case .left:
            return UIEdgeInsetsInsetRect(CGRect(x: topOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height), margins)
        case .right:
            return UIEdgeInsetsInsetRect(CGRect(x: bottomOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height), margins)
        }
    }
    
    // MARK: - Private Style

    func rectForHeader() -> CGRect {
        let headerPos = self.headerPosition
        let hSize = self.headerSize
        switch headerPos {
        case .top:
            return CGRect(x: 0, y: 0, width: self.bounds.size.width, height: hSize)
        case .left:
            return CGRect(x: 0, y: 0, width: hSize, height: self.bounds.size.height)
        case .right:
            return CGRect(x: self.bounds.size.width - hSize, y: 0, width: hSize, height: self.bounds.size.height)
        }
    }
    
    func rectForFooter() -> CGRect {
        let headerPos = self.headerPosition
        let fSize = self.footerSize
        switch headerPos {
        case .top:
            return CGRect(x: 0, y: self.bounds.size.height - fSize, width: self.bounds.size.width, height: fSize)
        case .left:
            return CGRect(x: self.bounds.size.width - fSize, y: 0, width: fSize, height: self.bounds.size.height)
        case .right:
            return CGRect(x: 0, y: 0, width: fSize, height: self.bounds.size.height)
        }
    }
    
    func getHeaderFooterRotation() -> CGAffineTransform {
        let headerPos = self.headerPosition
        switch headerPos {
        case .top:
            return CGAffineTransform(rotationAngle: 0)
        case .left:
            return CGAffineTransform(rotationAngle: -CGFloat(M_PI_2))
        case .right:
            return CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        }
    }
    
    override func layoutComponents() {
        super.layoutComponents()
        
        if self.hasHeaderText() {
            if self.header.superview == nil {
                self.addSubview(self.header)
            }
            self.header.frame = self.rectForHeader()
            let headerBounds = UIEdgeInsetsInsetRect(self.header.bounds, self.header.controlInsets)
            self.header.caption.frame = headerBounds
            self.header.caption.label.frame = headerBounds
            self.header.caption.label.transform = self.getHeaderFooterRotation()
            self.header.caption.label.frame = headerBounds
            if self.headerText != nil {
                self.header.caption.label.text = headerText
            }
            else {
                self.header.caption.label.attributedText = headerAttributedText
            }
        }
        else {
            self.header.removeFromSuperview()
        }
        
        if self.hasFooterText() {
            if self.footer.superview == nil {
                self.addSubview(self.footer)
            }
            self.footer.frame = self.rectForFooter()
            let footerBounds = UIEdgeInsetsInsetRect(self.footer.bounds, self.footer.controlInsets)
            self.footer.caption.frame = footerBounds
            self.footer.caption.label.frame = footerBounds
            self.footer.caption.label.transform = self.getHeaderFooterRotation()
            self.footer.caption.label.frame = footerBounds
            if self.footerText != nil {
                self.footer.caption.label.text = footerText
            }
            else {
                self.footer.caption.label.attributedText = footerAttributedText
            }
        }
        else {
            self.footer.removeFromSuperview()
        }
        
        for menu in self.menus {
            self.applyMenuLocationAndSize(menu)
        }
    }
    
    override func applyStyle(_ style: ShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clear
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        let style = self.getStyle()
        
        if self.hasHeaderText() {
            let headerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.header.getStyle(), shapeBounds: self.rectForHeader().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.header.styleColor ?? .clear, maskToBounds: self.headerClipToBackgroundShape)
            bgsLayer.addSublayer(headerShapeLayer)
        }
        
        if self.hasFooterText() {
            let footerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.footer.getStyle(), shapeBounds: self.rectForFooter().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.footer.styleColor ?? .clear, maskToBounds: self.footerClipToBackgroundShape)
            bgsLayer.addSublayer(footerShapeLayer)
        }

        // Add layer with border, if required
        if let bLayer = self.createBorderLayer(style, layerRect: layerRect) {
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        styleLayer = bgsLayer
        styleLayer.frame = layerRect
    }

    // MARK: - Menu Handling
    
    func applyMenuLocationAndSize(_ menu: FlexViewMenu) {
        // Make sure that the menu is on top of the subviews
        menu.menu.removeFromSuperview()
        self.addSubview(menu.menu)

        let headerPos = self.headerPosition
        menu.menu.direction = headerPos == .top ? .horizontal : . vertical
        menu.menu.menuItemGravity = headerPos == .top ? .normal : (headerPos == .left ? .right : .left)
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        var msize = menu.size
        var mpos = layerRect.origin
        switch menu.hPos {
        case .fill:
            let pw = menu.menu.direction.principalSize(layerRect.size)
            let s = menu.menu.direction.nonPrincipalSize(menu.menu.direction.getSize(msize))
            msize = menu.menu.direction.getSize(CGSize(width: pw, height: s))
        case .center:
            let pw = menu.menu.direction.principalSize(layerRect.size)
            let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
            let pp = (pw - pmw) * 0.5
            let npp = menu.menu.direction.nonPrincipalPosition(mpos)
            mpos = menu.menu.direction.getPosition(CGPoint(x: pp, y: npp))
            msize = menu.menu.direction.getSize(msize)
        case .right:
            if headerPos == .left {
                msize = menu.menu.direction.getSize(msize)
            }
            else {
                let pw = menu.menu.direction.principalSize(layerRect.size)
                let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
                let pp = pw - pmw
                let npp = menu.menu.direction.nonPrincipalPosition(mpos)
                mpos = menu.menu.direction.getPosition(CGPoint(x: pp, y: npp))
                msize = menu.menu.direction.getSize(msize)
            }
        case .left:
            if headerPos == .left {
                let pw = menu.menu.direction.principalSize(layerRect.size)
                let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
                let pp = pw - pmw
                let npp = menu.menu.direction.nonPrincipalPosition(mpos)
                mpos = menu.menu.direction.getPosition(CGPoint(x: pp, y: npp))
                msize = menu.menu.direction.getSize(msize)
            }
            else {
                msize = menu.menu.direction.getSize(msize)
            }
        }
        
        let npvp: CGFloat
        let hSize = self.headerSize
        let fSize = self.footerSize
        
        switch menu.vPos {
        case .top:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = headerPos == .right ? npw - (hSize + ms) : hSize
        case .bottom:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = headerPos == .right ? fSize : npw - (fSize + ms)
        case .header:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = headerPos == .right ? npw - fSize : 0
        case .footer:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = headerPos == .right ? 0 : npw - fSize
        }
        mpos = menu.menu.direction.getPosition(CGPoint(x: menu.menu.direction.principalPosition(mpos), y: npvp))
        menu.menu.frame = UIEdgeInsetsInsetRect(CGRect(x: mpos.x, y: mpos.y, width: msize.width, height: msize.height), menu.menu.controlInsets)
    }
}
