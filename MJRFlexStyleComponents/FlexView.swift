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
    case Top
    case Left
    case Right
}

public class FlexView: MJRFlexBaseControl {
    private var _headerLabel = FlexLabel()
    public var header: FlexLabel {
        get {
            return _headerLabel
        }
    }
    
    private var _footerLabel = FlexLabel()
    public var footer: FlexLabel {
        get {
            return _footerLabel
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutComponents()
    }
    
    func initView() {
        if self.styleLayer.superlayer == nil {
            self.layer.insertSublayer(self.styleLayer, atIndex: 0)
        }
    }
    
    public var flexViewAppearance: FlexViewAppearance? {
        didSet {
            self.setNeedsLayout()
        }
    }
    public func getFlexViewAppearance() -> FlexViewAppearance {
        return self.flexViewAppearance ?? flexStyleAppearance.viewAppearance
    }
    
    /// The content view insets, also known as border margins.
    @IBInspectable public var contentViewMargins: UIEdgeInsets? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Header
    
    /// The position of the header. The footer, if used, is on the opposite end of the view.
    @IBInspectable public var headerPosition: FlexViewHeaderPosition? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header text. Defaults to nil, which means no text.
    @IBInspectable public var headerText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header text. Defaults to nil, which means no text.
    @IBInspectable public var headerAttributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The header size is either the height or the width of the header, depending on the header position.
    @IBInspectable public var headerSize: CGFloat? {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// The header will be clipped to the background shape. Defaults to true.
    @IBInspectable public var headerClipToBackgroundShape: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    // MARK: - Footer
    
    /// The footer text. Defaults to nil, which means no text.
    @IBInspectable public var footerText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer text. Defaults to nil, which means no text.
    @IBInspectable public var footerAttributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer size is either the height or the width of the footer, depending on the footer position.
    @IBInspectable public var footerSize: CGFloat? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The footer will be clipped to the background shape. Defaults to true.
    @IBInspectable public var footerClipToBackgroundShape: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    public func addMenu(menu: FlexViewMenu) {
        self.menus.append(menu)
        self.addSubview(menu.menu)
        layoutComponents()
    }
    
    public func removeMenu(menu: FlexViewMenu) {
        if let idx = self.menus.indexOf({ (vmenu) -> Bool in
            menu.id == vmenu.id
        }) {
            self.menus.removeAtIndex(idx)
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
    
    public func getViewRect() -> CGRect {
        let appe = self.getFlexViewAppearance()
        var heightReduce: CGFloat = 0
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        if self.hasHeaderText() {
            heightReduce += self.headerSize ?? appe.headerAppearance.size
            topOffset += self.headerSize ?? appe.headerAppearance.size
        }
        if self.hasFooterText() {
            bottomOffset += self.footerSize ?? appe.footerAppearance.size
            heightReduce += self.footerSize ?? appe.footerAppearance.size
        }
        let headerPos = self.headerPosition ?? appe.headerPosition
        let margins = self.contentViewMargins ?? appe.contentInsets
        switch headerPos {
        case .Top:
            return UIEdgeInsetsInsetRect(CGRectMake(0, topOffset, self.bounds.size.width, self.bounds.size.height - heightReduce), margins)
        case .Left:
            return UIEdgeInsetsInsetRect(CGRectMake(topOffset, 0, self.bounds.size.width - heightReduce, self.bounds.size.height), margins)
        case .Right:
            return UIEdgeInsetsInsetRect(CGRectMake(bottomOffset, 0, self.bounds.size.width - heightReduce, self.bounds.size.height), margins)
        }
    }
    
    // MARK: - Private Style

    func rectForHeader() -> CGRect {
        let headerPos = self.headerPosition ?? self.getFlexViewAppearance().headerPosition
        let hSize = self.headerSize ?? self.getFlexViewAppearance().headerAppearance.size
        switch headerPos {
        case .Top:
            return CGRectMake(0, 0, self.bounds.size.width, hSize)
        case .Left:
            return CGRectMake(0, 0, hSize, self.bounds.size.height)
        case .Right:
            return CGRectMake(self.bounds.size.width - hSize, 0, hSize, self.bounds.size.height)
        }
    }
    
    func rectForFooter() -> CGRect {
        let headerPos = self.headerPosition ?? self.getFlexViewAppearance().headerPosition
        let fSize = self.footerSize ?? self.getFlexViewAppearance().footerAppearance.size
        switch headerPos {
        case .Top:
            return CGRectMake(0, self.bounds.size.height - fSize, self.bounds.size.width, fSize)
        case .Left:
            return CGRectMake(self.bounds.size.width - fSize, 0, fSize, self.bounds.size.height)
        case .Right:
            return CGRectMake(0, 0, fSize, self.bounds.size.height)
        }
    }
    
    func getHeaderFooterRotation() -> CGAffineTransform {
        let headerPos = self.headerPosition ?? self.getFlexViewAppearance().headerPosition
        switch headerPos {
        case .Top:
            return CGAffineTransformMakeRotation(0)
        case .Left:
            return CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
        case .Right:
            return CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }
    }
    
    override func layoutComponents() {
        super.layoutComponents()
        
        if self.hasHeaderText() {
            if self.header.superview == nil {
                self.addSubview(self.header)
            }
            self.header.frame = self.rectForHeader()
            let headerBounds = UIEdgeInsetsInsetRect(self.header.bounds, self.header.controlInsets ?? self.getFlexViewAppearance().headerAppearance.insets)
            self.header.label.frame = headerBounds
            self.header.label.transform = self.getHeaderFooterRotation()
            self.header.label.frame = headerBounds
            if self.headerText != nil {
                self.header.label.text = headerText
            }
            else {
                self.header.label.attributedText = headerAttributedText
            }
            self.header.labelAppearance = self.header.labelAppearance ?? self.getFlexViewAppearance().headerAppearance
        }
        else {
            self.header.removeFromSuperview()
        }
        
        if self.hasFooterText() {
            if self.footer.superview == nil {
                self.addSubview(self.footer)
            }
            self.footer.frame = self.rectForFooter()
            let footerBounds = UIEdgeInsetsInsetRect(self.footer.bounds, self.footer.controlInsets ?? self.getFlexViewAppearance().footerAppearance.insets)
            self.footer.label.frame = footerBounds
            self.footer.label.transform = self.getHeaderFooterRotation()
            self.footer.label.frame = footerBounds
            if self.footerText != nil {
                self.footer.label.text = footerText
            }
            else {
                self.footer.label.attributedText = footerAttributedText
            }
            self.footer.labelAppearance = self.footer.labelAppearance ?? self.getFlexViewAppearance().footerAppearance
        }
        else {
            self.footer.removeFromSuperview()
        }
        
        for menu in self.menus {
            self.applyMenuLocationAndSize(menu)
        }
    }
    
    override func applyStyle(style: ShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? self.getFlexViewAppearance().styleColor
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets ?? self.getFlexViewAppearance().backgroundInsets)
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        let style = self.getStyle()
        
        if self.hasHeaderText() {
            let headerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.header.getStyle(), shapeBounds: self.rectForHeader().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.header.labelBackgroundColor ?? .clearColor(), maskToBounds: self.headerClipToBackgroundShape)
            bgsLayer.addSublayer(headerShapeLayer)
        }
        
        if self.hasFooterText() {
            let footerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.footer.getStyle(), shapeBounds: self.rectForFooter().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.footer.labelBackgroundColor ?? .clearColor(), maskToBounds: self.footerClipToBackgroundShape)
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
    
    func applyMenuLocationAndSize(menu: FlexViewMenu) {
        // Make sure that the menu is on top of the subviews
        menu.menu.removeFromSuperview()
        self.addSubview(menu.menu)

        let headerPos = self.headerPosition ?? self.getFlexViewAppearance().headerPosition
        menu.menu.direction = headerPos == .Top ? .Horizontal : . Vertical
        menu.menu.menuItemGravity = headerPos == .Top ? .Normal : (headerPos == .Left ? .Right : .Left)
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets ?? self.getFlexViewAppearance().backgroundInsets)
        var msize = menu.size
        var mpos = layerRect.origin
        switch menu.hPos {
        case .Fill:
            let pw = menu.menu.direction.principalSize(layerRect.size)
            let s = menu.menu.direction.nonPrincipalSize(menu.menu.direction.getSize(msize))
            msize = menu.menu.direction.getSize(CGSizeMake(pw, s))
        case .Center:
            let pw = menu.menu.direction.principalSize(layerRect.size)
            let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
            let pp = (pw - pmw) * 0.5
            let npp = menu.menu.direction.nonPrincipalPosition(mpos)
            mpos = menu.menu.direction.getPosition(CGPointMake(pp, npp))
            msize = menu.menu.direction.getSize(msize)
        case .Right:
            if headerPos == .Left {
                msize = menu.menu.direction.getSize(msize)
            }
            else {
                let pw = menu.menu.direction.principalSize(layerRect.size)
                let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
                let pp = pw - pmw
                let npp = menu.menu.direction.nonPrincipalPosition(mpos)
                mpos = menu.menu.direction.getPosition(CGPointMake(pp, npp))
                msize = menu.menu.direction.getSize(msize)
            }
        case .Left:
            if headerPos == .Left {
                let pw = menu.menu.direction.principalSize(layerRect.size)
                let pmw = menu.menu.direction.principalSize(menu.menu.direction.getSize(msize))
                let pp = pw - pmw
                let npp = menu.menu.direction.nonPrincipalPosition(mpos)
                mpos = menu.menu.direction.getPosition(CGPointMake(pp, npp))
                msize = menu.menu.direction.getSize(msize)
            }
            else {
                msize = menu.menu.direction.getSize(msize)
            }
        }
        
        let npvp: CGFloat
        let hSize = self.headerSize ?? self.getFlexViewAppearance().headerAppearance.size
        let fSize = self.footerSize ?? self.getFlexViewAppearance().footerAppearance.size
        
        switch menu.vPos {
        case .Top:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = headerPos == .Right ? npw - (hSize + ms) : hSize
        case .Bottom:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = headerPos == .Right ? fSize : npw - (fSize + ms)
        case .Header:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = headerPos == .Right ? npw - fSize : 0
        case .Footer:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = headerPos == .Right ? 0 : npw - fSize
        }
        mpos = menu.menu.direction.getPosition(CGPointMake(menu.menu.direction.principalPosition(mpos), npvp))
        menu.menu.frame = CGRectMake(mpos.x, mpos.y, msize.width, msize.height)
    }
}
