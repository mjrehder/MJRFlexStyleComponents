//
//  GenericStyleSlider.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.07.16.
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
import SnappingStepper
import DynamicColor

public protocol GenericStyleSliderDelegate {
    func textOfThumb(index: Int) -> String?
    func colorOfThumb(index: Int) -> UIColor?
    func iconOfThumb(index: Int) -> UIImage?
    func behaviourOfThumb(index: Int) -> StyledSliderThumbBehaviour?
    func textOfSeparatorLabel(index: Int) -> String?
    func colorOfSeparatorLabel(index: Int) -> UIColor?
    
    // TODO: Maybe support NSAttributedString?
}

public protocol GenericStyleSliderTouchDelegate {
    func onThumbTouchEnded(index: Int)
}

public protocol GenericStyleSliderSeparatorTouchDelegate {
    func onSeparatorTouchEnded(index: Int)
}


/**
 The Generic Style Slider is a base class intended to be extended by specialized view controls
 
 About the content layering:
 The slider has a style layer which is constructed by the style shape
 On top of the style layer is the separator label background
 On top of the separator label background is the border of the slider
 
 On top of the layers are the separator text labels
 
 On top of the separator text labels are the thumbs
 */
@IBDesignable public class GenericStyleSlider: MJRFlexBaseControl {
    var touchesBeganPoint = CGPointZero

    var thumbList = StyledSliderThumbList()
    var separatorLabels: Array<StyledLabel> = []
    
    // Animations
    let dynamicButtonAnimator = UIDynamicAnimator()
    let posUpdateTimer = PositionUpdateTimer()
    
    /// The hint label
    lazy var hintLabel: StyledLabel = LabelFactory.defaultStyledLabel()

    var hintShapeLayer = CAShapeLayer()
    
    public var sliderDelegate: GenericStyleSliderDelegate?
    public var thumbTouchDelegate: GenericStyleSliderTouchDelegate?
    public var separatorTouchDelegate: GenericStyleSliderSeparatorTouchDelegate?
    
    // MARK: - Deallocating position update timer
    
    deinit {
        self.posUpdateTimer.stop()
    }
    
