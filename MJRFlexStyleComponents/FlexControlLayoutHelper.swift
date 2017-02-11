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

open class FlexControlLayoutHelper {
    
    open class func horizontallyAlignTwoFlexControls(_ upperControl: FlexBaseControl, lowerControl: FlexBaseControl, area: CGRect) {
        let upperFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y, width: area.size.width, height: area.size.height * 0.5), upperControl.controlInsets)
        let lowerFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y + area.size.height * 0.5, width: area.size.width, height: area.size.height * 0.5), lowerControl.controlInsets)
        upperControl.frame = upperFrame
        lowerControl.frame = lowerFrame
    }
    
    open class func layoutFourLabelsInArea(_ upperLeft: FlexLabel, lowerLeft: FlexLabel, upperRight: FlexLabel, lowerRight: FlexLabel, area: CGRect) {
        let ciUL = upperLeft.controlInsets
        let ciUR = upperRight.controlInsets
        let ciLL = lowerLeft.controlInsets
        let ciLR = lowerRight.controlInsets
        
        let upperLeftFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y, width: area.size.width, height: area.size.height * 0.5), ciUL)
        let lowerLeftFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y + area.size.height * 0.5, width: area.size.width, height: area.size.height * 0.5), ciLL)
        let upperRightFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y, width: area.size.width, height: area.size.height * 0.5), ciUR)
        let lowerRightFrame = UIEdgeInsetsInsetRect(CGRect(x: area.origin.x, y: area.origin.y + area.size.height * 0.5, width: area.size.width, height: area.size.height * 0.5), ciLR)
        
        let ulFont = upperLeft.label.font ?? UIFont.systemFont(ofSize: 12)
        let urFont = upperRight.label.font ?? UIFont.systemFont(ofSize: 12)
        let llFont = lowerLeft.label.font ?? UIFont.systemFont(ofSize: 12)
        let lrFont = lowerRight.label.font ?? UIFont.systemFont(ofSize: 12)
        
        let ulText = upperLeft.label.attributedText?.string ?? upperLeft.label.text
        let llText = lowerLeft.label.attributedText?.string ?? upperLeft.label.text
        let urText = upperRight.label.attributedText?.string ?? upperLeft.label.text
        let lrText = lowerRight.label.attributedText?.string ?? upperLeft.label.text
        
        // Width calculations
        let prefSizeUL = ulText?.widthWithConstrainedHeightSize(upperLeftFrame.size.height, font: ulFont) ?? CGSize.zero
        let prefSizeLL = llText?.widthWithConstrainedHeightSize(lowerLeftFrame.size.height, font: llFont) ?? CGSize.zero
        let prefSizeUR = urText?.widthWithConstrainedHeightSize(upperRightFrame.size.height, font: urFont) ?? CGSize.zero
        let prefSizeLR = lrText?.widthWithConstrainedHeightSize(lowerRightFrame.size.height, font: lrFont) ?? CGSize.zero
        
        let minHeightUL = ulText?.heightWithConstrainedWidthSize(prefSizeUL.width, font: ulFont).height ?? upperLeftFrame.size.height
        let minHeightLL = llText?.heightWithConstrainedWidthSize(prefSizeLL.width, font: llFont).height ?? lowerLeftFrame.size.height
        let minHeightUR = urText?.heightWithConstrainedWidthSize(prefSizeUR.width, font: urFont).height ?? upperRightFrame.size.height
        let minHeightLR = lrText?.heightWithConstrainedWidthSize(prefSizeLR.width, font: lrFont).height ?? lowerRightFrame.size.height
        
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
        
        var finalULHeight = max(prefSizeUL.height,prefSizeLL.width == 0 ? totalLeftHeight : minHeightUL)
        var finalURHeight = max(prefSizeUR.height,prefSizeLR.width == 0 ? totalRightHeight : minHeightUR)
        var finalLLHeight = max(prefSizeLL.height,prefSizeUL.width == 0 ? totalLeftHeight : minHeightLL)
        var finalLRHeight = max(prefSizeLR.height,prefSizeUR.width == 0 ? totalRightHeight : minHeightLR)
        
        if prefSizeUL.height + prefSizeLL.height > totalLeftHeight {
            let delta = totalLeftHeight / (prefSizeUL.height + prefSizeLL.height)
            finalULHeight = max(delta * prefSizeUL.height, minHeightUL)
            finalLLHeight = max(delta * prefSizeLL.height, minHeightLL)
        }
        
        if prefSizeUR.height + prefSizeLR.height > totalRightHeight {
            let delta = totalRightHeight / (prefSizeUR.height + prefSizeLR.height)
            finalURHeight = max(delta * prefSizeUR.height, minHeightUR)
            finalLRHeight = max(delta * prefSizeLR.height, minHeightLR)
        }
        
        let finalYOffsetUL = prefSizeLL.width == 0 ? area.origin.y + (area.size.height - finalULHeight) * 0.5 : upperLeftFrame.origin.y
        let finalYOffsetUR = prefSizeLR.width == 0 ? area.origin.y + (area.size.height - finalURHeight) * 0.5 : upperRightFrame.origin.y
        let finalYOffsetLL = prefSizeUL.width == 0 ? area.origin.y + (area.size.height - finalLLHeight) * 0.5 : area.origin.y + area.size.height - (finalLLHeight + ciLL.bottom)
        let finalYOffsetLR = prefSizeUR.width == 0 ? area.origin.y + (area.size.height - finalLRHeight) * 0.5 : area.origin.y + area.size.height - (finalLRHeight + ciLR.bottom)
        
        // TODO: Place vertically aligned to top and bottom
        
        upperLeft.frame = CGRect(x: upperLeftFrame.origin.x, y: finalYOffsetUL, width: finalULWidth, height: finalULHeight)
        upperRight.frame = CGRect(x: upperRightFrame.origin.x + totalUpperWidth - finalURWidth, y: finalYOffsetUR, width: finalURWidth, height: finalURHeight)
        lowerLeft.frame = CGRect(x: lowerLeftFrame.origin.x, y: finalYOffsetLL, width: finalLLWidth, height: finalLLHeight)
        lowerRight.frame = CGRect(x: lowerRightFrame.origin.x + totalLowerWidth - finalLRWidth, y: finalYOffsetLR, width: finalLRWidth, height: finalLRHeight)
    }
}
