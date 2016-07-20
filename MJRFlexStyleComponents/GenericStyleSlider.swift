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
    var thumbList = StyledSliderThumbList()
    
    // TODO (private lists)
    // list of seperator labels
    
    // delegate decl: GenericStyleSliderDelegate
    
    // MARK: - Laying out Subviews
    
    /// Lays out subviews
    public override func layoutSubviews() {
        super.layoutSubviews()        
        self.layoutComponents()
    }
    
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
     The direction of the control
     
     The default is horizontal
     */
    @IBInspectable public var direction: StyleSliderDirection = .Horizontal {
        didSet {
            // TODO
        }
    }

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
            self.thumbList.minimumValue = minimumValue
            // TODO
//            updateValue(max(_value, minimumValue), finished: true)
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
            self.thumbList.maximumValue = maximumValue
            
            // TODO
            //updateValues(min(_values, maximumValue), finished: true)
        }
    }
    
    /// The thumb width represented as a ratio of the component width. For example if the width of the control is 30px and the ratio is 0.5, the thumb width will be equal to 15px. Defaults to 0.1.
    @IBInspectable public var thumbWidthRatio: CGFloat = 0.1 {
        didSet {
            layoutComponents()
        }
    }
    
    /// The thumb's background color. If nil the thumb color will be lighter than the background color. Defaults to nil.
    @IBInspectable public var thumbBackgroundColor: UIColor? {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.backgroundColor = thumbBackgroundColor
            }
        }
    }
    
    /// The thumb text to display. If the text is nil it will display the current value of the stepper. Defaults with empty string.
    @IBInspectable public var thumbText: String? = "" {
        didSet {
            self.assignThumbTexts()
        }
    }
    
    /**
     The numeric values.
     
     When the values change, the control sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.
     
     The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
     */
    var values: [Double] {
        get {
            return _values
        }
        set (newValue) {
            updateValues(newValue, finished: true)
        }
    }
    
    var _values: [Double] = [] {
        didSet {
            self.assignThumbTexts()
/*            hintLabel.text = valueAsText()*/
        }
    }
    
    // MARK: - Private

    func layoutComponents() {
        self.thumbList.bounds = self.bounds
        for thumb in self.thumbList.thumbs {
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            if self.direction == .Horizontal {
                let thumbWidth  = bounds.width * thumbWidthRatio
                thumb.frame = CGRect(x: pos.x - thumbWidth / 2.0, y: 0, width: thumbWidth, height: bounds.height)
            }
            else {
                let thumbWidth  = bounds.height * thumbWidthRatio
                thumb.frame = CGRect(x: 0, y: pos.y - thumbWidth / 2.0, width: bounds.width, height: thumbWidth)
            }
        }
        
//        snappingBehavior = SnappingStepperBehavior(item: thumbLabel, snapToPoint: CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5))
/*
        CustomShapeLayer.createHintShapeLayer(hintLabel, fillColor: thumbBackgroundColor?.lighterColor().CGColor)
        
        applyThumbStyle(thumbStyle)
        applyStyle(style)
        applyHintStyle(hintStyle)
 */
        self.assignThumbTexts()
    }
    
    // TODO: Most of this goes into the Thumb classes, which must be children of this control
    
    let dynamicButtonAnimator = UIDynamicAnimator()
    
    var styleLayer = CAShapeLayer()
    var styleColor: UIColor? = .clearColor()
    
    var touchesBeganPoint    = CGPointZero
    var initialValue: Double = -1
    var factorValue: Double  = 0
    // TODO
//    var oldValue = Double.infinity * -1
        
    // MARK: - Internal

    // MARK: - Responding to Gesture Events
    
    func setupGestures() {
        for thumb in self.thumbList.thumbs {
            self.setupThumbGesture(thumb)
        }
    }
    
    func setupThumbGesture(thumb: StyledSliderThumb) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GenericStyleSlider.sliderPanned))
        thumb.addGestureRecognizer(panGesture)
    }
    
    func sliderPanned(sender: UIPanGestureRecognizer) {
        if let thumb = sender.view as? StyledSliderThumb {
            switch sender.state {
            case .Began:
                // TODO
                /*            if case .None = hintStyle {} else {
                 hintLabel.alpha  = 0
                 hintLabel.center = CGPoint(x: center.x, y: center.y - bounds.height - hintLabel.bounds.height / 2)
                 
                 superview?.addSubview(hintLabel)
                 
                 UIView.animateWithDuration(0.2) {
                 self.hintLabel.alpha = 1.0
                 }
                 }
                 */
                touchesBeganPoint = sender.locationInView(self)
                // TODO
//                dynamicButtonAnimator.removeBehavior(snappingBehavior)
                
                thumb.backgroundColor = thumbBackgroundColor?.lighterColor()
                // TODO
//                hintLabel.backgroundColor  = thumbBackgroundColor?.lighterColor()
                
            case .Changed:
                let translationInView = sender.translationInView(thumb)
                
                let tiv = self.thumbList.getPrincipalPositionValue(translationInView)
                let tb = self.thumbList.getPrincipalPositionValue(touchesBeganPoint)
                self.thumbList.updateThumbPosition(tiv+tb, thumbIndex: thumb.index)
                
                let v = self.thumbList.getValueFromThumbPos(thumb.index)
                self.updateValue(thumb.index, value: v)

            case .Ended, .Failed, .Cancelled:
                // TODO
/*                if case .None = hintStyle {} else {
                    UIView.animateWithDuration(0.2, animations: {
                        self.hintLabel.alpha = 0.0
                    }) { _ in
                        self.hintLabel.removeFromSuperview()
                    }
                }
  */
                // TODO
//            dynamicButtonAnimator.addBehavior(snappingBehavior)
                
                thumb.backgroundColor = thumbBackgroundColor ?? backgroundColor?.lighterColor()
                
            case .Possible:
                break
            }
        }
    }

    func addThumb(value: Double) {
        let thumb = StyledSliderThumb()
        thumb.backgroundColor = self.thumbBackgroundColor
        thumb.index = self.thumbList.thumbs.count
        self.thumbList.thumbs.append(thumb)
        self.addSubview(thumb)
        
        // TODO: There must be more to this
        
        self.setupThumbGesture(thumb)
        self.setNeedsLayout()
    }

    func assignThumbText(index: Int) {
        let thumb = self.thumbList.thumbs[index]
        if thumbText == nil {
            thumb.text = valueAsText(_values[thumb.index])
        }
        else {
            thumb.text = thumbText
        }
    }
    
    func assignThumbTexts() {
        for idx in 0..<self.thumbList.thumbs.count {
            self.assignThumbText(idx)
        }
    }

    func updateValue(index: Int, value: Double) {
        _values[index] = value
        self.assignThumbText(index)
    }
    
    func updateValues(values: [Double], finished: Bool = true) {
        var newVals: [Double] = []
        for value in values {
            var nVal = value
            if nVal < minimumValue {
                nVal = maximumValue
            }
            else if nVal > maximumValue {
                nVal = minimumValue
            }
            /* TODO
            if (continuous || finished) && oldValue != _value {
                oldValue = _value
                
                sendActionsForControlEvents(.ValueChanged)
                
                if let _valueChangedBlock = valueChangedBlock {
                    _valueChangedBlock(value: _value)
                }
            }*/
            newVals.append(nVal)
        }
        _values = newVals.sort()
        for value in _values {
            self.addThumb(value)
        }
    }
    
    func valueAsText(value: Double) -> String {
        return value % 1 == 0 ? "\(Int(value))" : "\(value)"
    }
}
