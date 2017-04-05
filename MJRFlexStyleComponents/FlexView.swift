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

open class FlexView: FlexBaseControl, UITextFieldDelegate {
    fileprivate var _header = FlexHeaderView()
    open var header: FlexHeaderView {
        get {
            return _header
        }
    }
    
    fileprivate var _footer = FlexFooterView()
    open var footer: FlexFooterView {
        get {
            return _footer
        }
    }
    
    fileprivate var topBarView: UIView?
    open private(set) var topBarActive: Bool = false

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

    @IBInspectable
    open var topBar: FlexViewTopBar? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    open dynamic var topBarHeight: CGFloat = 22 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The content view insets, also known as border margins.
    @IBInspectable open dynamic var contentViewMargins: UIEdgeInsets = .zero {
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
    
    @IBInspectable open var isHeaderTextEditable: Bool = false {
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
    @IBInspectable open var headerAttributedText: NSAttributedString? = nil {
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

    /// The sub header text. Defaults to nil, which means no text.
    @IBInspectable open var subHeaderText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The sub header text. Defaults to nil, which means no text.
    @IBInspectable open var subHeaderAttributedText: NSAttributedString? = nil {
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

    /// The secondary footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerSecondaryText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The secondary footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerSecondaryAttributedText: NSAttributedString? = nil {
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

    open var headerTextChanged: ((String) -> Void)?
    var headerEditor: UITextField?
    
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
    func getHeaderText() -> NSAttributedString {
        if let ht = self.headerText {
            return NSAttributedString(string: ht)
        }
        if let ahs = self.headerAttributedText {
            return ahs
        }
        return NSAttributedString()
    }
    
    func hasSubHeaderText() -> Bool {
        return self.subHeaderText != nil || self.subHeaderAttributedText != nil
    }
    func getSubHeaderText() -> NSAttributedString {
        if let ht = self.subHeaderText {
            return NSAttributedString(string: ht)
        }
        if let ahs = self.subHeaderAttributedText {
            return ahs
        }
        return NSAttributedString()
    }
    
    func hasFooterText() -> Bool {
        return self.footerText != nil || self.footerAttributedText != nil
    }
    func getFooterText() -> NSAttributedString {
        if let ft = self.footerText {
            return NSAttributedString(string: ft)
        }
        if let afs = self.footerAttributedText {
            return afs
        }
        return NSAttributedString()
    }
    
    func hasSecondaryFooterText() -> Bool {
        return self.footerSecondaryText != nil || self.footerSecondaryAttributedText != nil
    }
    func getSecondaryFooterText() -> NSAttributedString {
        if let ft = self.footerSecondaryText {
            return NSAttributedString(string: ft)
        }
        if let afs = self.footerSecondaryAttributedText {
            return afs
        }
        return NSAttributedString()
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
            if self.topBarActive {
                heightReduce += self.topBarHeight
                topOffset += self.topBarHeight
            }
            return UIEdgeInsetsInsetRect(CGRect(x: 0, y: topOffset, width: self.bounds.size.width, height: self.bounds.size.height - heightReduce), margins)
        case .left:
            return UIEdgeInsetsInsetRect(CGRect(x: topOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height), margins)
        case .right:
            return UIEdgeInsetsInsetRect(CGRect(x: bottomOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height), margins)
        }
    }
    
    // MARK: - Private Style

    open func rectForHeader() -> CGRect {
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
    
    open func rectForFooter() -> CGRect {
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
    
    open func getHeaderFooterRotation() -> CGAffineTransform {
        let headerPos = self.headerPosition
        switch headerPos {
        case .top:
            return CGAffineTransform(rotationAngle: 0)
        case .left:
            return CGAffineTransform(rotationAngle: -CGFloat(Double.pi / 2.0))
        case .right:
            return CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))
        }
    }
    
    open func getTopBarFrame() -> CGRect {
        var topOffset = self.contentViewMargins.top
        if self.hasHeaderText() {
            topOffset += self.headerSize
        }
        return CGRect(x: self.contentViewMargins.left, y: topOffset, width: self.bounds.size.width - (self.contentViewMargins.left + self.contentViewMargins.right), height: self.topBarHeight)
    }
    
    override open func layoutComponents() {
        super.layoutComponents()
        
        let tbr = self.getTopBarFrame()
        self.topBarView?.frame = tbr
        
        var rfh = self.rectForHeader()
        var rff = self.rectForFooter()
        for menu in self.menus {
            self.applyMenuLocationAndSize(menu)
            let mmf = menu.menu.frame
            if menu.hPos != .fill {
                if mmf.intersects(rfh) {
                    rfh = self.calculateWidthIntersectedFrame(oFrame: rfh, interFrame: mmf)
                }
                else if mmf.intersects(rff) {
                    rff = self.calculateWidthIntersectedFrame(oFrame: rff, interFrame: mmf)
                }
            }
        }
        
        if self.hasHeaderText() && self.hasSubHeaderText() {
            self.layoutSupplementaryView(self.header, frame: rfh)
            let ht = self.getHeaderText()
            let sht = self.getSubHeaderText()
            let stRect = UIEdgeInsetsInsetRect(self.header.bounds, self.header.controlInsets)
            let hth = ht.heightWithConstrainedWidth(stRect.width)
            let shth = sht.heightWithConstrainedWidth(stRect.width)
            let totalHeight = hth + shth
            let headerFrame = CGRect(x: stRect.minX, y: stRect.minY, width: stRect.width, height: (hth / totalHeight) * stRect.height)
            let subHeaderFrame = CGRect(x: stRect.minX, y: headerFrame.maxY, width: stRect.width, height: (shth / totalHeight) * stRect.height)
            self.layoutSupplementaryTextLabels(self.header.caption, frame: headerFrame, attributedText: self.getHeaderText())
            self.layoutSupplementaryTextLabels(self.header.subCaption, frame: subHeaderFrame, attributedText: self.getSubHeaderText())
        }
        else if self.hasHeaderText() {
            self.layoutSupplementaryView(self.header, frame: rfh)
            let stRect = UIEdgeInsetsInsetRect(self.header.bounds, self.header.controlInsets)
            self.layoutSupplementaryTextLabels(self.header.caption, frame: stRect, attributedText: self.getHeaderText())
            self.header.subCaption.label.attributedText = nil
        }
        else {
            self.header.removeFromSuperview()
        }
        
        if self.isHeaderTextEditable && self.header.isDescendant(of: self) && self.headerPosition == .top {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerTap(_:)))
            self.header.caption.label.addGestureRecognizer(tapGesture)
        }
        
        var hasFooterText = false
        if self.hasFooterText() {
            self.layoutSupplementaryView(self.footer, frame: rff)
            let stRect = UIEdgeInsetsInsetRect(self.footer.bounds, self.footer.controlInsets)
            self.layoutSupplementaryTextLabels(self.footer.caption, frame: stRect, attributedText: self.getFooterText())
            hasFooterText = true
            self.footer.caption.isHidden = false
        }
        else {
            self.footer.caption.isHidden = true
        }
        
        if self.hasSecondaryFooterText() {
            self.layoutSupplementaryView(self.footer, frame: rff)
            let stRect = UIEdgeInsetsInsetRect(self.footer.bounds, self.footer.controlInsets)
            self.layoutSupplementaryTextLabels(self.footer.secondaryCaption, frame: stRect, attributedText: self.getSecondaryFooterText())
            hasFooterText = true
            self.footer.secondaryCaption.isHidden = false
        }
        else {
            self.footer.secondaryCaption.isHidden = true
        }
        
        if !hasFooterText {
            self.footer.removeFromSuperview()
        }
        
        if let tb = self.topBar, let tbv = self.topBarView {
            if self.topBarActive {
                tb.frame = tbv.bounds
            }
        }
    }
    
    open func calculateWidthIntersectedFrame(oFrame: CGRect, interFrame: CGRect) -> CGRect {
        let hw = oFrame.midX
        if interFrame.origin.x < hw && interFrame.maxX > hw {
            if interFrame.origin.x < hw {
                let nx = interFrame.maxX
                return CGRect(x: nx, y: oFrame.origin.y, width: oFrame.size.width - (nx - oFrame.origin.x), height: oFrame.size.height)
            }
            else {
                let inters = oFrame.intersection(interFrame)
                let nw = oFrame.width - inters.width
                return CGRect(x: oFrame.origin.x, y: oFrame.origin.y, width: nw, height: oFrame.size.height)
            }
        }
        else {
            // If the menu is either to the left or the right, then still try to center the oFrame by insetting
            let inters = oFrame.intersection(interFrame)
            return oFrame.insetBy(dx: inters.width, dy: 0)
        }
    }
    
    open func layoutSupplementaryView(_ suplView: FlexViewSupplementaryView, frame: CGRect) {
        if suplView.superview == nil {
            self.addSubview(suplView)
        }
        suplView.frame = frame
    }

    open func layoutSupplementaryTextLabels(_ suplViewCaption: FlexLabel, frame: CGRect, attributedText: NSAttributedString?) {
        suplViewCaption.frame = frame
        suplViewCaption.label.frame = suplViewCaption.bounds
        suplViewCaption.label.transform = self.getHeaderFooterRotation()
        suplViewCaption.label.frame = suplViewCaption.bounds

        suplViewCaption.label.attributedText = attributedText
    }
    
    override func applyStyle(_ style: ShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clear
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        let style = self.getStyle()
        
        if self.hasHeaderText() {
            let hBounds = self.rectForHeader().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y)
            let headerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.header.getStyle(), shapeBounds: hBounds, shapeColor: self.header.styleColor ?? .clear, maskToBounds: self.headerClipToBackgroundShape)
            bgsLayer.addSublayer(headerShapeLayer)
            if let bLayer = self.header.createBorderLayer(self.header.getStyle(), layerRect: hBounds) {
                bgsLayer.addSublayer(bLayer)
            }
        }
        
