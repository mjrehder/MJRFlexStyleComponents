//
//  BezierPathHelper.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 26.07.16.
//
//  Inspired by BEMSimpleLineGraph, Boris Emorine & Sam Spencer, MIT License
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

class BezierPathHelper {
    class func addBezierCurveWithPoints(path: UIBezierPath, points: [CGPoint]) {
        if points.count < 2 {
            return
        }
        
        var CP1 = CGPointZero
        var CP2 = CGPointZero
        
        var p0 = CGPointZero
        var p1 = CGPointZero
        var p2 = CGPointZero
        var p3 = CGPointZero
        var tensionBezier1:CGFloat = 0.3
        var tensionBezier2:CGFloat = 0.3
        
        var previousPoint1 = CGPointZero
        
        for i in 0..<points.count-1 {
            p1 = points[i]
            p2 = points[i+1]
            
            let maxTension: CGFloat = 1.0 / 3.0
            tensionBezier1 = maxTension
            tensionBezier2 = maxTension
            
            if i > 0 { // Exception for first line because there is no previous point
                p0 = previousPoint1
                if p2.y - p1.y == p1.y - p0.y {
                    tensionBezier1 = 0
                }
            } else {
                tensionBezier1 = 0
                p0 = p1
            }
            
            if i < points.count - 2 { // Exception for last line because there is no next point
                p3 = points[i + 2]
                if p3.y - p2.y == p2.y - p1.y {
                    tensionBezier2 = 0
                }
            } else {
                p3 = p2
                tensionBezier2 = 0
            }
            
            // The tension should never exceed 0.3
            if tensionBezier1 > maxTension {
                tensionBezier1 = maxTension
            }
            if (tensionBezier2 > maxTension) {
                tensionBezier2 = maxTension
            }
            
            // First control point
            CP1 = CGPointMake(p1.x + (p2.x - p1.x)/3, p1.y - (p1.y - p2.y)/3 - (p0.y - p1.y)*tensionBezier1)
            
            // Second control point
            CP2 = CGPointMake(p1.x + 2*(p2.x - p1.x)/3, (p1.y - 2*(p1.y - p2.y)/3) + (p2.y - p3.y) * tensionBezier2)
            
            path.addCurveToPoint(p2, controlPoint1: CP1, controlPoint2: CP2)
            
            previousPoint1 = p1
        }
    }
}