    // MARK: - Laying out Subviews
    
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
    @IBInspectable public var direction: StyledControlDirection = .Horizontal {
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
            self.assignSeparatorTexts()
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
            self.updateValues()
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
            self.updateValues()
        }
    }

    // MARK: - Hints

    /// The hint's style. Default's to none, so no hint will be displayed.
    @IBInspectable public var hintStyle: ShapeStyle = .None {
        didSet {
            self.applyHintStyle(hintStyle)
        }
    }
    
    // MARK: - Thumbs
    
    /// The thumb represented as a ratio of the component. For example if the width of the control is 30px and the ratio is 0.5, the thumb width will be equal to 15px when in horizontal layout. When this is not set then the thumb size will be a square using the minimum size of the control. Defaults to nil.
    @IBInspectable public var thumbRatio: CGFloat? = nil {
        didSet {
            layoutComponents()
        }
    }
    
    /// The thumb represented as an absoulte size in the component. When this is not set, then the thumb size will be a square using the minimum size of the control or if thumbRatio is set, then the ratio is used. The thumbSize overrules the thumbRatio, if both are set. Defaults to nil.
    @IBInspectable public var thumbSize: CGSize? = nil {
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
    
    /// The font of the thumb labels
    @IBInspectable public var thumbFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.font = thumbFont
            }
        }
    }

    /// The thumbs text colors. Default's to black
    @IBInspectable public var thumbTextColor: UIColor = .blackColor() {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.textColor = thumbTextColor
            }
        }
    }
    
    /// The thumbs border color.
    @IBInspectable public var thumbBorderColor: UIColor? {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }
    
    /// The thumbs border width. Default's to 1.0
    @IBInspectable public var thumbBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }

    @IBInspectable public var thumbSnappingBehaviour: StyledSliderThumbBehaviour = .Freeform {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.behaviour = self.sliderDelegate?.behaviourOfThumb(thumb.index) ?? thumbSnappingBehaviour
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
    
    /// The font of the separators labels
    @IBInspectable public var separatorFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            for sep in self.separatorLabels {
                sep.font = separatorFont
            }
        }
    }
    
    /// The separators's text colors. Default's to black
    @IBInspectable public var separatorTextColor: UIColor = .blackColor() {
        didSet {
            for sep in self.separatorLabels {
                sep.textColor = separatorTextColor
            }
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
    
    /// The thumb and hint numeric representation. Defaults to nil, which means no formatting.
    @IBInspectable public var numberFormatString: String? {
        didSet {
            self.assignThumbTexts()
        }
    }
    
    // MARK: - Control Style
    
    /// The view’s background color.
    @IBInspectable override public var styleColor: UIColor? {
        didSet {
            self.applyStyle(self.style)
            
            if thumbBackgroundColor == nil {
                for thumb in self.thumbList.thumbs {
                    thumb.backgroundColor = backgroundColor?.lighterColor()
                }
            }
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
            thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? thumbBackgroundColor ?? backgroundColor?.lighterColor()
            thumb.style       = style
            thumb.borderColor = thumbBorderColor
            thumb.borderWidth = thumbBorderWidth
            thumb.backgroundIcon = self.sliderDelegate?.iconOfThumb(thumb.index)
        }
    }

    func applySeparatorStyle(style: ShapeStyle) {
        var idx = 0
        for sep in self.separatorLabels {
            sep.style = style
            sep.backgroundColor = .clearColor()
            sep.borderColor = separatorBorderColor
            sep.borderWidth = separatorBorderWidth
            idx += 1
        }
    }

    func createSeparatorLayer(layerRect: CGRect) -> CAShapeLayer {
        // Add layer with separator background colors
        var rectColors: [(CGRect, UIColor)] = []
        var idx = 0
        for sep in self.separatorLabels {
            let bgColor = self.sliderDelegate?.colorOfSeparatorLabel(idx) ?? separatorBackgroundColor
            rectColors.append((sep.frame, bgColor ?? .clearColor()))
            idx += 1
        }
        let sepLayer = StyledShapeLayer.createShape(style, bounds: layerRect, shapeStyle: self.separatorStyle, colorRects: rectColors)
        return sepLayer
    }
    
    func applyHintStyle(style: ShapeStyle) {
        hintLabel.style = style
        
        let sLayer = StyledShapeLayer.createHintShapeLayer(hintLabel, fillColor: thumbBackgroundColor?.lighterColor().CGColor)

        if self.hintShapeLayer.superlayer != nil {
            self.hintLabel.layer.replaceSublayer(self.hintShapeLayer, with: sLayer)
        }
        else {
            self.hintLabel.layer.addSublayer(sLayer)
        }
        
        self.hintShapeLayer = sLayer
    }
    
    override func applyStyle(style: FlexShapeStyle) {
        let bgColor: UIColor = self.styleColor ?? backgroundColor ?? .clearColor()
        let layerRect = self.marginsForRect(bounds, margins: backgroundMargins)
        let bgsLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: bgColor)
        
        let sepLayer = self.createSeparatorLayer(layerRect)
        bgsLayer.addSublayer(sepLayer)
        
        // Add layer with border, if required
        if let borderColor = borderColor {
            let bLayer = StyledShapeLayer.createShape(style, bounds: layerRect, color: .clearColor(), borderColor: borderColor, borderWidth: borderWidth)
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        
        styleLayer = bgsLayer
        styleLayer.frame = layerRect
    }
    
    // MARK: - Private View

    func sizeOfTextLabel(label: StyledLabel) -> CGSize? {
        if let font = label.font, text = label.text {
            let textString = text as NSString
            let textAttributes = [NSFontAttributeName: font]
            return textString.boundingRectWithSize(self.marginsForRect(bounds, margins: backgroundMargins).size, options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil).size
        }
        return nil
    }
    
    func assignSeparatorOpacity(idx: Int) {
        if idx > 0 {
            let sep = self.separatorLabels[idx]
            if let tSize = self.sizeOfTextLabel(sep) {
                let lp = self.thumbList.getPrincipalPositionValue(self.thumbList.thumbs[idx-1].center)
                let hp = self.thumbList.higherPosForThumb(idx-1)
                let tS = self.thumbList.getPrincipalSizeValue(tSize) * 1.5
                let xp = tS  / (hp - lp)
                let opa: CGFloat
                if xp < 0.0 {
                    opa = 0.0
                }
                else {
                    let xt = (hp - lp) / tS
                    opa = xt >= 1.0 ? 1.0 : xt * xt * xt
                }
                let sepColor = self.separatorTextColor
                sep.textColor = UIColor(red: sepColor.redComponent, green: sepColor.greenComponent, blue: sepColor.blueComponent, alpha: opa)
                if idx == 1 {
                    let psep = self.separatorLabels[idx-1]
                    psep.textColor = UIColor(red: sepColor.redComponent, green: sepColor.greenComponent, blue: sepColor.blueComponent, alpha: 1.0 - opa)
                }
            }
        }
    }
    
    func assignSeparatorTextOpacities() {
        for idx in 0..<self.separatorLabels.count {
            self.assignSeparatorOpacity(idx)
        }
    }
    
    func separatorForThumb(thumbIndex: Int) -> StyledLabel {
        return self.separatorLabels[thumbIndex+1]
    }
    
    func getThumbSize() -> CGSize {
        // The thumbSize has precedence
        if let ts = self.thumbSize {
            return ts
        }
        // Use the ratio if set
        if let ratio = self.thumbRatio {
            if self.direction == .Horizontal {
                return CGSizeMake(bounds.width * ratio, bounds.height)
            }
            else {
                return CGSizeMake(bounds.width, bounds.height * ratio)
            }
        }
        // Default to the controls minimum bound, which will result in a square thumb
        let s = min(self.bounds.width, self.bounds.height)
        return CGSizeMake(s, s)
    }
    
    override func layoutComponents() {
        self.thumbList.bounds = self.bounds
        let thumbSize = self.getThumbSize()
        for thumb in self.thumbList.thumbs {
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            if self.direction == .Horizontal {
                thumb.frame = CGRect(x: pos.x - thumbSize.width / 2.0, y: (bounds.height - thumbSize.height) / 2.0, width: thumbSize.width, height: thumbSize.height)
            }
            else {
                thumb.frame = CGRect(x: (bounds.width - thumbSize.width) / 2.0, y: pos.y - thumbSize.height / 2.0, width: thumbSize.width, height: thumbSize.height)
            }
        }

        hintLabel.frame = CGRect(x: hintLabel.frame.origin.x, y: hintLabel.frame.origin.y, width: thumbSize.width, height: thumbSize.height)

        self.layoutSeparators()

        applyThumbStyle(thumbStyle)
        applySeparatorStyle(separatorStyle)
        applyStyle(style)
        applyHintStyle(hintStyle)

        self.assignThumbTexts()
        self.assignSeparatorTexts()
        self.assignSeparatorTextOpacities()
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
                weakSelf.assignSeparatorTextOpacities()
            }
        }
    }
    
    // MARK: - Responding to Gesture Events
    
    func setupGestures() {
        for thumb in self.thumbList.thumbs {
            self.setupThumbGesture(thumb)
        }
    }
    
    func setupSeparatorGesture(separator: StyledLabel) {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(GenericStyleSlider.separatorTouched))
        separator.addGestureRecognizer(touchGesture)
    }
    
    func separatorTouched(sender: UITapGestureRecognizer) {
        if let separator = sender.view as? StyledLabel, index = self.getSeparatorIndex(separator) {
            switch sender.state {
            case .Ended:
                self.separatorTouchDelegate?.onSeparatorTouchEnded(index)
            default:
                break
            }
        }
    }

    func setupThumbGesture(thumb: StyledSliderThumb) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GenericStyleSlider.sliderPanned))
        thumb.addGestureRecognizer(panGesture)

        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(GenericStyleSlider.thumbTouched))
        touchGesture.requireGestureRecognizerToFail(panGesture)
        thumb.addGestureRecognizer(touchGesture)
    }
    
    func thumbTouched(sender: UITapGestureRecognizer) {
        if let thumb = sender.view as? StyledSliderThumb {
            switch sender.state {
            case .Ended:
                self.thumbTouchDelegate?.onThumbTouchEnded(thumb.index)
            default:
                break
            }
        }
    }

    func sliderPanned(sender: UIPanGestureRecognizer) {
        if let thumb = sender.view as? StyledSliderThumb {
            switch sender.state {
            case .Began:
                if case .None = hintStyle {} else {
                    hintLabel.alpha  = 0
                    
                    superview?.addSubview(hintLabel)
                    
                    UIView.animateWithDuration(0.2) {
                        self.hintLabel.alpha = 1.0
                    }
                }
                touchesBeganPoint = sender.locationInView(self)

                self.dynamicButtonAnimator.removeBehavior(thumb.snappingBehavior)
                
                thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index)?.lighterColor() ?? thumbBackgroundColor?.lighterColor()
                hintLabel.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index)?.lighterColor() ?? thumbBackgroundColor?.lighterColor()
                
            case .Changed:
                if thumb.behaviour == .FixateToLower || thumb.behaviour == .FixateToHigher || thumb.behaviour == .FixateToCenter {
                    self.thumbList.applyThumbBehaviour(thumb)
                    break
                }
                let translationInView = sender.translationInView(thumb)
                
                let tiv = self.thumbList.getPrincipalPositionValue(translationInView)
                let tb = self.thumbList.getPrincipalPositionValue(touchesBeganPoint)
                self.thumbList.updateThumbPosition(tiv+tb, thumbIndex: thumb.index)

                if case .None = hintStyle {} else {
                    let cp = CGPoint(x: frame.origin.x + thumb.center.x, y: (frame.origin.y - thumb.bounds.height - hintLabel.bounds.height / 2) + thumb.center.y)
                    hintLabel.center = cp
                }
                
                let v = self.thumbList.getValueFromThumbPos(thumb.index)
                self.updateValue(thumb.index, value: v, finished: false)
                hintLabel.text = valueAsText(v)

                self.layoutSeparators()
                self.assignSeparatorTextOpacities()

            case .Ended, .Failed, .Cancelled:
                if case .None = hintStyle {} else {
                    UIView.animateWithDuration(0.2, animations: {
                        self.hintLabel.alpha = 0.0
                    }) { _ in
                        self.hintLabel.removeFromSuperview()
                    }
                }
                self.thumbList.applyThumbBehaviour(thumb)
                thumb.snappingBehavior.action = { [weak self] in
                    if let weakSelf = self {
                        for thumb in weakSelf.thumbList.thumbs {
                            let v = weakSelf.thumbList.getValueFromThumbPos(thumb.index)
                            weakSelf.updateValue(thumb.index, value: v, finished: false)
                        }
                        weakSelf.layoutSeparators()
                        weakSelf.assignSeparatorTextOpacities()
                    }
                }
                self.dynamicButtonAnimator.addBehavior(thumb.snappingBehavior)
                
                thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? thumbBackgroundColor ?? backgroundColor?.lighterColor()

                let v = self.values[thumb.index]
                self.notifyOfValueChanged(v, index: thumb.index)
                
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
        let sep = LabelFactory.defaultStyledLabel()
        sep.backgroundColor = self.sliderDelegate?.colorOfSeparatorLabel(self.separatorLabels.count) ?? self.separatorBackgroundColor
        sep.font = self.separatorFont
        sep.textColor = self.separatorTextColor
        self.separatorLabels.append(sep)
        self.addSubview(sep)
        self.setupSeparatorGesture(sep)
    }
    
    func getSeparatorIndex(separator: StyledLabel) -> Int? {
        var index: Int = 0
        for sep in self.separatorLabels {
            if sep == separator {
                return index
            }
            index += 1
        }
        return nil
    }
    
    func assignSeparatorTexts() {
        for idx in 0..<self.separatorLabels.count {
            let sep = self.separatorLabels[idx]
            sep.text = self.sliderDelegate?.textOfSeparatorLabel(idx)
        }
    }

    func addThumb(value: Double) {
        let thumb = LabelFactory.defaultStyledThumb()
        thumb.index = self.thumbList.thumbs.count
        thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? self.thumbBackgroundColor
        thumb.font = self.thumbFont
        thumb.textColor = self.thumbTextColor
        thumb.behaviour = self.sliderDelegate?.behaviourOfThumb(thumb.index) ?? self.thumbSnappingBehaviour
        self.thumbList.thumbs.append(thumb)
        self.addSubview(thumb)
        self.thumbList.applyThumbBehaviour(thumb)
        self.setupThumbGesture(thumb)
    }

    func assignThumbText(index: Int) {
        let thumb = self.thumbList.thumbs[index]
        if let delTT = self.sliderDelegate?.textOfThumb(index) {
            thumb.text = delTT
        }
        else if thumbText == nil {
            thumb.text = self.valueAsText(_values[thumb.index])
        }
        else {
            thumb.text = self.thumbText
        }
    }
    
    func assignThumbTexts() {
        for idx in 0..<self.thumbList.thumbs.count {
            self.assignThumbText(idx)
        }
    }

    func clampValue(value: Double) -> Double {
        var newVal = value
        if newVal > maximumValue {
            newVal = maximumValue
        }
        if newVal < minimumValue {
            newVal = minimumValue
        }
        return newVal
    }
    
    func updateValue(index: Int, value: Double, finished: Bool = true) {
        let newVal = self.clampValue(value)
        let oldVal = _values[index]
        _values[index] = newVal
        self.assignThumbText(index)
        
        if (continuous || finished) && oldVal != newVal {
            self.notifyOfValueChanged(newVal, index: index)
        }
    }
    
    func updateValues() {
        for i in 0..<self._values.count {
            let val = self._values[i]
            self.updateValue(i, value: val)
        }
    }

    func notifyOfValueChanged(value: Double, index: Int) {
        sendActionsForControlEvents(.ValueChanged)
        
        if let _valueChangedBlock = valueChangedBlock {
            _valueChangedBlock(value: value, index: index)
        }
    }
    
    func initComponent() {
        self.posUpdateTimer.stop()
        if self.continuous {
            self.startPositionUpdateNotification()
        }
        
        self.hintLabel.font      = thumbFont
        self.hintLabel.textColor = thumbTextColor
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
            let nVal = self.clampValue(value)
            newVals.append(nVal)
        }
        _values = newVals.sort()
        for _ in 0..._values.count {
            self.addSeparator()
        }
        for value in _values {
            self.addThumb(value)
        }
        self.layoutComponents()
    }
    
    func valueAsText(value: Double) -> String {
        if let formatStr = self.numberFormatString {
            return String(format: formatStr, value)
        }
        return value % 1 == 0 ? "\(Int(value))" : "\(value)"
    }

}
