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
    func textOfThumb(index: Int) -> String?
    func colorOfThumb(index: Int) -> UIColor?
    func textOfSeperatorLabel(index: Int) -> String?
    func colorOfSeperatorLabel(index: Int) -> UIColor?
}

// TODO: enum dimension (1-Dim, 2-Dim)

@IBDesignable public final class GenericStyleSlider: UIControl {
    var touchesBeganPoint = CGPointZero

    var thumbList = StyledSliderThumbList()
    var separatorLabels: Array<StyledLabel> = []
    
    let dynamicButtonAnimator = UIDynamicAnimator()
    let posUpdateTimer = PositionUpdateTimer()
    
    var styleLayer = CAShapeLayer()
    
    public var sliderDelegate: GenericStyleSliderDelegate?
    
    // MARK: - Deallocating position update timer
    
    deinit {
        self.posUpdateTimer.stop()
    }
    
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
    public var valueChangedBlock: ((value: Double, index: Int) -> Void)?

    /**
     The continuous vs. noncontinuous state of the slider.
     
     If true, value change events are sent immediately when the value changes during user interaction. If false, a value change event is sent when user interaction ends.
     When a snapping behaviour is chosen for the thumbs, then the continuous property will trigger a notification in certain intervals
     
     The default value for this property is true.
     */
    @IBInspectable public var continuous: Bool = true {
        didSet {
            self.initComponent()
        }
    }

    /**
     The notification delay is the delay between each notification, if the continuous property is true
     
     Default value is 0.1s
     */
    @IBInspectable public var notificationDelay: NSTimeInterval = 0.1  {
        didSet {
            self.initComponent()
        }
    }
    
    /**
     The direction of the control
     
     The default is horizontal
     */
    @IBInspectable public var direction: StyleSliderDirection = .Horizontal {
        didSet {
            self.thumbList.direction = direction
            self.layoutComponents()
        }
    }

    /**
     The numeric values.
     
     When the values change, the control sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.
     
     This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
     */
    var values: [Double] {
        get {
            return _values
        }
        set (newValue) {
            initValues(newValue)
            self.layoutComponents()
        }
    }
    
    var _values: [Double] = [] {
        didSet {
            self.assignThumbTexts()
            /*            hintLabel.text = valueAsText()*/
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

    // MARK: - Thumbs
    
    /// The thumb represented as a ratio of the component. For example if the width of the control is 30px and the ratio is 0.5, the thumb width will be equal to 15px when in horizontal layout. Defaults to 0.1.
    @IBInspectable public var thumbRatio: CGFloat = 0.1 {
        didSet {
            layoutComponents()
        }
    }
    
    /// The thumb's background colors. If nil the thumb color will be lighter than the background color. Defaults to nil.
    /// Use the delegate to get fine grained control over each thumb
    @IBInspectable public var thumbBackgroundColor: UIColor? {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.backgroundColor = thumbBackgroundColor
            }
        }
    }
    
    /// The thumb text to display. If the text is nil it will display the current value of the stepper. Defaults with empty string.
    /// Use the delegate to get fine grained control over each thumb
    @IBInspectable public var thumbText: String? = "" {
        didSet {
            self.assignThumbTexts()
        }
    }
    
    /// The thumb's style. Default's to box
    @IBInspectable public var thumbStyle: ShapeStyle = .Box {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }
    
    /// The thumbs's border color.
    @IBInspectable public var thumbBorderColor: UIColor? {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }
    
