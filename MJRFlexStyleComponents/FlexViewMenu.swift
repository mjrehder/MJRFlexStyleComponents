//
//  FlexViewMenu.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 26.08.16.
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

public enum FlexViewMenuVerticalPosition {
    case top
    case bottom
    case header
    case footer
}

public enum FlexViewMenuHorizontalPosition {
    case left
    case right
    case fill
    case center
}

open class FlexViewMenu {
    let hPos: FlexViewMenuHorizontalPosition
    let vPos: FlexViewMenuVerticalPosition
    let size: CGSize
    let menu: FlexMenu
    public let id = UUID().uuidString
    
    public init(menu: FlexMenu, size: CGSize, hPos: FlexViewMenuHorizontalPosition, vPos: FlexViewMenuVerticalPosition) {
        self.menu = menu
        self.size = size
        self.hPos = hPos
        self.vPos = vPos
    }
}
