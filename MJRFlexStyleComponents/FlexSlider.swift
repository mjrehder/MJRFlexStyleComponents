//
//  FlexSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 26.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

@IBDesignable
public class FlexSlider: GenericStyleSlider, GenericStyleSliderDelegate {

    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.setupSlider()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSlider()
    }
    
    public var value: Double {
        get {
            return self.values[0]
        }
        set(newValue) {
            self.values = [newValue]
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor? = UISlider.appearance().thumbTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    @IBInspectable public var minimumTrackTintColor: UIColor? = UISlider.appearance().minimumTrackTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    @IBInspectable public var maximumTrackTintColor: UIColor? = UISlider.appearance().maximumTrackTintColor {
        didSet {
            self.applyThumbStyle(self.thumbStyle)
        }
    }
    
    func setupSlider() {
        self.continuous = true
        self.style = .Tube
        self.thumbStyle = .Tube
        self.separatorStyle = .Box
        self.minimumValue = 0
        self.maximumValue = 1
        self.borderColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.thumbSnappingBehaviour = .Freeform
        self.values = [0]
        self.sliderDelegate = self
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
        return index == 0 ? self.minimumTrackTintColor : self.maximumTrackTintColor
    }

}