    /// The thumbs's border width. Default's to 1.0
    @IBInspectable public var thumbBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }

    @IBInspectable public var thumbSnappingBehaviour: StyledSliderThumbBehaviour = .Freeform {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.behaviour = thumbSnappingBehaviour
            }
        }
    }
    
    // MARK: - Separators
    
    /// The separator represented as a ratio of the component. Defaults to 1.
    @IBInspectable public var separatorRatio: CGFloat = 1.0 {
        didSet {
            layoutComponents()
        }
    }

    /// The separator's background colors. If nil the separator color will be clear color. Defaults to nil.
    /// Use the delegate to get fine grained control over each separator
    @IBInspectable public var separatorBackgroundColor: UIColor? {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }

    @IBInspectable public var separatorStyle: ShapeStyle = .Box {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }

    /// The separators border color.
    @IBInspectable public var separatorBorderColor: UIColor? {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }
    
    /// The thumbs's border width. Default's to 1.0
    @IBInspectable public var separatorBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }
    
    // MARK: - Control Style
    
    /// The view's style. Default's to box.
    @IBInspectable public var style: ShapeStyle = .Box {
        didSet {
            self.applyStyle(style)
        }
    }
    
    /// The view’s background color.
    @IBInspectable public var styleColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
            
            if thumbBackgroundColor == nil {
                for thumb in self.thumbList.thumbs {
                    thumb.backgroundColor = backgroundColor?.lighterColor()
                }
            }
        }
    }

    /// The hint's style. Default's to none, so no hint will be displayed.
    @IBInspectable public var hintStyle: ShapeStyle = .None {
        didSet {
            self.applyHintStyle(hintStyle)
        }
    }
    
    /// The view's border color.
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            self.applyStyle(style)
        }
    }
    
    /// The view's border width. Default's to 1.0
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.applyStyle(style)
        }
    }
    
    /// The view’s background color.
    override public var backgroundColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
            
            if thumbBackgroundColor == nil {
                for thumb in self.thumbList.thumbs {
                    thumb.backgroundColor = backgroundColor?.lighterColor()
                }
            }
        }
    }
    
    // MARK: - Private Style

    func applyThumbStyle(style: ShapeStyle) {
        for thumb in self.thumbList.thumbs {
            thumb.style       = style
            thumb.borderColor = thumbBorderColor
            thumb.borderWidth = thumbBorderWidth
        }
    }

    func applySeparatorStyle(style: ShapeStyle) {
        for sep in self.separatorLabels {
            sep.style = style
            sep.backgroundColor = separatorBackgroundColor
            sep.borderColor = separatorBorderColor
            sep.borderWidth = separatorBorderWidth
        }
    }

    func applyHintStyle(style: ShapeStyle) {
//        hintLabel.style = style
    }
    
    func applyStyle(style: ShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clearColor()
        let sLayer: CAShapeLayer
        
        if let borderColor = borderColor {
            sLayer = StyledShapeLayer.createShape(style, bounds: bounds, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
        }
        else {
            sLayer = StyledShapeLayer.createShape(style, bounds: bounds, color: bgColor)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: sLayer)
        }
        
        styleLayer = sLayer
    }
    
    // MARK: - Private View

    func separatorForThumb(thumbIndex: Int) -> StyledLabel {
        return self.separatorLabels[thumbIndex+1]
    }
    
    func layoutComponents() {
        self.thumbList.bounds = self.bounds
        for thumb in self.thumbList.thumbs {
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            if self.direction == .Horizontal {
                let thumbWidth  = bounds.width * thumbRatio
                thumb.frame = CGRect(x: pos.x - thumbWidth / 2.0, y: 0, width: thumbWidth, height: bounds.height)
            }
            else {
                let thumbWidth  = bounds.height * thumbRatio
                thumb.frame = CGRect(x: 0, y: pos.y - thumbWidth / 2.0, width: bounds.width, height: thumbWidth)
            }
        }

        self.layoutSeparators()
        
/*
        CustomShapeLayer.createHintShapeLayer(hintLabel, fillColor: thumbBackgroundColor?.lighterColor().CGColor)
    */
        applyThumbStyle(thumbStyle)
        applySeparatorStyle(separatorStyle)
        applyStyle(style)
        applyHintStyle(hintStyle)

        self.assignThumbTexts()
    }

    func layoutSeparators() {
        for thumb in self.thumbList.thumbs {
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            let sep = self.separatorForThumb(thumb.index)
            let hp: CGFloat
            if thumb.index+1 < self.thumbList.thumbs.count {
                hp = self.thumbList.getPrincipalPositionValue(self.thumbList.getThumbPosForValue(_values[thumb.index+1], thumbIndex: thumb.index+1))
            }
            else {
                hp = self.thumbList.getPrincipalSizeValue(self.bounds.size) + self.thumbList.getPrincipalPositionValue(self.bounds.origin)
            }
            if self.direction == .Horizontal {
                let sepHeight  = bounds.height * separatorRatio
                sep.frame = CGRect(x: pos.x, y: (bounds.height - sepHeight) * 0.5 , width: hp - pos.x, height: sepHeight)
            }
            else {
                let sepHeight  = bounds.width * separatorRatio
                sep.frame = CGRect(x: (bounds.width - sepHeight) * 0.5, y: pos.y, width: sepHeight, height: hp - pos.y)
            }
        }
        // Handle first separator
        if self.separatorLabels.count > 0 {
            let sep = self.separatorLabels[0]
            let hp: CGFloat
            if self.thumbList.thumbs.count > 0 {
                hp = self.thumbList.getPrincipalPositionValue(self.thumbList.getThumbPosForValue(_values[0], thumbIndex: 0))
            }
            else {
                hp = self.thumbList.getPrincipalSizeValue(self.bounds.size) + self.thumbList.getPrincipalPositionValue(self.bounds.origin)
            }
            let pos = self.bounds.origin
            if self.direction == .Horizontal {
                let sepHeight  = bounds.height * separatorRatio
                sep.frame = CGRect(x: pos.x, y: (bounds.height - sepHeight) * 0.5 , width: hp - pos.x, height: sepHeight)
            }
            else {
                let sepHeight  = bounds.width * separatorRatio
                sep.frame = CGRect(x: (bounds.width - sepHeight) * 0.5, y: pos.y, width: sepHeight, height: hp - pos.y)
            }
        }
    }

    // MARK: - Internal

    func startPositionUpdateNotification() {
        self.posUpdateTimer.start(self.notificationDelay) { [weak self] in
            if let weakSelf = self {
                for thumb in weakSelf.thumbList.thumbs {
                    let v = weakSelf.thumbList.getValueFromThumbPos(thumb.index)
                    weakSelf.updateValue(thumb.index, value: v, finished: false)
                }
                weakSelf.layoutSeparators()
            }
        }
    }
    
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

                self.dynamicButtonAnimator.removeBehavior(thumb.snappingBehavior)
                
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
                
                self.layoutSeparators()

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
                self.thumbList.applyThumbBehaviour(thumb)
                self.dynamicButtonAnimator.addBehavior(thumb.snappingBehavior)
                
                thumb.backgroundColor = thumbBackgroundColor ?? backgroundColor?.lighterColor()
                
            case .Possible:
                break
            }
        }
    }

    func removeAllSeparators() {
        for sep in self.separatorLabels {
            sep.removeFromSuperview()
        }
        self.separatorLabels.removeAll()
    }
    
    func addSeparator() {
        let sep = StyledLabel()
        sep.backgroundColor = self.separatorBackgroundColor
        self.separatorLabels.append(sep)
        self.addSubview(sep)
        // TODO: There must be more to this
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

    func updateValue(index: Int, value: Double, finished: Bool = true) {
        let oldVal = _values[index]
        _values[index] = value
        self.assignThumbText(index)

        if (continuous || finished) && oldVal != value {
            sendActionsForControlEvents(.ValueChanged)
            
            if let _valueChangedBlock = valueChangedBlock {
                _valueChangedBlock(value: value, index: index)
            }
        }
    }
    
    func initComponent() {
        self.posUpdateTimer.stop()
        if self.continuous {
            self.startPositionUpdateNotification()
        }
    }
    
    func initValues(values: [Double]) {
        self.initComponent()
        
        if self.styleLayer.superlayer == nil {
            self.layer.addSublayer(styleLayer)
        }
        self.thumbList.removeAllThumbs()
        self.removeAllSeparators()
        var newVals: [Double] = []
        for value in values {
            var nVal = value
            if nVal < minimumValue {
                nVal = maximumValue
            }
            else if nVal > maximumValue {
                nVal = minimumValue
            }
            newVals.append(nVal)
        }
        _values = newVals.sort()
        for _ in 0..._values.count {
            self.addSeparator()
        }
        for value in _values {
            self.addThumb(value)
        }
    }
    
    func valueAsText(value: Double) -> String {
        return value % 1 == 0 ? "\(Int(value))" : "\(value)"
    }
}
