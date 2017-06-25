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
import StyledLabel
import DynamicColor

public protocol GenericStyleSliderDelegate {
    func textOfThumb(_ index: Int) -> String?
    func attributedTextOfThumb(_ index: Int) -> NSAttributedString?
    func colorOfThumb(_ index: Int) -> UIColor?
    func iconOfThumb(_ index: Int) -> UIImage?
    func iconOfSeparator(_ index: Int) -> UIImage?
    func behaviourOfThumb(_ index: Int) -> StyledSliderThumbBehaviour?
    func textOfSeparatorLabel(_ index: Int) -> String?
    func adaptOpacityForSeparatorLabel(_ index: Int) -> Bool
    func attributedTextOfSeparatorLabel(_ index: Int) -> NSAttributedString?
    func colorOfSeparatorLabel(_ index: Int) -> UIColor?
    func sizeInfoOfThumb(_ index: Int) -> SliderThumbSizeInfo?
    func sizeInfoOfSeparator(_ index: Int) -> SliderSeparatorSizeInfo?
    func triggerEventValues(_ index: Int) -> (Double?, Double?)
    func thumbValueLimits(_ index: Int) -> (Double?, Double?)
}

public protocol GenericStyleSliderTouchDelegate {
    func onThumbTouchEnded(_ index: Int)
}

public protocol GenericStyleSliderSeparatorTouchDelegate {
    func onSeparatorTouchEnded(_ index: Int)
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
@IBDesignable open class GenericStyleSlider: FlexBaseControl {
    var touchesBeganPoint = CGPoint.zero

    var thumbList = StyledSliderThumbList()
    var separatorLabels: Array<StyledSliderSeparator> = []
    
    // Animations
    let dynamicButtonAnimator = UIDynamicAnimator()
    let posUpdateTimer = PositionUpdateTimer()
    
    /// The hint label
    lazy var hintLabel: StyledLabel = LabelFactory.defaultStyledLabel()

    var hintShapeLayer = CAShapeLayer()
    
    open var sliderDelegate: GenericStyleSliderDelegate?
    open var thumbTouchDelegate: GenericStyleSliderTouchDelegate?
    open var separatorTouchDelegate: GenericStyleSliderSeparatorTouchDelegate?
    
    // MARK: - Deallocating position update timer
    
    deinit {
        self.posUpdateTimer.stop()
    }
    
    // MARK: - Laying out Subviews
    
    open override func layoutSubviews() {
        super.layoutSubviews()        
        self.layoutComponents()
    }
    
    /**
     Block to be notify when the value of the slider change.
     
     This is a convenient alternative to the `addTarget:Action:forControlEvents:` method of the `UIControl`.
     */
    open var valueChangedBlock: ((_ value: Double, _ index: Int) -> Void)?

    /**
     The continuous vs. noncontinuous state of the slider.
     
     If true, value change events are sent immediately when the value changes during user interaction. If false, a value change event is sent when user interaction ends.
     When a snapping behaviour is chosen for the thumbs, then the continuous property will trigger a notification in certain intervals
     
     The default value for this property is true.
     */
    @IBInspectable open var continuous: Bool = true {
        didSet {
            self.initComponent()
        }
    }

    /**
     The notification delay is the delay between each notification, if the continuous property is true
     
     Default value is 0.1s
     */
    @IBInspectable open var notificationDelay: TimeInterval = 0.1  {
        didSet {
            self.initComponent()
        }
    }
    
