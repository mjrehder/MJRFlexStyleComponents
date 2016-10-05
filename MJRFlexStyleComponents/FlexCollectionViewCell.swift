//
//  FlexCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 23.09.16.
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

public class FlexCollectionViewCell: UICollectionViewCell {
    public var reference : String?
    
    var _item: FlexCollectionItem? = nil
    public var item: FlexCollectionItem? {
        get {
            return _item
        }
    }
    
    public var appearance: FlexStyleAppearance? {
        didSet {
            self.refreshLayout()
        }
    }
    public func getAppearance() -> FlexStyleAppearance {
        return self.appearance ?? flexStyleAppearance
    }
    
    public override var selected: Bool {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public func initialize() {
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshLayout()
    }
    
    public func refreshLayout() {
        self.assignBorderLayout()
        self.applyStyles()
    }
    
    func applyStyles() {
    }

    public func assignBorderLayout() {
        let appe = self.getAppearance()
        self.layer.borderColor = self.selected ? appe.selectedBorderColor.CGColor : appe.borderColor.CGColor
        self.layer.borderWidth = self.selected ? appe.selectedBorderWidth : appe.borderWidth
    }

}
