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
    
    open override func initView() {
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
    
    /// Insets for header and footer. Note that when using header positions other than top, then the corresponding view element insets are used, ie. the insets are not 'rotated'
    @IBInspectable open var viewElementsInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Header
    
    /// The position of the header. The footer, if used, is on the opposite end of the view.
    open var headerPosition: FlexViewHeaderPosition = .top {
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
    
    /// The sub footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerSubText: String? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The sub footer text. Defaults to nil, which means no text.
    @IBInspectable open var footerSubAttributedText: NSAttributedString? = nil {
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
    
    /// The header and footer will be adapted to menus in the header or footer. Defaults to true.
    @IBInspectable open dynamic var headerFooterAdaptToMenu: Bool = true {
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
        if let idx = self.menus.firstIndex(where: { (vmenu) -> Bool in
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
    
    func hasSubFooterText() -> Bool {
        return self.footerSubText != nil || self.footerSubAttributedText != nil
    }
    func getSubFooterText() -> NSAttributedString {
        if let ft = self.footerSubText {
            return NSAttributedString(string: ft)
        }
        if let afs = self.footerSubAttributedText {
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
            return CGRect(x: 0, y: topOffset, width: self.bounds.size.width, height: self.bounds.size.height - heightReduce).inset(by: margins)
        case .left:
            return CGRect(x: topOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height).inset(by: margins)
        case .right:
            return CGRect(x: bottomOffset, y: 0, width: self.bounds.size.width - heightReduce, height: self.bounds.size.height).inset(by: margins)
        }
    }
    
    // MARK: - Private Style
    
    open func rectForHeader() -> CGRect {
        let headerPos = self.headerPosition
        let hSize = self.headerSize
        let vBounds = self.bounds.inset(by: self.viewElementsInsets)
        switch headerPos {
        case .top:
            return CGRect(x: vBounds.minX, y: vBounds.minY, width: vBounds.size.width, height: hSize)
        case .left:
            return CGRect(x: vBounds.minX, y: vBounds.minY, width: hSize, height: vBounds.height)
        case .right:
            return CGRect(x: vBounds.minX + vBounds.width - hSize, y: vBounds.minY, width: hSize, height: vBounds.height)
        }
    }
    
    open func rectForFooter() -> CGRect {
        let headerPos = self.headerPosition
        let fSize = self.footerSize
        let vBounds = self.bounds.inset(by: self.viewElementsInsets)
        switch headerPos {
        case .top:
            return CGRect(x: vBounds.minX, y: vBounds.minY + vBounds.height - fSize, width: vBounds.width, height: fSize)
        case .left:
            return CGRect(x: vBounds.minX + vBounds.width - fSize, y: vBounds.minY, width: fSize, height: vBounds.height)
        case .right:
            return CGRect(x: vBounds.minX, y: vBounds.minY, width: fSize, height: vBounds.height)
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
        let rfh = self.rectForHeader()
        var tbf = rfh
        tbf.size = CGSize(width: rfh.width, height: self.topBarHeight)
        return tbf.offsetBy(dx: 0, dy: rfh.height)
    }
    
    override open func layoutComponents() {
        super.layoutComponents()
        
        let tbr = self.getTopBarFrame()
        self.topBarView?.frame = tbr
        
        var rfh = self.rectForHeader()
        var rff = self.rectForFooter()
        for menu in self.menus {
            self.applyMenuLocationAndSize(menu)
            
            if self.headerFooterAdaptToMenu {
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
        }
        
        if self.hasHeaderText() && self.hasSubHeaderText() {
            let hr = self.rectForHeader()
            self.layoutSupplementaryView(self.header, frame: hr)
            let ht = self.getHeaderText()
            let sht = self.getSubHeaderText()
            let hb = rfh.offsetBy(dx: -hr.origin.x, dy: -hr.origin.y)
            let stRect = hb.inset(by: self.header.controlInsets)
            let hth = ht.heightWithConstrainedWidth(stRect.width)
            let shth = sht.heightWithConstrainedWidth(stRect.width)
            let totalHeight = hth + shth
            let headerFrame = CGRect(x: stRect.minX, y: stRect.minY, width: stRect.width, height: (hth / totalHeight) * stRect.height)
            let subHeaderFrame = CGRect(x: stRect.minX, y: headerFrame.maxY, width: stRect.width, height: (shth / totalHeight) * stRect.height)
            self.layoutSupplementaryTextLabels(self.header.caption, frame: headerFrame, attributedText: self.getHeaderText())
            self.layoutSupplementaryTextLabels(self.header.subCaption, frame: subHeaderFrame, attributedText: self.getSubHeaderText())
        }
        else if self.hasHeaderText() {
            let hr = self.rectForHeader()
            self.layoutSupplementaryView(self.header, frame: hr)
            let hb = rfh.offsetBy(dx: -hr.origin.x, dy: -hr.origin.y)
            let stRect = hb.inset(by: self.header.controlInsets)
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
        if self.hasFooterText() && self.hasSubFooterText() {
            let fr = self.rectForFooter()
            self.layoutSupplementaryView(self.footer, frame: fr)
            let ht = self.getFooterText()
            let sht = self.getSubFooterText()
            let fb = rff.offsetBy(dx: -fr.origin.x, dy: -fr.origin.y)
            let stRect = fb.inset(by: self.footer.controlInsets)
            let hth = ht.heightWithConstrainedWidth(stRect.width)
            let shth = sht.heightWithConstrainedWidth(stRect.width)
            let totalHeight = hth + shth
            let footerFrame = CGRect(x: stRect.minX, y: stRect.minY, width: stRect.width, height: (hth / totalHeight) * stRect.height)
            let subFooterFrame = CGRect(x: stRect.minX, y: footerFrame.maxY, width: stRect.width, height: (shth / totalHeight) * stRect.height)
            self.layoutSupplementaryTextLabels(self.footer.caption, frame: footerFrame, attributedText: self.getFooterText())
            self.layoutSupplementaryTextLabels(self.footer.subCaption, frame: subFooterFrame, attributedText: self.getSubFooterText())
            hasFooterText = true
            self.footer.caption.isHidden = false
            self.footer.subCaption.isHidden = false
        }
        else if self.hasFooterText() {
            let fr = self.rectForFooter()
            self.layoutSupplementaryView(self.footer, frame: fr)
            let fb = rff.offsetBy(dx: -fr.origin.x, dy: -fr.origin.y)
            let stRect = fb.inset(by: self.footer.controlInsets)
            self.layoutSupplementaryTextLabels(self.footer.caption, frame: stRect, attributedText: self.getFooterText())
            hasFooterText = true
            self.footer.caption.isHidden = false
            self.footer.subCaption.isHidden = true
        }
        
        if self.hasSecondaryFooterText() {
            let fr = self.rectForFooter()
            self.layoutSupplementaryView(self.footer, frame: fr)
            let fb = rff.offsetBy(dx: -fr.origin.x, dy: -fr.origin.y)
            let stRect = fb.inset(by: self.footer.controlInsets)
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
        suplViewCaption.applyStyle()
    }
    
    override open func applyStyle(_ style: ShapeStyle) {
        super.applyStyle(style)
        
        if self.hasHeaderText() {
            self.header.applyStyle()
            if self.headerClipToBackgroundShape {
                self.applyMaskToSupplementaryView(self.header, inSupplementaryRect: self.rectForHeader())
            }
        }
        
        if self.hasFooterText() {
            self.footer.applyStyle()
            if self.footerClipToBackgroundShape {
                self.applyMaskToSupplementaryView(self.footer, inSupplementaryRect: self.rectForFooter())
            }
        }
    }
    
    func applyMaskToSupplementaryView(_ suppView: FlexViewSupplementaryView, inSupplementaryRect suppRect: CGRect) {
        let layerRect = bounds.inset(by: backgroundInsets)
        let maskShape = CAShapeLayer()
        let path = StyledShapeLayer.shapePathForStyle(self.getStyle(), bounds: layerRect)
        maskShape.path = path.cgPath
        let bb = layerRect.offsetBy(dx: -suppRect.origin.x, dy: -suppRect.origin.y)
        maskShape.frame = bb
        suppView.styleLayer.mask = maskShape
    }
    
    // MARK: - Menu Handling
    
    func applyMenuLocationAndSize(_ menu: FlexViewMenu) {
        // Make sure that the menu is on top of the subviews
        menu.menu.removeFromSuperview()
        self.addSubview(menu.menu)
        
        let headerPos = self.headerPosition
        menu.menu.direction = headerPos == .top ? .horizontal : . vertical
        menu.menu.menuItemGravity = headerPos == .top ? .normal : (headerPos == .left ? .right : .left)
        let layerRect = bounds.inset(by: self.backgroundInsets).inset(by: self.viewElementsInsets)
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
        let iOffset: CGPoint
        
        switch headerPos {
        case .right:
            iOffset = CGPoint(x: 0, y: 0)
        case .left:
            iOffset = CGPoint(x: self.viewElementsInsets.left, y: 0)
        case .top:
            iOffset = CGPoint(x: 0, y: self.viewElementsInsets.top)
        }
        
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
        menu.menu.frame = CGRect(x: mpos.x + iOffset.x, y: mpos.y + iOffset.y, width: msize.width, height: msize.height).inset(by: menu.menu.controlInsets)
    }
    
    // MARK: - Top Bar
    
    open func showTopBar(topBarUpdateHandler: (() -> Void)? = nil) {
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
    
    open func hideTopBar(completionHandler: (() -> Void)? = nil) {
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
    
    @objc func headerTap(_ sender: Any) {
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