    /**
     The direction of the control
     
     The default is horizontal
     */
    @IBInspectable open var direction: StyledControlDirection = .horizontal {
        didSet {
            self.thumbList.direction = direction
            self.setNeedsLayout()
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
            self.setNeedsLayout()
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
    @IBInspectable open var minimumValue: Double = 0 {
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
    @IBInspectable open var maximumValue: Double = 100 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
            self.thumbList.maximumValue = maximumValue
            self.updateValues()
        }
    }

    /**
     Trigger events can be configured, so that the event handler is called within on swipe gesture cycle.
     Parameters are: value index and value
     **/
    open var eventTriggerHandler: ((Int, Double)->Void)?
    
    /// Calls the event handler when the value of a slider is swiped below the given threshold.
    open var eventTriggerBelow: Double?
    /// Calls the event handler when the value of a slider is swiped above the given threshold.
    open var eventTriggerAbove: Double?
    
    
    // MARK: - Hints

    /// The hint's style. Default's to none, so no hint will be displayed.
    @IBInspectable open var hintStyle: ShapeStyle = .none {
        didSet {
            self.applyHintStyle(hintStyle)
        }
    }
    
    // MARK: - Thumbs
    
    /// The thumb represented as a ratio of the component. For example if the width of the control is 30px and the ratio is 0.5, the thumb width will be equal to 15px when in horizontal layout. When this is not set then the thumb size will be a square using the minimum size of the control. Defaults to nil.
    @IBInspectable open var thumbRatio: CGFloat? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The thumb represented as an absoulte size in the component. When this is not set, then the thumb size will be a square using the minimum size of the control or if thumbRatio is set, then the ratio is used. The thumbSize overrules the thumbRatio, if both are set. Defaults to nil.
    @IBInspectable open var thumbSize: CGSize? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// The minimum thumb size represented as an absoulte size in the component. The thumb size will never be smaller than this value, but ignored when nil. Defaults to nil.
    @IBInspectable open var thumbMinimumSize: CGSize? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// The maximum thumb size represented as an absoulte size in the component. The thumb size will never be larger than this value, but ignored when nil. Defaults to nil.
    @IBInspectable open var thumbMaximumSize: CGSize? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The thumb's background colors. If nil the thumb color will be lighter than the background color. Defaults to nil.
    /// Use the delegate to get fine grained control over each thumb
    @IBInspectable open var thumbBackgroundColor: UIColor? {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.backgroundColor = thumbBackgroundColor
            }
        }
    }
    
    /// The thumb text to display. If the text is nil it will display the current value of the stepper. Defaults with empty string.
    /// Use the delegate to get fine grained control over each thumb
    @IBInspectable open var thumbText: String? = "" {
        didSet {
            self.assignThumbTexts()
        }
    }
    @IBInspectable open var thumbAttributedText: NSAttributedString? = nil {
        didSet {
            self.assignThumbTexts()
        }
    }
    
