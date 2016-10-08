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

        // FlexLabels are special, as they contain a label inside in order to support rotated text
        if let uLabel = upperControl as? FlexLabel {
            uLabel.label.frame = uLabel.bounds
        }
        if let lLabel = lowerControl as? FlexLabel {
            lLabel.label.frame = lLabel.bounds
        }
    }
}