        if self.hasFooterText() {
            let fBounds = self.rectForFooter().offsetBy(dx: -layerRect.origin.x, dy: -layerRect.origin.y)
            let footerShapeLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.footer.getStyle(), shapeBounds: fBounds, shapeColor: self.footer.styleColor ?? .clear, maskToBounds: self.footerClipToBackgroundShape)
            bgsLayer.addSublayer(footerShapeLayer)
            if let bLayer = self.footer.createBorderLayer(self.header.getStyle(), layerRect: fBounds) {
                bgsLayer.addSublayer(bLayer)
            }
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
    
    // MARK: - Top Bar
    
    open func showTopBar(topBarUpdateHandler: ((Void) -> Void)? = nil) {
        if self.topBarActive {
            return
        }
        self.addTopBar()
        self.topBar?.topBarUpdateHandler = topBarUpdateHandler
        self.topBarActive = true
        if let tbv = self.topBarView {
            tbv.isHidden = false
            let tbFrame = tbv.bounds
            if let tb = self.topBar {
                let topBarFrame = CGRect(origin: CGPoint(x: tbFrame.minX, y: -tbFrame.size.height), size: tbFrame.size)
                let tgtTopBarFrame = CGRect(origin: CGPoint(x: tbFrame.minX, y: 0), size: tbFrame.size)
                tb.frame = topBarFrame
                tb.alpha = 0
                UIView.animate(withDuration: 0.5, animations: {
                    tb.frame = tgtTopBarFrame
                    tb.alpha = 1
                })
            }
        }
        self.topBar?.topBarActivated?(true)
    }
    
