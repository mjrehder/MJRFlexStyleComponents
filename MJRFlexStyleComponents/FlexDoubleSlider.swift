//
//  FlexDoubleSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 26.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

public class FlexDoubleSlider: FlexSlider {

    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) || frame.size.height == 0 || frame.size.width == 0 {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.setupSlider()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSlider()
    }

    public var value2: Double {
        get {
            return self.values[1]
        }
        set(newValue) {
            self.values[1] = newValue
        }
    }

    @IBInspectable public var middleTrackTintColor: UIColor? = UISlider.appearance().minimumTrackTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }

    override func setupSlider() {
        self.continuous = true
        self.style = .Tube
        self.thumbStyle = .Tube
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.borderColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.thumbSnappingBehaviour = .Freeform
        self.values = [0,0]
        self.sliderDelegate = self
    }
    
    public override func colorOfSeparatorLabel(index: Int) -> UIColor? {
        switch index {
        case 0:
            return self.minimumTrackTintColor
        case 1:
            return self.middleTrackTintColor
        default:
            return self.maximumTrackTintColor
        }
    }
}
