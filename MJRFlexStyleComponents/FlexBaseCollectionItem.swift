//
//  FlexBaseCollectionItem.swift
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

open class FlexBaseCollectionItem: FlexCollectionItem {
    open var icon: UIImage?
    open var accessoryImage: UIImage?
    
    /// These will be shown in the header
    open var title: NSAttributedString?
    open var underTitle: NSAttributedString?
    
    /// These will be shown in the footer
    open var subTitle: NSAttributedString?
    open var secondarySubTitle: NSAttributedString?
    
    /// This will be shown below the text
    open var detailText: NSAttributedString?
    
    /// This will be shown to the upper right of the cell
    open var infoText: NSAttributedString?
    
    /// This will be shown to the lower right of the cell
    open var auxText: NSAttributedString?

    /// Set this to true in order to hide the cell when the item is not selected.
    open var showAccessoryImageOnlyWhenSelected: Bool = false
    
    /// Set this to true in order to also trigger a selection of the item, when the icon or the accessoryImage is touched
    open var contentInteractionWillSelectItem: Bool = false
    
    open var accessoryImageActionHandler: (() -> Void)?
    open var imageViewActionHandler: (() -> Void)?
    open var imageViewFitting: FlexImageShapeFit?
    
    open var headerPosition: FlexViewHeaderPosition?
    
    // This is used for specifying the size of the area not used for the icon and accessory image. The entire remaining space is used, when this size or the cell controlSize is not set.
    open var controlSize: CGSize?
    
    open var controlInsets: UIEdgeInsets?

    open var headerImage: UIImage?
    open var headerImageInsets: UIEdgeInsets?
    open var headerImagePosition: NSTextAlignment?
    open var headerImageCornerRadius: CGFloat?
    open var headerImageMasksToBounds: Bool?
    open var headerImageBorderWidth: CGFloat?
    open var headerImageBorderColor: UIColor?

    public init(reference: String, text: NSAttributedString? = nil, icon: UIImage? = nil, accessoryImage: UIImage? = nil, title: NSAttributedString? = nil, accessoryImageActionHandler: (() -> Void)? = nil) {
        self.icon = icon
        self.accessoryImage = accessoryImage
        self.title = title
        self.accessoryImageActionHandler = accessoryImageActionHandler
        super.init(reference: reference, text: text)
    }
}
