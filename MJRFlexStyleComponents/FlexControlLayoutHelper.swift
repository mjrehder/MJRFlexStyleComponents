//
//  FlexControlLayoutHelper.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 08.10.2016.
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

public class FlexControlLayoutHelper {
    
    public class func horizontallyAlignTwoFlexControls(upperControl: MJRFlexBaseControl, lowerControl: MJRFlexBaseControl, area: CGRect) {
        let upperFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y, area.size.width, area.size.height * 0.5), upperControl.controlInsets ?? UIEdgeInsetsZero)
        let lowerFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y + area.size.height * 0.5, area.size.width, area.size.height * 0.5), lowerControl.controlInsets ?? UIEdgeInsetsZero)
        upperControl.frame = upperFrame
        lowerControl.frame = lowerFrame
    }
    
    public class func layoutFourLabelsInArea(upperLeft: FlexLabel, lowerLeft: FlexLabel, upperRight: FlexLabel, lowerRight: FlexLabel, area: CGRect) {
        let ciUL = upperLeft.controlInsets ?? UIEdgeInsetsZero
        let ciUR = upperRight.controlInsets ?? UIEdgeInsetsZero
        let ciLL = lowerLeft.controlInsets ?? UIEdgeInsetsZero
        let ciLR = lowerRight.controlInsets ?? UIEdgeInsetsZero
        
        let upperLeftFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y, area.size.width, area.size.height * 0.5), ciUL)
        let lowerLeftFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y + area.size.height * 0.5, area.size.width, area.size.height * 0.5), ciLL)
        let upperRightFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y, area.size.width, area.size.height * 0.5), ciUR)
        let lowerRightFrame = UIEdgeInsetsInsetRect(CGRectMake(area.origin.x, area.origin.y + area.size.height * 0.5, area.size.width, area.size.height * 0.5), ciLR)

        let ulFont = upperLeft.label.font ?? upperLeft.getLabelAppearance().textFont
        let urFont = upperRight.label.font ?? upperRight.getLabelAppearance().textFont
        let llFont = lowerLeft.label.font ?? lowerLeft.getLabelAppearance().textFont
        let lrFont = lowerRight.label.font ?? lowerRight.getLabelAppearance().textFont

        let ulText = upperLeft.label.attributedText?.string ?? upperLeft.label.text
        let llText = lowerLeft.label.attributedText?.string ?? upperLeft.label.text
        let urText = upperRight.label.attributedText?.string ?? upperLeft.label.text
        let lrText = lowerRight.label.attributedText?.string ?? upperLeft.label.text
        
        // Width calculations
        let prefSizeUL = ulText?.widthWithConstrainedHeightSize(upperLeftFrame.size.height, font: ulFont) ?? CGSizeZero
        let prefSizeLL = llText?.widthWithConstrainedHeightSize(lowerLeftFrame.size.height, font: llFont) ?? CGSizeZero
        let prefSizeUR = urText?.widthWithConstrainedHeightSize(upperRightFrame.size.height, font: urFont) ?? CGSizeZero
        let prefSizeLR = lrText?.widthWithConstrainedHeightSize(lowerRightFrame.size.height, font: lrFont) ?? CGSizeZero
        
        let totalUpperWidth = area.size.width - (ciUR.left + ciUR.right + ciUL.left + ciUL.right)
        let totalLowerWidth = area.size.width - (ciLR.left + ciLR.right + ciLL.left + ciLL.right)
        
        var finalULWidth = prefSizeUR.width == 0 ? totalUpperWidth : prefSizeUL.width
        var finalURWidth = prefSizeUL.width == 0 ? totalUpperWidth : prefSizeUR.width
        var finalLLWidth = prefSizeLR.width == 0 ? totalLowerWidth : prefSizeLL.width
        var finalLRWidth = prefSizeLL.width == 0 ? totalLowerWidth : prefSizeLR.width

        if prefSizeUL.width + prefSizeUR.width > totalUpperWidth {
            let delta = totalUpperWidth / (prefSizeUL.width + prefSizeUR.width)
            finalULWidth = delta * prefSizeUL.width
            finalURWidth = delta * prefSizeUR.width
        }
        
        if prefSizeLL.width + prefSizeLR.width > totalLowerWidth {
            let delta = totalLowerWidth / (prefSizeLL.width + prefSizeLR.width)
            finalLLWidth = delta * prefSizeLL.width
            finalLRWidth = delta * prefSizeLR.width
        }

        // Height calculations
        let totalRightHeight = area.size.height - (ciUR.top + ciUR.bottom + ciLR.top + ciLR.bottom)
        let totalLeftHeight = area.size.height - (ciUL.top + ciUL.bottom + ciLL.top + ciLL.bottom)

        var finalULHeight = prefSizeLL.width == 0 ? totalLeftHeight : prefSizeUL.height
        var finalURHeight = prefSizeLR.width == 0 ? totalRightHeight : prefSizeUR.height
        var finalLLHeight = prefSizeUL.width == 0 ? totalLeftHeight : prefSizeLL.height
        var finalLRHeight = prefSizeUR.width == 0 ? totalRightHeight : prefSizeLR.height
        
        if prefSizeUL.height + prefSizeLL.height > totalLeftHeight {
            let delta = totalLeftHeight / (prefSizeUL.height + prefSizeLL.height)
            finalULHeight = delta * prefSizeUL.height
            finalLLHeight = delta * prefSizeLL.height
        }
        
        if prefSizeUR.height + prefSizeLR.height > totalRightHeight {
            let delta = totalRightHeight / (prefSizeUR.height + prefSizeLR.height)
            finalURHeight = delta * prefSizeUR.height
            finalLRHeight = delta * prefSizeLR.height
        }

        let finalYOffsetUL = prefSizeLL.width == 0 ? area.origin.y + (area.size.height - finalULHeight) * 0.5 : upperLeftFrame.origin.y
        let finalYOffsetUR = prefSizeLR.width == 0 ? area.origin.y + (area.size.height - finalURHeight) * 0.5 : upperRightFrame.origin.y
        let finalYOffsetLL = prefSizeUL.width == 0 ? area.origin.y + (area.size.height - finalLLHeight) * 0.5 : area.origin.y + area.size.height - (finalLLHeight + ciLL.bottom)
        let finalYOffsetLR = prefSizeUR.width == 0 ? area.origin.y + (area.size.height - finalLRHeight) * 0.5 : area.origin.y + area.size.height - (finalLRHeight + ciLR.bottom)
        
        // TODO: Place vertically aligned to top and bottom
        
        upperLeft.frame = CGRectMake(upperLeftFrame.origin.x, finalYOffsetUL, finalULWidth, finalULHeight)
        upperRight.frame = CGRectMake(upperRightFrame.origin.x + totalUpperWidth - finalURWidth, finalYOffsetUR, finalURWidth, finalURHeight)
        lowerLeft.frame = CGRectMake(lowerLeftFrame.origin.x, finalYOffsetLL, finalLLWidth, finalLLHeight)
        lowerRight.frame = CGRectMake(lowerRightFrame.origin.x + totalLowerWidth - finalLRWidth, finalYOffsetLR, finalLRWidth, finalLRHeight)
    }
}
