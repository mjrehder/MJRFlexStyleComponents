//
//  StyledLabelExtension.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 19.06.2017.
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
import StyledLabel

extension StyledLabel {
    
    /*
     Only for text, not for NSAttributedString usage in StyledLabel
     */
    func fitFontForSize(minFontSize : CGFloat = 5.0, maxFontSize : CGFloat = 300.0, accuracy : CGFloat = 1.0, margins: UIEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)) {
        assert(maxFontSize > minFontSize)
        if let text = self.text, let font = self.font {
            self.font = font.withSize(self.fittingFontSize(text: text, minFontSize: minFontSize, maxFontSize: maxFontSize, accuracy: accuracy, margins: margins))
            layoutIfNeeded()
        }
    }
    
    func fittingFontSize(text: String, minFontSize : CGFloat = 5.0, maxFontSize : CGFloat = 300.0, accuracy : CGFloat = 1.0, margins: UIEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)) -> CGFloat {
        assert(maxFontSize > minFontSize)
        if let font = self.font {
            var tempFont = font
            var minfs = minFontSize
            var maxfs = maxFontSize
            layoutIfNeeded()
            let constrainedSize = UIEdgeInsetsInsetRect(bounds, margins).size
            
            while maxfs - minfs > accuracy {
                let midFontSize : CGFloat = ((minfs + maxfs) / 2)
                tempFont = font.withSize(midFontSize)
                let currentHeight = text.heightWithConstrainedWidth(constrainedSize.width, font: tempFont)
                let currentWidth = text.widthWithConstrainedHeight(constrainedSize.height, font: tempFont)
                let checkSize = CGSize(width: currentWidth, height: currentHeight)
                if checkSize.height < constrainedSize.height && checkSize.width < constrainedSize.width {
                    minfs = midFontSize
                } else {
                    maxfs = midFontSize
                }
            }
            return minfs
        }
        return minFontSize
    }
}
