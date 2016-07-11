//
//  GenericStyleSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import SnappingStepper

public protocol GenericStyleSliderDelegate {
    func numberOfThumbs() -> Int
    func textOfThumb(index: Int) -> String?
    func textOfSeperatorLabel(index: Int) -> String?
}

// TODO: enum dimension (1-Dim, 2-Dim), layout (Horiz, Vert)

@IBDesignable public final class GenericStyleSlider: UIControl {
    var thumbs: [StyledSliderThumb] = []
    // TODO (private lists)
    // list of seperator labels
    
    // delegate decl: GenericStyleSliderDelegate
    
    
    /**
     Block to be notify when the value of the slider change.
     
     This is a convenient alternative to the `addTarget:Action:forControlEvents:` method of the `UIControl`.
     */
    public var valueChangedBlock: ((value: Double) -> Void)?

    /**
     The continuous vs. noncontinuous state of the slider.
     
     If true, value change events are sent immediately when the value changes during user interaction. If false, a value change event is sent when user interaction ends.
     
     The default value for this property is true.
     */
    @IBInspectable public var continuous: Bool = true
    
    /**
     The lowest possible numeric value.
     
     Must be numerically less than maximumValue. If you attempt to set a value equal to or greater than maximumValue, the system raises an NSInvalidArgumentException exception.
     
     The default value for this property is 0.
     */
    @IBInspectable public var minimumValue: Double = 0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
            
            updateValue(max(_value, minimumValue), finished: true)
        }
    }
    
    /**
     The highest possible numeric value.
     
     Must be numerically greater than minimumValue. If you attempt to set a value equal to or lower than minimumValue, the system raises an NSInvalidArgumentException exception.
     
     The default value of this property is 100.
     */
    @IBInspectable public var maximumValue: Double = 100 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
            
            updateValue(min(_value, maximumValue), finished: true)
        }
    }
    
    /**
     The numeric value.
     
     When the value changes, the control sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.
     
     The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
     */
    var value: Double {
        get {
            return _value
        }
        set (newValue) {
            updateValue(newValue, finished: true)
        }
    }
    
    var _value: Double = 0 {
        didSet {
            if thumbText == nil {
                thumbLabel.text = valueAsText()
            }
            
            hintLabel.text = valueAsText()
        }
    }
    
    // MARK: - Private
    
    // Call this after swiping the control or when behaviour changes
    func applyThumbsBehaviour() {
        for thumb in self.thumbs {
            switch thumb.behaviour {
            case .Freeform:
                return
            case .SnapToLower:
                break
            }
        }
    }

    
    // TODO: Most of this goes into the Thumb classes, which must be children of this control
    
    let dynamicButtonAnimator = UIDynamicAnimator()
    
    var styleLayer = CAShapeLayer()
    var styleColor: UIColor? = .clearColor()
    
    var touchesBeganPoint    = CGPointZero
    var initialValue: Double = -1
    var factorValue: Double  = 0
    var oldValue = Double.infinity * -1
    
    // MARK: - Internal
    
    func updateValue(value: Double, finished: Bool = true) {
        if value < minimumValue {
            _value = maximumValue
        }
        else if value > maximumValue {
            _value = minimumValue
        }
        
        if (continuous || finished) && oldValue != _value {
            oldValue = _value
            
            sendActionsForControlEvents(.ValueChanged)
            
            if let _valueChangedBlock = valueChangedBlock {
                _valueChangedBlock(value: _value)
            }
        }
    }
    
    func valueAsText() -> String {
        return value % 1 == 0 ? "\(Int(value))" : "\(value)"
    }
}
