//
//  FlexCardViewCollectionViewCell.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 12.02.2017.
/*
 * Copyright 2017-present Martin Jacob Rehder.
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

/// This is a base class for Card Layout Cells. Override and initialize the body view with a concrete Flex Component
open class FlexCardViewCollectionViewCell: FlexBaseCollectionViewCell {
    open var bodyView: FlexBaseControl?
    
    @objc open dynamic var cardHeaderHeight: CGFloat = 64 {
        didSet {
            self.setNeedsLayout()
        }
    }

    open override func layoutControl(_ item: FlexBaseCollectionItem, area: CGRect) {
        super.layoutControl(item, area: area)
        self.bodyView?.frame = self.getCardViewRect()
    }

    open func getCardViewRect() -> CGRect {
        let bRect = self.getBaseViewRect()
        let vRect = self.getViewRect()
        let bvInsets = self.bodyView?.controlInsets ?? .zero
        return UIEdgeInsetsInsetRect(CGRect(x: vRect.origin.x, y: vRect.origin.y + bRect.size.height, width: vRect.size.width, height: vRect.size.height - bRect.size.height), bvInsets)
    }
    
    open override func getBaseViewRect() -> CGRect {
        let chh: CGFloat
        if let item = self.item as? FlexCardViewCollectionItem {
            chh = item.cardHeaderHeight ?? self.cardHeaderHeight
        }
        else {
            chh = self.cardHeaderHeight
        }
        let bRect = super.getBaseViewRect()
        return CGRect(origin: bRect.origin, size: CGSize(width: bRect.size.width, height: chh))
    }
}