    open func hideTopBar(completionHandler: ((Void) -> Void)? = nil) {
        if !self.topBarActive {
            return
        }
        if let tbv = self.topBarView {
            let tbFrame = tbv.bounds
            self.topBar?.frame = tbFrame
            self.topBar?.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar?.frame = CGRect(origin: CGPoint(x: tbFrame.minX, y: -tbFrame.size.height), size: tbFrame.size)
                self.topBar?.alpha = 0
            }) { _ in
                self.topBarActive = false
                tbv.isHidden = true
                self.topBar?.topBarActivated?(false)
                completionHandler?()
            }
        }
    }
    
    private func addTopBar() {
        if let tb = self.topBar {
            if self.topBarView == nil {
                self.topBarView = UIView(frame: self.getTopBarFrame())
                self.topBarView?.backgroundColor = .clear
                self.topBarView?.clipsToBounds = true
            }
            if let tbv = self.topBarView {
                if !tbv.isDescendant(of: self) {
                    self.addSubview(tbv)
                }
                if !tb.isDescendant(of: tbv) {
                    tbv.addSubview(tb)
                }
            }
            tb.topBarCancelHandler = {
                self.hideTopBar()
            }
        }
    }
    
    // MARK: - Header Editor
    
    func headerTap(_ sender: Any) {
        if headerEditor == nil {
            self.headerEditor = UITextField(frame: self.header.caption.frame)
            let headerText = self.getHeaderText()
            self.headerEditor?.text = headerText.string
            self.headerEditor?.textAlignment = self.header.caption.labelTextAlignment
            self.headerEditor?.backgroundColor = self.header.styleColor ?? .white
            self.headerEditor?.textColor = self.header.caption.labelTextColor ?? .black
            self.headerEditor?.font = self.header.caption.labelFont ?? UIFont.systemFont(ofSize: 14)
            self.headerEditor?.tintColor = self.header.caption.labelTextColor ?? .black
            self.header.addSubview(self.headerEditor!)
            self.headerEditor?.delegate = self
            self.headerEditor?.becomeFirstResponder()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.headerTextChanged?(text)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.headerEditor?.removeFromSuperview()
        self.headerEditor = nil
        return true
    }
}
