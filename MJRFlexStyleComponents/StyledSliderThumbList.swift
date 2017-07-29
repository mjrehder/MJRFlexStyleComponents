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

open class StyledSliderThumbList {
    var thumbs: [StyledSliderThumb] = []
    
    open var maximumValue: Double = 100 {
        didSet {
        }
    }
    
    open var minimumValue: Double = 0 {
        didSet {
        }
    }
    
    open var direction: StyledControlDirection = .horizontal {
        didSet {
        }
    }
    
    open var bounds: CGRect = CGRect.zero {
        didSet {
        }
    }
    
    // Call this after swiping the control or when behaviour changes
    func applyThumbBehaviour(_ thumb: StyledSliderThumb) {
        let lp = self.lowerPosForThumb(thumb.index)
        let hp = self.higherPosForThumb(thumb.index)
        let cp = lp + (hp - lp) * 0.5
        thumb.snappingBehavior = SnappingThumbBehaviour(item: nil, snapToPoint: CGPoint.zero)
        switch thumb.behaviour {
        case .freeform:
            return
        case .snapToLower:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(lp, thumbIndex: thumb.index))
        case .snapToCenter:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(cp, thumbIndex: thumb.index))
        case .snapToHigher:
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(hp, thumbIndex: thumb.index))
        case .snapToLowerAndHigher:
            let pos = self.direction.principalPosition(thumb.center)
            if pos < cp {
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(lp, thumbIndex: thumb.index))
            }
            else {
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosFromPrincipalPos(hp, thumbIndex: thumb.index))
            }
        case .fixateToCenter:
            self.updateThumbPosition(cp, thumbIndex: thumb.index)
        case .fixateToHigher:
            self.updateThumbPosition(hp, thumbIndex: thumb.index)
        case .fixateToLower:
            self.updateThumbPosition(lp, thumbIndex: thumb.index)
        case .snapToValue(let v):
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(v, thumbIndex: thumb.index))
        case .snapToValueRelative(let v):
            thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(v, thumbIndex: thumb.index))
        case .snapToTwoState(let low, let high):
            let currentPos = self.getValueFromThumbPos(thumb.index)
            let ld = abs(currentPos - low)
            let hd = abs(currentPos - high)
            if ld < hd {
                NSLog("Snapping to low (current: \(currentPos))")
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(low, thumbIndex: thumb.index))
            }
            else {
                NSLog("Snapping to high (current: \(currentPos))")
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(high, thumbIndex: thumb.index))
            }
        case .snapToThreeState(let low, let mid, let high):
            let currentPos = self.getValueFromThumbPos(thumb.index)
            let ld = abs(currentPos - low)
            let md = abs(currentPos - mid)
            let hd = abs(currentPos - high)
            if ld < min(md, hd) {
                NSLog("Snapping to low (current: \(currentPos))")
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(low, thumbIndex: thumb.index))
            }
            else if md < min(ld, hd) {
                NSLog("Snapping to mid (current: \(currentPos))")
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(mid, thumbIndex: thumb.index))
            }
            else if hd < min(ld, md) {
                NSLog("Snapping to high (current: \(currentPos))")
                thumb.snappingBehavior = SnappingThumbBehaviour(item: thumb, snapToPoint: self.getThumbPosForValue(high, thumbIndex: thumb.index))
            }
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
    
    func getValueDelta(_ value: Double) -> Double {
        return (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    func getPositionMin() -> CGFloat {
        if let firstThumb = self.thumbs.first {
            return self.direction.principalSize(firstThumb.bounds.size) * 0.5
        }
        return self.direction.principalPosition(self.bounds.origin)
    }
    
    func getPositionMax() -> CGFloat {
        let maxControlPos = self.direction.principalSize(self.bounds.size) + self.direction.principalPosition(self.bounds.origin)
        if let lastThumb = self.thumbs.last {
            return maxControlPos - self.direction.principalSize(lastThumb.bounds.size) * 0.5
        }
        return maxControlPos
    }
    
    func getControlSize() -> CGFloat {
        return self.direction.principalSize(self.bounds.size)
    }
    
    func thumbSizeSum(_ startIndex: Int, endIndex: Int) -> CGFloat {
        var sum: CGFloat = 0
        if startIndex <= endIndex && startIndex >= 0 && endIndex < self.thumbs.count {
            for index in startIndex ... endIndex {
                let thumb = self.thumbs[index]
                sum += self.direction.principalSize(thumb.bounds.size)
            }
        }
        return sum
    }
    
    func thumbDistanceSum(_ startIndex: Int, endIndex: Int) -> CGFloat {
        var sum: CGFloat = 0
        if startIndex <= endIndex && startIndex >= 0 && endIndex < self.thumbs.count {
            if startIndex == 0 {
                let thumb = self.thumbs[0]
                sum += self.direction.principalPosition(thumb.center)
            }
            if endIndex == self.thumbs.count-1 {
                let thumb = self.thumbs[self.thumbs.count-1]
                sum += self.getPositionMax() - self.direction.principalPosition(thumb.center)
            }
            for index in startIndex ..< endIndex {
                let thumb = self.thumbs[index]
                let nextThumb = self.thumbs[index+1]
                sum += (self.direction.principalPosition(nextThumb.bounds.origin) - self.direction.principalPosition(thumb.bounds.origin))
            }
        }
        return sum
    }
    
    func getPrevThumb(_ index: Int) -> StyledSliderThumb? {
        if index-1 < 0 {
            return nil
        }
        if index-1 >= self.thumbs.count {
            return nil
        }
        return self.thumbs[index-1]
    }
    
    func getNextThumb(_ index: Int) -> StyledSliderThumb? {
        if index+1 < 0 {
            return nil
        }
        if index+1 >= self.thumbs.count {
            return nil
        }
        return self.thumbs[index+1]
    }
    
    func lowerPosForThumb(_ index: Int) -> CGFloat {
        var prevThumbSize: CGFloat = 0
        var prevPos: CGFloat = 0
        if let prevThumb = self.getPrevThumb(index) {
            prevThumbSize = self.direction.principalSize(prevThumb.bounds.size)
            prevPos = self.direction.principalPosition(prevThumb.center)
        }
        let thumb = self.thumbs[index]
        let thumbSize = self.direction.principalSize(thumb.bounds.size)
        return self.direction.principalPosition(self.bounds.origin) + prevPos + (prevThumbSize + thumbSize) * 0.5
    }
    
    func higherPosForThumb(_ index: Int) -> CGFloat {
        var nextThumbSize: CGFloat = 0
        var nextPos: CGFloat = self.direction.principalSize(self.bounds.size)
        if let nextThumb = self.getNextThumb(index) {
            nextThumbSize = self.direction.principalSize(nextThumb.bounds.size)
            nextPos = self.direction.principalPosition(nextThumb.center)
        }
        let thumb = self.thumbs[index]
        let thumbSize = self.direction.principalSize(thumb.bounds.size)
        return (self.direction.principalPosition(self.bounds.origin) + nextPos) - (nextThumbSize + thumbSize) * 0.5
    }
    
    // Returns the delta change
    func updateThumbPosition(_ pos: CGFloat, thumbIndex: Int) {
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
        if self.direction == .horizontal {
            thumb.center = CGPoint(x: pPos, y: thumb.center.y)
        }
        else {
            thumb.center = CGPoint(x: thumb.center.x, y: pPos)
        }
    }
    
    func getThumbPosFromPrincipalPos(_ pos: CGFloat, thumbIndex: Int) -> CGPoint {
        let thumb = self.thumbs[thumbIndex]
        if self.direction == .horizontal {
            return CGPoint(x: pos, y: thumb.center.y)
        }
        else {
            return CGPoint(x: thumb.center.x, y: pos)
        }
    }
    
    func getThumbPos(thumbIndex: Int) -> CGPoint {
        let v = self.getValueFromThumbPos(thumbIndex)
        return self.getThumbPosForValue(v, thumbIndex: thumbIndex)
    }
    
    func getThumbPosForValue(_ value: Double, thumbIndex: Int) -> CGPoint {
        let thumb = self.thumbs[thumbIndex]
        let tS = self.direction.principalSize(thumb.bounds.size)
        let thS = tS * 0.5
        let vd = CGFloat(self.getValueDelta(value))
        let totalThumbSum = self.thumbSizeSum(0, endIndex: self.thumbs.count-1)
        let lowerThumbSum = self.thumbSizeSum(0, endIndex: thumbIndex-1)
        let uT = self.getControlSize()
        let u = (uT - totalThumbSum) * vd + lowerThumbSum + thS
        return self.getThumbPosFromPrincipalPos(u, thumbIndex: thumbIndex)
    }
    
    func getValueFromThumbPos(_ thumbIndex: Int) -> Double {
        let thumb = self.thumbs[thumbIndex]
        let tS = self.direction.principalSize(thumb.bounds.size)
        let thS = tS * 0.5
        let totalThumbSum = self.thumbSizeSum(0, endIndex: self.thumbs.count-1)
        let lowerThumbSum = self.thumbSizeSum(0, endIndex: thumbIndex-1)
        let uT = self.getControlSize()

        let pos = self.direction.principalPosition(thumb.center)
        let vT = Double((pos - (lowerThumbSum + thS)) / (uT - totalThumbSum))
        let val = vT * (maximumValue - minimumValue) + minimumValue
        return val
    }
}
