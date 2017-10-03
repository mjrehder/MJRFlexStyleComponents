//
//  FlexMenuItem.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
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

open class FlexMenuItem {
    public var title: String
    public var titleShortcut: String
    public var color: UIColor
    public var thumbColor: UIColor
    public var selectedColor: UIColor
    public var selectedThumbColor: UIColor
    public var thumbIcon: UIImage?
    public var selectedThumbIcon: UIImage?
    public var disabledThumbIcon: UIImage?
    public var enabled = true
    public var selected = false
    public var hidden = false
    public var selectionHandler: (() -> Void)?

    public init(title: String, titleShortcut: String, color: UIColor, thumbColor: UIColor, thumbIcon: UIImage? = nil, disabledThumbIcon: UIImage? = nil, selectedThumbIcon: UIImage? = nil) {
        self.title = title
        self.titleShortcut = titleShortcut
        self.color = color
        self.selectedColor = color
        self.thumbColor = thumbColor
        self.selectedThumbColor = thumbColor
        self.thumbIcon = thumbIcon
        self.disabledThumbIcon = disabledThumbIcon
        self.selectedThumbIcon = selectedThumbIcon
    }
    
    public func activeThumbIcon() -> UIImage? {
        let icon = self.selected ? self.selectedThumbIcon : self.thumbIcon
        return self.enabled ? icon : (self.disabledThumbIcon ?? icon)
    }
}
