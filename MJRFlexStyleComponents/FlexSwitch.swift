//
//  FlexSwitch.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 23.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

// The FlexSwitch is only supporting horizontal layout
@IBDesignable public class FlexSwitch: GenericStyleSlider, GenericStyleSliderDelegate, GenericStyleSliderTouchDelegate {
    var snappingBehavior: SnappingThumbBehaviour?

    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.setupSwitch()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSwitch()
    }

    func setupSwitch() {
        self.continuous = false
        self.style = .Tube
        self.thumbStyle = .Tube
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.borderColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.thumbSnappingBehaviour = .SnapToLowerAndHigher
        self.values = [0]
        self.sliderDelegate = self
        self.thumbTouchDelegate = self
    }

    override func initComponent() {
        super.initComponent()
        if bounds.size.width > 0.0 {
            self.thumbRatio = (bounds.size.height - 1.0) / bounds.size.width
        }
    }
    
    @IBInspectable public var onTintColor: UIColor? = UISwitch.appearance().onTintColor {
        didSet {
            self.applySeparatorStyle(self.separatorStyle)
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor? = UISwitch.appearance().thumbTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    public var on: Bool {
        get {
            return self.values[0] > 0
        }
    }
    
    public func setOn(isOn: Bool) {
        let targetValue = isOn ? 1.0 : 0.0
        self.values = [targetValue]
    }
    
    // MARK: - GenericStyleSliderDelegate
    
    public func textOfThumb(index: Int) -> String? {
        return nil
    }
    
    public func textOfSeparatorLabel(index: Int) -> String? {
        return nil
    }
    
    public func colorOfThumb(index: Int) -> UIColor? {
        return self.thumbTintColor
    }
    
    public func colorOfSeparatorLabel(index: Int) -> UIColor? {
        return index == 0 ? self.onTintColor : self.backgroundColor
    }
    
    // MARK: - GenericStyleSliderTouchDelegate
    
    public func onThumbTouchBegan(index: Int) {
    }
    
    public func onThumbTouchEnded(index: Int) {
        self.setOn(!self.on)
    }
}
