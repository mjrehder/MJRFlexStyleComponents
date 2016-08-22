//
//  StyledSliderThumbList.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 16.07.16.
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

public class StyledSliderThumbList {
    var thumbs: [StyledSliderThumb] = []
    
    public var maximumValue: Double = 100 {
        didSet {
        }
    }
    
    public var minimumValue: Double = 0 {
        didSet {
        }
    }
    
    public var direction: StyleSliderDirection = .Horizontal {
        didSet {
        }
    }
    
    public var bounds: CGRect = CGRectZero {
        didSet {
        }
    }
    
    // Call this after swiping the control or when behaviour changes
    func applyThumbBehaviour(thumb: StyledSliderThumb) {
        let lp = self.lowerPosForThumb(thumb.index)
        let hp = self.higherPosForThumb(thumb.index)
        let cp = lp + (hp - lp) * 0.5
        thumb.snappingBehavior = SnappingThumbBehaviour(item: nil, snapToPoint: CGPointZero)
        switch thumb.behaviour {
        case .Freeform:
            return
        case .SnapToLower:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(lp, thumbIndex: thumb.index))
        case .SnapToCenter:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(cp, thumbIndex: thumb.index))
        case .SnapToHigher:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(hp, thumbIndex: thumb.index))
        case .SnapToLowerAndHigher:
            let pos = self.getPrincipalPositionValue(thumb.center)
            if pos < cp {
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(lp, thumbIndex: thumb.index))
            }
            else {
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(hp, thumbIndex: thumb.index))
            }
        case .FixateToCenter:
            self.updateThumbPosition(cp, thumbIndex: thumb.index)
        case .FixateToHigher:
            self.updateThumbPosition(hp, thumbIndex: thumb.index)
        case .FixateToLower:
            self.updateThumbPosition(lp, thumbIndex: thumb.index)
        }
    }
    
    // MARK: - Thumb List maintainance
    
    func removeAllThumbs() {
        for thumb in self.thumbs {
            thumb.removeFromSuperview()
        }
        self.thumbs.removeAll()
    }
    
    // MARK: - Thumb List functions
    
    func getValueDelta(value: Double) -> Double {
        return (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    func getPrincipalPositionValue(p: CGPoint) -> CGFloat {
        return self.direction == .Horizontal ? p.x : p.y
    }
    
    func getPrincipalSizeValue(s: CGSize) -> CGFloat {
        return self.direction == .Horizontal ? s.width: s.height
    }
    
    func getNonPrincipalSizeValue(s: CGSize) -> CGFloat {
        return self.direction == .Horizontal ? s.height: s.width
    }
    
    func getPositionMin() -> CGFloat {
        if let firstThumb = self.thumbs.first {
            return self.getPrincipalSizeValue(firstThumb.bounds.size) * 0.5
        }
        return self.getPrincipalPositionValue(self.bounds.origin)
    }
    
    func getPositionMax() -> CGFloat {
        let maxControlPos = self.getPrincipalSizeValue(self.bounds.size) + self.getPrincipalPositionValue(self.bounds.origin)
        if let lastThumb = self.thumbs.last {
            return maxControlPos - self.getPrincipalSizeValue(lastThumb.bounds.size) * 0.5
        }
        return maxControlPos
    }
    
    func getControlSize() -> CGFloat {
        return self.getPrincipalSizeValue(self.bounds.size)
    }
    
    func thumbSizeSum(startIndex: Int, endIndex: Int) -> CGFloat {
        var sum: CGFloat = 0
        if startIndex <= endIndex && startIndex >= 0 && endIndex < self.thumbs.count {
            for index in startIndex ... endIndex {
                let thumb = self.thumbs[index]
                sum += self.getPrincipalSizeValue(thumb.bounds.size)
            }
        }
        return sum
    }
    
    func thumbDistanceSum(startIndex: Int, endIndex: Int) -> CGFloat {
        var sum: CGFloat = 0
        if startIndex <= endIndex && startIndex >= 0 && endIndex < self.thumbs.count {
            if startIndex == 0 {
                let thumb = self.thumbs[0]
                sum += self.getPrincipalPositionValue(thumb.center)
            }
            if endIndex == self.thumbs.count-1 {
                let thumb = self.thumbs[self.thumbs.count-1]
                sum += self.getPositionMax() - self.getPrincipalPositionValue(thumb.center)
            }
            for index in startIndex ..< endIndex {
                let thumb = self.thumbs[index]
                let nextThumb = self.thumbs[index+1]
                sum += (self.getPrincipalPositionValue(nextThumb.bounds.origin) - self.getPrincipalPositionValue(thumb.bounds.origin))
            }
        }
        return sum
    }
    
    func getPrevThumb(index: Int) -> StyledSliderThumb? {
        if index-1 < 0 {
            return nil
        }
        if index-1 >= self.thumbs.count {
            return nil
        }
        return self.thumbs[index-1]
    }
    
    func getNextThumb(index: Int) -> StyledSliderThumb? {
        if index+1 < 0 {
            return nil
        }
        if index+1 >= self.thumbs.count {
            return nil
        }
        return self.thumbs[index+1]
    }
    
    func lowerPosForThumb(index: Int) -> CGFloat {
        var prevThumbSize: CGFloat = 0
        var prevPos: CGFloat = 0
        if let prevThumb = self.getPrevThumb(index) {
            prevThumbSize = self.getPrincipalSizeValue(prevThumb.bounds.size)
            prevPos = self.getPrincipalPositionValue(prevThumb.center)
        }
        let thumb = self.thumbs[index]
        let thumbSize = self.getPrincipalSizeValue(thumb.bounds.size)
        return self.getPrincipalPositionValue(self.bounds.origin) + prevPos + (prevThumbSize + thumbSize) * 0.5
    }
    
    func higherPosForThumb(index: Int) -> CGFloat {
        var nextThumbSize: CGFloat = 0
        var nextPos: CGFloat = self.getPrincipalSizeValue(self.bounds.size)
        if let nextThumb = self.getNextThumb(index) {
            nextThumbSize = self.getPrincipalSizeValue(nextThumb.bounds.size)
            nextPos = self.getPrincipalPositionValue(nextThumb.center)
        }
        let thumb = self.thumbs[index]
        let thumbSize = self.getPrincipalSizeValue(thumb.bounds.size)
        return (self.getPrincipalPositionValue(self.bounds.origin) + nextPos) - (nextThumbSize + thumbSize) * 0.5
    }
    
    func updateThumbPosition(pos: CGFloat, thumbIndex: Int) {
        let thumb = self.thumbs[thumbIndex]
        var pPos = pos
        let hp = self.higherPosForThumb(thumbIndex)
        let lp = self.lowerPosForThumb(thumbIndex)
        if pPos > hp {
            pPos = hp
        }
        if pPos < lp {
            pPos = lp
        }
        if self.direction == .Horizontal {
            thumb.center = CGPointMake(pPos, thumb.center.y)
        }
        else {
            thumb.center = CGPointMake(thumb.center.x, pPos)
        }
    }
    
    func getThumbPosFromPrincipalPos(pos: CGFloat, thumbIndex: Int) -> CGPoint {
        let thumb = self.thumbs[thumbIndex]
        if self.direction == .Horizontal {
            return CGPointMake(pos, thumb.center.y)
        }
        else {
            return CGPointMake(thumb.center.x, pos)
        }
    }
    
    func getThumbPosForValue(value: Double, thumbIndex: Int) -> CGPoint {
        let thumb = self.thumbs[thumbIndex]
        let tS = self.getPrincipalSizeValue(thumb.bounds.size)
        let thS = tS * 0.5
        let vd = CGFloat(self.getValueDelta(value))
        let totalThumbSum = self.thumbSizeSum(0, endIndex: self.thumbs.count-1)
        let lowerThumbSum = self.thumbSizeSum(0, endIndex: thumbIndex-1)
        let uT = self.getControlSize()
        let u = (uT - totalThumbSum) * vd + lowerThumbSum + thS
        return self.getThumbPosFromPrincipalPos(u, thumbIndex: thumbIndex)
    }
    
    func getValueFromThumbPos(thumbIndex: Int) -> Double {
        let thumb = self.thumbs[thumbIndex]
        let tS = self.getPrincipalSizeValue(thumb.bounds.size)
        let thS = tS * 0.5
        let totalThumbSum = self.thumbSizeSum(0, endIndex: self.thumbs.count-1)
        let lowerThumbSum = self.thumbSizeSum(0, endIndex: thumbIndex-1)
        let uT = self.getControlSize()

        let pos = self.getPrincipalPositionValue(thumb.center)
        let vT = Double((pos - (lowerThumbSum + thS)) / (uT - totalThumbSum))
        let val = vT * (maximumValue - minimumValue) + minimumValue
        return val
    }
}
