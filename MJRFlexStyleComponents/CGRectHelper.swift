//
//  CGRectHelper.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.08.16.
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

// Adopted from lanephillips/CGRectAspectFit.m (GitHub / Gist)

class CGRectHelper {
    class func ScaleToAspectFitRectInRect(rfit: CGRect, rtarget: CGRect) -> CGFloat {
        // first try to match width
        let s = CGRectGetWidth(rtarget) / CGRectGetWidth(rfit)
        // if we scale the height to make the widths equal, does it still fit?
        if CGRectGetHeight(rfit) * s <= CGRectGetHeight(rtarget) {
            return s
        }
        // no, match height instead
        return CGRectGetHeight(rtarget) / CGRectGetHeight(rfit)
    }
    
    class func AspectFitRectInRect(rfit: CGRect, rtarget: CGRect) -> CGRect {
        let s = ScaleToAspectFitRectInRect(rfit, rtarget: rtarget)
        let w = CGRectGetWidth(rfit) * s
        let h = CGRectGetHeight(rfit) * s
        let x = CGRectGetMidX(rtarget) - w / 2
        let y = CGRectGetMidY(rtarget) - h / 2
        return CGRectMake(x, y, w, h)
    }
    
    class func ScaleToAspectFitRectAroundRect(rfit: CGRect, rtarget: CGRect) -> CGFloat {
        return 1.0 / ScaleToAspectFitRectInRect(rtarget, rtarget: rfit)
    }
    
    class func AspectFitRectAroundRect(rfit: CGRect, rtarget: CGRect) -> CGRect {
        let s = ScaleToAspectFitRectAroundRect(rfit, rtarget: rtarget)
        let w = CGRectGetWidth(rfit) * s
        let h = CGRectGetHeight(rfit) * s
        let x = CGRectGetMidX(rtarget) - w / 2
        let y = CGRectGetMidY(rtarget) - h / 2
        return CGRectMake(x, y, w, h)
    }
}
