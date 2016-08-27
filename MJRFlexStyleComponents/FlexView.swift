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
import SnappingStepper

public enum FlexViewHeaderPosition {
    case Top
    case Left
    case Right
}

public class FlexView: MJRFlexBaseControl {
    var headerLabel: StyledLabel?
    var footerLabel: StyledLabel?
    
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
    
    private func initView() {
        if self.styleLayer.superlayer == nil {
            self.layer.insertSublayer(self.styleLayer, atIndex: 0)
        }
    }
    
    
    /// The position of the header. The footer, if used, is on the opposite end of the view. Defaults to top.
    @IBInspectable public var headerPosition: FlexViewHeaderPosition = .Top {
        didSet {
            layoutComponents()
        }
    }
    
    // MARK: - Header
    
    /// The header text. Defaults to nil, which means no text.
    @IBInspectable public var headerText: String? = nil {
        didSet {
            layoutComponents()
        }
    }

    /// The header size is either the height or the width of the header, depending on the header position. Defaults to 18.
    @IBInspectable public var headerSize: CGFloat = 18.0 {
        didSet {
            layoutComponents()
        }
    }
    
    /// The headers background colors. If nil the header color will be clear color. Defaults to nil.
    @IBInspectable public var headerBackgroundColor: UIColor? {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The font of the header labels
    @IBInspectable public var headerFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The text alignment of the header label
    @IBInspectable public var headerTextAlignment: NSTextAlignment = .Center {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The headers text colors. Default's to black
    @IBInspectable public var headerTextColor: UIColor = .blackColor() {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    @IBInspectable public var headerStyle: ShapeStyle = .Box {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The headers border color.
    @IBInspectable public var headerBorderColor: UIColor? {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The headers border width. Default's to 1.0
    @IBInspectable public var headerBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applyHeaderStyle(headerStyle)
        }
    }
    
    /// The header will be clipped to the background shape. Defaults to true.
    @IBInspectable public var headerClipToBackgroundShape: Bool = true {
        didSet {
            layoutComponents()
        }
    }

    // MARK: - Footer
    
    /// The footer text. Defaults to nil, which means no text.
    @IBInspectable public var footerText: String? = nil {
        didSet {
            layoutComponents()
        }
    }
    
    /// The footer size is either the height or the width of the footer, depending on the footer position. Defaults to 18.
    @IBInspectable public var footerSize: CGFloat = 18.0 {
        didSet {
            layoutComponents()
        }
    }
    
    /// The footers background color. If nil the footer color will be clear color. Defaults to nil.
    @IBInspectable public var footerBackgroundColor: UIColor? {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    /// The font of the footer label
    @IBInspectable public var footerFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    /// The text alignment of the footer label
    @IBInspectable public var footerTextAlignment: NSTextAlignment = .Center {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    /// The footers text colors. Default's to black
    @IBInspectable public var footerTextColor: UIColor = .blackColor() {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    @IBInspectable public var footerStyle: ShapeStyle = .Box {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    /// The footers border color.
    @IBInspectable public var footerBorderColor: UIColor? {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }
    
    /// The footers border width. Default's to 1.0
    @IBInspectable public var footerBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applyFooterStyle(footerStyle)
        }
    }

    /// The footer will be clipped to the background shape. Defaults to true.
    @IBInspectable public var footerClipToBackgroundShape: Bool = true {
        didSet {
            layoutComponents()
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
    
    // MARK: - Private Style
    
    func applyHeaderStyle(style: ShapeStyle) {
        self.headerLabel?.style = style
        self.headerLabel?.backgroundColor = .clearColor()
        self.headerLabel?.borderColor = headerBorderColor
        self.headerLabel?.borderWidth = headerBorderWidth
        self.headerLabel?.textColor = headerTextColor
        self.headerLabel?.font = headerFont
        self.headerLabel?.textAlignment = headerTextAlignment
    }
    
    func applyFooterStyle(style: ShapeStyle) {
        self.footerLabel?.style = style
        self.footerLabel?.backgroundColor = .clearColor()
        self.footerLabel?.borderColor = footerBorderColor
        self.footerLabel?.borderWidth = footerBorderWidth
        self.footerLabel?.textColor = footerTextColor
        self.footerLabel?.font = footerFont
        self.footerLabel?.textAlignment = footerTextAlignment
    }

    func rectForHeader() -> CGRect {
        switch self.headerPosition {
        case .Top:
            return CGRectMake(0, 0, self.bounds.size.width, self.headerSize)
        case .Left:
            return CGRectMake(0, 0, self.headerSize, self.bounds.size.height)
        case .Right:
            return CGRectMake(self.bounds.size.width - self.headerSize, 0, self.headerSize, self.bounds.size.height)
        }
    }
    
    func rectForFooter() -> CGRect {
        switch self.headerPosition {
        case .Top:
            return CGRectMake(0, self.bounds.size.height - self.footerSize, self.bounds.size.width, self.footerSize)
        case .Left:
            return CGRectMake(self.bounds.size.width - self.footerSize, 0, self.footerSize, self.bounds.size.height)
        case .Right:
            return CGRectMake(0, 0, self.footerSize, self.bounds.size.height)
        }
    }
    
    func getHeaderFooterRotation() -> CGAffineTransform {
        switch self.headerPosition {
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
        
        if let headerText = self.headerText {
            if self.headerLabel == nil {
                self.headerLabel = LabelFactory.defaultStyledLabel()
                self.addSubview(self.headerLabel!)
            }
            self.headerLabel?.frame = self.rectForHeader()
            self.headerLabel?.transform = self.getHeaderFooterRotation()
            self.headerLabel?.frame = self.rectForHeader()
            self.headerLabel?.text = headerText
            applyHeaderStyle(headerStyle)
        }
        else {
            self.headerLabel?.removeFromSuperview()
            self.headerLabel = nil
        }
        
        if let footerText = self.footerText {
            if self.footerLabel == nil {
                self.footerLabel = LabelFactory.defaultStyledLabel()
                self.addSubview(self.footerLabel!)
            }
            self.footerLabel?.frame = self.rectForFooter()
            self.footerLabel?.transform = self.getHeaderFooterRotation()
            self.footerLabel?.frame = self.rectForFooter()
            self.footerLabel?.text = footerText
            applyFooterStyle(footerStyle)
        }
        else {
            self.footerLabel?.removeFromSuperview()
            self.footerLabel = nil
        }
        
        for menu in self.menus {
            self.applyMenuLocationAndSize(menu)
        }
    }
    
    override func applyStyle(style: FlexShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clearColor()
        let layerRect = self.marginsForRect(bounds, margins: backgroundMargins)
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        
        if self.headerText != nil {
            let headerShapeLayer = StyledShapeLayer.createShape(self.style, bounds: layerRect, shapeStyle: self.headerStyle, shapeBounds: self.rectForHeader().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.headerBackgroundColor ?? .clearColor(), maskToBounds: self.headerClipToBackgroundShape)
            bgsLayer.addSublayer(headerShapeLayer)
        }
        
        if self.footerText != nil {
            let footerShapeLayer = StyledShapeLayer.createShape(self.style, bounds: layerRect, shapeStyle: self.footerStyle, shapeBounds: self.rectForFooter().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y), shapeColor: self.footerBackgroundColor ?? .clearColor(), maskToBounds: self.footerClipToBackgroundShape)
            bgsLayer.addSublayer(footerShapeLayer)
        }

        // Add layer with border, if required
        if let borderColor = borderColor {
            let bLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: .clearColor(), borderColor: borderColor, borderWidth: borderWidth)
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
        menu.menu.direction = self.headerPosition == .Top ? .Horizontal : . Vertical
        menu.menu.menuItemGravity = self.headerPosition == .Top ? .Normal : (self.headerPosition == .Left ? .Right : .Left)
        let layerRect = self.marginsForRect(bounds, margins: backgroundMargins)
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
            if self.headerPosition == .Left {
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
            if self.headerPosition == .Left {
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
        switch menu.vPos {
        case .Top:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = self.headerPosition == .Right ? npw - (self.headerSize + ms) : self.headerSize
        case .Bottom:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            let ms = menu.menu.direction.nonPrincipalSize(msize)
            npvp = self.headerPosition == .Right ? self.footerSize : npw - (self.footerSize + ms)
        case .Header:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = self.headerPosition == .Right ? npw - self.footerSize : 0
        case .Footer:
            let npw = menu.menu.direction.nonPrincipalSize(layerRect.size)
            npvp = self.headerPosition == .Right ? 0 : npw - self.footerSize
        }
        mpos = menu.menu.direction.getPosition(CGPointMake(menu.menu.direction.principalPosition(mpos), npvp))
        menu.menu.frame = CGRectMake(mpos.x, mpos.y, msize.width, msize.height)
    }
}
