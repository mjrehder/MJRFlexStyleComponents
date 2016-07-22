//
//  PositionUpdateTimer.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 22.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

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