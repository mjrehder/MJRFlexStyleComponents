//
//  PositionUpdateTimer.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 22.07.16.
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

import Foundation

class PositionUpdateTimer {
    private var timer: NSTimer?
    private var updateBlock: (() -> Void)?
    
    deinit {
        stop()
    }
    
    // MARK: - Managing Autorepeat
    
    func stop() {
        timer?.invalidate()
    }
    
    func start(frequency: NSTimeInterval, updateBlock block: () -> Void) {
        if let _timer = timer where _timer.valid {
            return
        }
        
        self.updateBlock = block
        repeatTick(nil)
        
        let newTimer = NSTimer(timeInterval: frequency, target: self, selector: #selector(PositionUpdateTimer.repeatTick), userInfo: nil, repeats: true)
        self.timer   = newTimer
        NSRunLoop.currentRunLoop().addTimer(newTimer, forMode: NSRunLoopCommonModes)
    }
    
    @objc func repeatTick(sender: AnyObject?) {
        self.updateBlock?()
    }
}