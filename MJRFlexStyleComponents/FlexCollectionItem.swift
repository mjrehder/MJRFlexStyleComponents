//
//  FlexCollectionItem.swift
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

public protocol FlexCollectionItemSwipeDelegate {
    func swipeMenuSelected(_ item: FlexCollectionItem, menuItem: FlexLabel)
}

open class FlexCollectionItem: NSObject {
    open var reference: String
    
    /// Use this to refer to other content or items. The auxReference is not used or altered by the FlexCollection.
    open var auxReference: String?
    
    open var text: NSAttributedString?
    open var sectionReference: String?
    open var preferredCellSize: CGSize?
    open var canMoveItem: Bool = true
    
    /// Swipe left menu items. A swipe gesture will be added to the cell when the menu items are set
    open var swipeLeftMenuItems: [FlexLabel]?
    /// Swipe right menu items. A swipe gesture will be added to the cell when the menu items are set
    open var swipeRightMenuItems: [FlexLabel]?
    
    open var swipeMenuDelegate: FlexCollectionItemSwipeDelegate?
    
    open var itemSelectionActionHandler: (() -> Void)?
    /// This handler will return the location inside the selected cell by [0..1] for both axis
    open var itemPrecisionSelectionActionHandler: ((CGFloat, CGFloat) -> Void)?
    open var itemDeselectionActionHandler: (() -> Void)?
    
    open var autoDeselectCellAfter: DispatchTimeInterval?
    
    open var isSelected: Bool = false
    
    open var cellStyler: FlexCellStyler? = nil
    
    public init(reference: String, text: NSAttributedString? = nil) {
        self.reference = reference
        self.text = text
    }
}