    /// The thumb's style. Default's to box
    @IBInspectable open dynamic var thumbStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.applyThumbStyle(thumbStyle)
            thumbStyle.styleChangeHandler = {
                newStyle in
                self.applyThumbStyle(self.thumbStyle)
            }
        }
    }
    
    /// The font of the thumb labels
    @IBInspectable open dynamic var thumbFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.font = thumbFont
            }
        }
    }

    /// The thumbs text colors. Default's to black
    @IBInspectable open dynamic var thumbTextColor: UIColor = .black {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.textColor = thumbTextColor
            }
        }
    }
    
    /// The thumbs border color.
    @IBInspectable open dynamic var thumbBorderColor: UIColor? {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }
    
    /// The thumbs border width. Default's to 1.0
    @IBInspectable open dynamic var thumbBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applyThumbStyle(thumbStyle)
        }
    }

    @IBInspectable open var thumbSnappingBehaviour: StyledSliderThumbBehaviour = .freeform {
        didSet {
            for thumb in self.thumbList.thumbs {
                thumb.behaviour = self.sliderDelegate?.behaviourOfThumb(thumb.index) ?? thumbSnappingBehaviour
            }
        }
    }
    
    // MARK: - Separators
    
    /// The separator represented as a ratio of the component. Defaults to 1.
    @IBInspectable open dynamic var separatorRatio: CGFloat = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// The separator's background colors. If nil the separator color will be clear color. Defaults to nil.
    /// Use the delegate to get fine grained control over each separator
    @IBInspectable open dynamic var separatorBackgroundColor: UIColor? {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }
    
    /// The font of the separators labels
    @IBInspectable open dynamic var separatorFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
        didSet {
            for sep in self.separatorLabels {
                sep.font = separatorFont
            }
        }
    }
    
    /// The separators's text colors. Default's to black
    @IBInspectable open dynamic var separatorTextColor: UIColor = .black {
        didSet {
            for sep in self.separatorLabels {
                sep.textColor = separatorTextColor
            }
        }
    }

    @IBInspectable open var separatorStyle: FlexShapeStyle = FlexShapeStyle(style: .box) {
        didSet {
            self.applySeparatorStyle(separatorStyle)
            separatorStyle.styleChangeHandler = {
                newStyle in
                self.applySeparatorStyle(self.separatorStyle)
            }
        }
    }

    /// The separators border color.
    @IBInspectable open dynamic var separatorBorderColor: UIColor? {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }
    
    /// The thumbs's border width. Default's to 1.0
    @IBInspectable open dynamic var separatorBorderWidth: CGFloat = 1.0 {
        didSet {
            self.applySeparatorStyle(separatorStyle)
        }
    }
    
    /// The thumb and hint numeric representation. Defaults to nil, which means no formatting.
    @IBInspectable open var numberFormatString: String? {
        didSet {
            self.assignThumbTexts()
        }
    }
    
    // MARK: - Control Style
    
    /// The view’s background color.
    @IBInspectable override open dynamic var styleColor: UIColor? {
        didSet {
            self.applyStyle(self.getStyle())
            
            if thumbBackgroundColor == nil {
                for thumb in self.thumbList.thumbs {
                    thumb.backgroundColor = backgroundColor?.lighter()
                }
            }
        }
    }
    
    /// The view’s background color.
    override open dynamic var backgroundColor: UIColor? {
        didSet {
            self.applyStyle(self.getStyle())
            
            if thumbBackgroundColor == nil {
                for thumb in self.thumbList.thumbs {
                    thumb.backgroundColor = backgroundColor?.lighter()
                }
            }
        }
    }
    
    // MARK: - Private Style

    func applyThumbStyle(_ style: FlexShapeStyle) {
        for thumb in self.thumbList.thumbs {
            thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? thumbBackgroundColor ?? backgroundColor?.lighter()
            thumb.style       = style.style
            thumb.borderColor = thumbBorderColor
            thumb.borderWidth = thumbBorderWidth
            thumb.backgroundIcon = self.sliderDelegate?.iconOfThumb(thumb.index)
        }
    }

    func applySeparatorStyle(_ style: FlexShapeStyle) {
        for sep in self.separatorLabels {
            sep.style = style.style
            sep.backgroundColor = .clear
            sep.borderColor = separatorBorderColor
            sep.borderWidth = separatorBorderWidth
        }
    }

    func createSeparatorLayer(_ layerRect: CGRect) -> CAShapeLayer {
        // Add layer with separator background colors
        var rectColors: [(CGRect, UIColor)] = []
        var idx = 0
        for sep in self.separatorLabels {
            let bgColor = self.sliderDelegate?.colorOfSeparatorLabel(idx) ?? separatorBackgroundColor
            rectColors.append((sep.frame, bgColor ?? .clear))
            idx += 1
        }
        let sepLayer = StyledShapeLayer.createShape(self.getStyle(), bounds: layerRect, shapeStyle: self.separatorStyle.style, colorRects: rectColors)
        return sepLayer
    }
    
    func applyHintStyle(_ style: ShapeStyle) {
        hintLabel.style = style
        
        let sLayer = StyledShapeLayer.createHintShapeLayer(hintLabel, fillColor: thumbBackgroundColor?.lighter().cgColor)

        if self.hintShapeLayer.superlayer != nil {
            self.hintLabel.layer.replaceSublayer(self.hintShapeLayer, with: sLayer)
        }
        else {
            self.hintLabel.layer.addSublayer(sLayer)
        }
        
        self.hintShapeLayer = sLayer
    }
    
    override func applyStyle(_ style: ShapeStyle) {
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let bgsLayer = self.getBackgroundLayer(style)
        
        let sepLayer = self.createSeparatorLayer(layerRect)
        bgsLayer.addSublayer(sepLayer)
        
        // Add layer with border, if required
        if let bLayer = self.createBorderLayer(style, layerRect: layerRect) {
            bgsLayer.addSublayer(bLayer)
        }
        
        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: bgsLayer)
        }
        
        styleLayer = bgsLayer
        styleLayer.frame = layerRect
    }
    
    // MARK: - Private View

    func sizeOfTextLabel(_ label: StyledLabel) -> CGSize? {
        if let font = label.font, let text = label.text {
            let textString = text as NSString
            let textAttributes = [NSFontAttributeName: font]
            return textString.boundingRect(with: self.marginsForRect(bounds, margins: backgroundInsets).size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil).size
        }
        return nil
    }
    
    func assignSeparatorOpacity(_ idx: Int) {
        if idx > 0 {
            let sep = self.separatorLabels[idx]
            if let tSize = self.sizeOfTextLabel(sep), sep.useOpacityForSizing {
                let lp = self.direction.principalPosition(self.thumbList.thumbs[idx-1].center)
                let hp = self.thumbList.higherPosForThumb(idx-1)
                let tS = self.direction.principalSize(tSize) * 1.5
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
    
    func separatorForThumb(_ thumbIndex: Int) -> StyledSliderSeparator {
        return self.separatorLabels[thumbIndex+1]
    }
    
    func getThumbSize(_ thumb: StyledSliderThumb) -> CGSize {
        let pSize = self.getPreferredThumbSize(thumb)
        
        var resSize = pSize
        
        if let sizeInfo = thumb.sizeInfo as? SliderThumbSizeInfo {
            switch sizeInfo.sizingType {
            case .fixed:
                break
            case .relativeToSlider(let min, let max):
                let pos = self.thumbList.getThumbPos(thumbIndex: thumb.index)
                let pp = self.direction.principalPosition(pos)
                let ps = self.direction.principalSize(self.bounds.size)
                resSize = self.calculateRelativeThumbSize(prefSize: pSize, min: min, max: max, pp: pp, pDiff: ps)
            case .relativeToSeparator(let min, let max):
                let pos = self.thumbList.getThumbPos(thumbIndex: thumb.index)
                let prevPos = self.thumbList.lowerPosForThumb(thumb.index)
                let nextPos = self.thumbList.higherPosForThumb(thumb.index)
                let pp = self.direction.principalPosition(pos) - prevPos
                let ps = nextPos - prevPos
                resSize = self.calculateRelativeThumbSize(prefSize: pSize, min: min, max: max, pp: pp, pDiff: ps)
            }
        }
        
        if let minSize = self.thumbMinimumSize {
            resSize = CGSize(width: max(minSize.width, pSize.width), height: max(minSize.height, pSize.height))
        }
        if let maxSize = self.thumbMaximumSize {
            resSize = CGSize(width: min(maxSize.width, pSize.width), height: min(maxSize.height, pSize.height))
        }
        return resSize
    }
    
    func calculateRelativeThumbSize(prefSize: CGSize, min: CGFloat, max: CGFloat, pp: CGFloat, pDiff: CGFloat) -> CGSize {
        var resSize = prefSize
        var ps = pDiff
        if ps < min {
            ps = min + 1.0
        }
        let offRatio = Double(pp / ps) * Double.pi
        var sizeCalc = CGFloat(sin(offRatio)) * self.direction.principalSize(prefSize)
        if sizeCalc < min {
            sizeCalc = min
        }
        if sizeCalc > max {
            sizeCalc = max
        }
        if self.direction == .horizontal {
            resSize = CGSize(width: sizeCalc, height: prefSize.height)
        }
        else {
            resSize = CGSize(width: prefSize.width, height: sizeCalc)
        }
        return resSize
    }
    
    func getPreferredThumbSize(_ thumb: StyledSliderThumb) -> CGSize {
        // The thumbSize has precedence
        if let si = thumb.sizeInfo as? SliderThumbSizeInfo, let ts = si.thumbSize ?? self.thumbSize {
            return ts
        }
        // Use the ratio if set
        if let ratio = self.thumbRatio {
            if self.direction == .horizontal {
                return CGSize(width: bounds.width * ratio, height: bounds.height)
            }
            else {
                return CGSize(width: bounds.width, height: bounds.height * ratio)
            }
        }
        // Default to the controls minimum bound, which will result in a square thumb
        let s = min(self.bounds.width, self.bounds.height)
        return CGSize(width: s, height: s)
    }
    
    override func layoutComponents() {
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let mainSizeH = self.direction.principalSize(layerRect.size) * 0.5
        
        self.thumbList.bounds = layerRect
        for thumb in self.thumbList.thumbs {
            let mainThumbPos = self.direction.principalPosition(thumb.center)
            thumb.relativeEdgeOffset = 1.0 - (abs(mainThumbPos - mainSizeH) / mainSizeH)
            let thumbSize = self.getThumbSize(thumb)
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            if self.direction == .horizontal {
                thumb.frame = CGRect(x: pos.x - thumbSize.width / 2.0, y: (layerRect.height - thumbSize.height) / 2.0, width: thumbSize.width, height: thumbSize.height)
            }
            else {
                thumb.frame = CGRect(x: (layerRect.width - thumbSize.width) / 2.0, y: pos.y - thumbSize.height / 2.0, width: thumbSize.width, height: thumbSize.height)
            }
        }

        self.layoutSeparators()

        applyThumbStyle(thumbStyle)
        applySeparatorStyle(separatorStyle)
        applyStyle(self.getStyle())
        applyHintStyle(hintStyle)

        self.assignThumbTexts()
        self.assignSeparatorTexts()
        self.assignSeparatorTextOpacities()
    }

    func layoutSeparators() {
        let layerRect = self.marginsForRect(bounds, margins: backgroundInsets)
        let mainSizeH = self.direction.principalSize(layerRect.size) * 0.5

        for thumb in self.thumbList.thumbs {
            let pos = self.thumbList.getThumbPosForValue(_values[thumb.index], thumbIndex: thumb.index)
            let labelLOff = self.direction.principalSize(self.getThumbSize(thumb)) * 0.5
            let sep = self.separatorForThumb(thumb.index)
            let mainSepPos = self.direction.principalPosition(sep.center)
            sep.relativeEdgeOffset = 1.0 - (abs(mainSepPos - mainSizeH) / mainSizeH)
            let hp: CGFloat
            let labelHOff: CGFloat
            if thumb.index+1 < self.thumbList.thumbs.count {
                hp = self.direction.principalPosition(self.thumbList.getThumbPosForValue(_values[thumb.index+1], thumbIndex: thumb.index+1))
                labelHOff = self.direction.principalSize(self.getThumbSize(self.thumbList.getNextThumb(thumb.index)!)) * 0.5
            }
            else {
                hp = self.direction.principalSize(self.bounds.size) + self.direction.principalPosition(self.bounds.origin)
                labelHOff = 0
            }
            if self.direction == .horizontal {
                let sepHeight  = bounds.height * separatorRatio
                sep.frame = CGRect(x: pos.x, y: (bounds.height - sepHeight) * 0.5 , width: hp - pos.x, height: sepHeight)
                sep.labelBounds = CGRect(x: labelLOff, y: (bounds.height - sepHeight) * 0.5, width: (hp - pos.x) - (labelLOff + labelHOff), height: sepHeight)
            }
            else {
                let sepHeight  = bounds.width * separatorRatio
                sep.frame = CGRect(x: (bounds.width - sepHeight) * 0.5, y: pos.y, width: sepHeight, height: hp - pos.y)
                sep.labelBounds = CGRect(x: (bounds.width - sepHeight) * 0.5, y: labelLOff, width: sepHeight, height: (hp - pos.y) - (labelLOff + labelHOff))
            }
        }
        // Handle first separator
        if self.separatorLabels.count > 0 {
            let sep = self.separatorLabels[0]
            let mainSepPos = self.direction.principalPosition(sep.center)
            sep.relativeEdgeOffset = 1.0 - (abs(mainSepPos - mainSizeH) / mainSizeH)

            let hp: CGFloat
            let labelHOff: CGFloat
            if self.thumbList.thumbs.count > 0 {
                hp = self.direction.principalPosition(self.thumbList.getThumbPosForValue(_values[0], thumbIndex: 0))
                labelHOff = self.direction.principalSize(self.getThumbSize(self.thumbList.thumbs[0])) * 0.5
            }
            else {
                hp = self.direction.principalSize(self.bounds.size) + self.direction.principalPosition(self.bounds.origin)
                labelHOff = 0
            }
            let pos = self.bounds.origin
            if self.direction == .horizontal {
                let sepHeight  = bounds.height * separatorRatio
                sep.frame = CGRect(x: pos.x, y: (bounds.height - sepHeight) * 0.5 , width: hp - pos.x, height: sepHeight)
                sep.labelBounds = CGRect(x: 0, y: (bounds.height - sepHeight) * 0.5, width: (hp - pos.x) - labelHOff, height: sepHeight)
            }
            else {
                let sepHeight  = bounds.width * separatorRatio
                sep.frame = CGRect(x: (bounds.width - sepHeight) * 0.5, y: pos.y, width: sepHeight, height: hp - pos.y)
                sep.labelBounds = CGRect(x: (bounds.width - sepHeight) * 0.5, y: 0, width: sepHeight, height: (hp - pos.y) - labelHOff)
            }
        }
    }

    // MARK: - Internal

    func startPositionUpdateNotification() {
        self.posUpdateTimer.start(self.notificationDelay) { [weak self] in
            if let weakSelf = self {
                for thumb in weakSelf.thumbList.thumbs {
                    let v = weakSelf.thumbList.getValueFromThumbPos(thumb.index)
                    if !v.isNaN && !v.isInfinite {
                        weakSelf.updateValue(thumb.index, value: v, finished: false)
                    }
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
    
    func setupSeparatorGesture(_ separator: StyledLabel) {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(GenericStyleSlider.separatorTouched))
        separator.addGestureRecognizer(touchGesture)
    }
    
    func separatorTouched(_ sender: UITapGestureRecognizer) {
        if let separator = sender.view as? StyledLabel, let index = self.getSeparatorIndex(separator) {
            switch sender.state {
            case .ended:
                self.separatorTouchDelegate?.onSeparatorTouchEnded(index)
            default:
                break
            }
        }
    }

    func setupThumbGesture(_ thumb: StyledSliderThumb) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GenericStyleSlider.sliderPanned))
        thumb.addGestureRecognizer(panGesture)

        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(GenericStyleSlider.thumbTouched))
        touchGesture.require(toFail: panGesture)
        thumb.addGestureRecognizer(touchGesture)
    }
    
    func thumbTouched(_ sender: UITapGestureRecognizer) {
        if let thumb = sender.view as? StyledSliderThumb {
            switch sender.state {
            case .ended:
                self.thumbTouchDelegate?.onThumbTouchEnded(thumb.index)
            default:
                break
            }
        }
    }

    func sliderPanned(_ sender: UIPanGestureRecognizer) {
        if let thumb = sender.view as? StyledSliderThumb {
            switch sender.state {
            case .began:
                if case .none = hintStyle {} else {
                    hintLabel.alpha  = 0
                    hintLabel.frame = CGRect(origin: hintLabel.frame.origin, size: self.getThumbSize(thumb))
                    superview?.addSubview(hintLabel)
                    
                    UIView.animate(withDuration: 0.2) {
                        self.hintLabel.alpha = 1.0
                    }
                }
                touchesBeganPoint = sender.location(in: self)

                for oth in self.thumbList.thumbs {
                    oth.eventTriggered = false
                    self.dynamicButtonAnimator.removeBehavior(oth.snappingBehavior)
                }
                
                thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index)?.lighter() ?? thumbBackgroundColor?.lighter()
                hintLabel.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index)?.lighter() ?? thumbBackgroundColor?.lighter()
                
                // Remember original values before sliding
                for oth in self.thumbList.thumbs {
                    oth.tempValue = self.values[oth.index]
                }
                
            case .changed:
                switch thumb.behaviour {
                case .fixateToLower:
                    fallthrough
                case .fixateToCenter:
                    fallthrough
                case .fixateToHigher:
                    self.thumbList.applyThumbBehaviour(thumb)
                default:
                    break
                }
                let translationInView = sender.translation(in: thumb)
                
                let tiv = self.direction.principalPosition(translationInView)
                let tb = self.direction.principalPosition(touchesBeganPoint)
                self.thumbList.updateThumbPosition(tiv+tb, thumbIndex: thumb.index)

                var v = self.thumbList.getValueFromThumbPos(thumb.index)
                if v < thumb.lowerLimit {
                    v = thumb.lowerLimit
                }
                if v > thumb.upperLimit {
                    v = thumb.upperLimit
                }
                self.updateValue(thumb.index, value: v, finished: false)
                let finalPos = self.direction.principalPosition(self.thumbList.getThumbPosForValue(v, thumbIndex: thumb.index))
                self.thumbList.updateThumbPosition(finalPos, thumbIndex: thumb.index)

                if case .none = hintStyle {} else {
                    let cp = CGPoint(x: frame.origin.x + thumb.center.x, y: (frame.origin.y - thumb.bounds.height - hintLabel.bounds.height / 2) + thumb.center.y)
                    hintLabel.center = cp
                }
                hintLabel.text = valueAsText(v)

                for oth in self.thumbList.thumbs {
                    if oth.index != thumb.index {
                        if case .snapToValueRelative(_) = oth.behaviour {
                            if let tempValue = oth.tempValue, let tVal = thumb.tempValue {
                                
                                // TODO: Might want to use 1 / (indexDiff + 1)
                                
                                let newValue = (v - tVal) * 0.5 + tempValue
                                let newPos = self.thumbList.getThumbPosForValue(newValue, thumbIndex: oth.index)
                                self.thumbList.updateThumbPosition(self.thumbList.direction.principalPosition(newPos), thumbIndex: oth.index)
                                self.updateValue(oth.index, value: newValue, finished: false)
                            }
                        }
                    }
                }

                self.layoutSeparators()
                self.assignSeparatorTextOpacities()

            case .ended, .failed, .cancelled:
                if case .none = hintStyle {} else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.hintLabel.alpha = 0.0
                    }) { _ in
                        self.hintLabel.removeFromSuperview()
                    }
                }
                for athumb in self.thumbList.thumbs {
                    self.thumbList.applyThumbBehaviour(athumb)
                    if let oval = athumb.tempValue, athumb.index != thumb.index {
                        self.updateValue(athumb.index, value: oval, finished: false)
                    }
                    athumb.snappingBehavior.action = { [weak self] in
                        if let weakSelf = self {
                            for athumb in weakSelf.thumbList.thumbs {
                                var v = weakSelf.thumbList.getValueFromThumbPos(athumb.index)
                                if v < thumb.lowerLimit {
                                    v = thumb.lowerLimit
                                }
                                if v > thumb.upperLimit {
                                    v = thumb.upperLimit
                                }
                                weakSelf.updateValue(athumb.index, value: v, finished: false)
                            }
                            weakSelf.layoutSeparators()
                            weakSelf.assignSeparatorTextOpacities()
                        }
                    }
                    self.dynamicButtonAnimator.addBehavior(athumb.snappingBehavior)
                }
                
                thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? thumbBackgroundColor ?? backgroundColor?.lighter()

                let v = self.values[thumb.index]
                self.notifyOfValueChanged(v, index: thumb.index)

            case .possible:
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
        let sep = LabelFactory.defaultStyledSeparator()
        sep.backgroundColor = self.sliderDelegate?.colorOfSeparatorLabel(self.separatorLabels.count) ?? self.separatorBackgroundColor
        sep.font = self.separatorFont
        sep.backgroundIcon = self.sliderDelegate?.iconOfSeparator(self.separatorLabels.count)
        sep.sizeInfo = self.sliderDelegate?.sizeInfoOfSeparator(self.separatorLabels.count)
        sep.textColor = self.separatorTextColor
        sep.useOpacityForSizing = self.sliderDelegate?.adaptOpacityForSeparatorLabel(self.separatorLabels.count) ?? true
        self.separatorLabels.append(sep)
        self.addSubview(sep)
        self.setupSeparatorGesture(sep)
    }
    
    func getSeparatorIndex(_ separator: StyledLabel) -> Int? {
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
            if let sizeInfo = sep.sizeInfo {
                if sizeInfo.autoAdjustTextFontSize {
                    sep.fitFontForSize(minFontSize: sizeInfo.minFontSize, maxFontSize: sizeInfo.maxFontSize, accuracy: 1.0, margins: sizeInfo.textInsetsForAutoTextFont)
                }
            }
        }
    }

    func addThumb(_ value: Double) {
        let thumb = LabelFactory.defaultStyledThumb()
        thumb.index = self.thumbList.thumbs.count
        thumb.backgroundColor = self.sliderDelegate?.colorOfThumb(thumb.index) ?? self.thumbBackgroundColor
        thumb.behaviour = self.sliderDelegate?.behaviourOfThumb(thumb.index) ?? self.thumbSnappingBehaviour
        thumb.sizeInfo = self.sliderDelegate?.sizeInfoOfThumb(thumb.index)
        if let (bel, abo) = self.sliderDelegate?.triggerEventValues(thumb.index) {
            thumb.triggerEventAbove = abo
            thumb.triggerEventBelow = bel
        }
        if let (lo, hi) = self.sliderDelegate?.thumbValueLimits(thumb.index) {
            thumb.lowerLimit = lo ?? -Double.infinity
            thumb.upperLimit = hi ?? Double.infinity
        }
        self.thumbList.thumbs.append(thumb)
        self.addSubview(thumb)
        self.thumbList.applyThumbBehaviour(thumb)
        self.setupThumbGesture(thumb)
    }

    func assignThumbText(_ index: Int) {
        let thumb = self.thumbList.thumbs[index]
        if let delTT = self.sliderDelegate?.textOfThumb(index) {
            thumb.text = delTT
            self.assignThumbFontAndColor(thumb)
        }
        else if let attrText = self.sliderDelegate?.attributedTextOfThumb(index) {
            thumb.attributedText = attrText
        }
        else if thumbText == nil {
            thumb.text = self.valueAsText(_values[thumb.index])
            self.assignThumbFontAndColor(thumb)
        }
        else if let attrText = self.thumbAttributedText {
            thumb.attributedText = attrText
        }
        else {
            thumb.text = self.thumbText
            self.assignThumbFontAndColor(thumb)
        }
    }
    
    func assignThumbFontAndColor(_ thumb: StyledSliderThumb) {
        thumb.font = self.thumbFont
        thumb.textColor = self.thumbTextColor
        if let thumbSizeInfo = thumb.sizeInfo {
            if thumbSizeInfo.autoAdjustTextFontSize {
                thumb.fitFontForSize(minFontSize: thumbSizeInfo.minFontSize, maxFontSize: thumbSizeInfo.maxFontSize, accuracy: 1.0, margins: thumbSizeInfo.textInsetsForAutoTextFont)
            }
        }
    }
    
    func assignThumbTexts() {
        for idx in 0..<self.thumbList.thumbs.count {
            self.assignThumbText(idx)
        }
    }

    func clampValue(_ value: Double) -> Double {
        var newVal = value
        if newVal > maximumValue {
            newVal = maximumValue
        }
        if newVal < minimumValue {
            newVal = minimumValue
        }
        return newVal
    }
    
    func updateValue(_ index: Int, value: Double, finished: Bool = true) {
        let newVal = self.clampValue(value)
        let oldVal = _values[index]
        _values[index] = newVal
        self.assignThumbText(index)
        
        if (continuous || finished) && oldVal != newVal {
            self.notifyOfValueChanged(newVal, index: index)
        }
        if let triggerHandler = self.eventTriggerHandler {
            let thumb = self.thumbList.thumbs[index]
            if !thumb.eventTriggered {
                let belowVal = thumb.triggerEventBelow ?? self.eventTriggerBelow
                let aboveVal = thumb.triggerEventAbove ?? self.eventTriggerAbove
                if let bv = belowVal, value < bv {
                    thumb.eventTriggered = true
                    triggerHandler(index, value)
                }
                if let av = aboveVal, value > av {
                    thumb.eventTriggered = true
                    triggerHandler(index, value)
                }
            }
        }
    }
    
    func updateValues() {
        for i in 0..<self._values.count {
            let val = self._values[i]
            self.updateValue(i, value: val)
        }
    }

    func notifyOfValueChanged(_ value: Double, index: Int) {
        sendActions(for: .valueChanged)
        
        if let _valueChangedBlock = valueChangedBlock {
            _valueChangedBlock(value, index)
        }
    }
    
    func initComponent() {
        self.posUpdateTimer.stop()
        if self.continuous {
            self.startPositionUpdateNotification()
        }
    }
    
    func initValues(_ values: [Double]) {
        self.posUpdateTimer.stop()
        if self.continuous {
            self.startPositionUpdateNotification()
        }
        self.hintLabel.font      = thumbFont
        self.hintLabel.textColor = thumbTextColor
        
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
        _values = newVals.sorted()
        for _ in 0..._values.count {
            self.addSeparator()
        }
        for value in _values {
            self.addThumb(value)
        }
        self.layoutComponents()
    }
    
    func valueAsText(_ value: Double) -> String {
        if let formatStr = self.numberFormatString {
            return String(format: formatStr, value)
        }
        return value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(value))" : "\(value)"
    }

}
