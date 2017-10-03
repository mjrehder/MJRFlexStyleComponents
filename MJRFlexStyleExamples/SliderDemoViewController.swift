//
//  SliderDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 18.06.2017.
//  Copyright © 2017 Martin Rehder. All rights reserved.
//

import UIKit

class SliderDemoViewController: UIViewController {
    
    private var horiSlider: FlexMutableSlider?
    private var vertiSlider: FlexMutableSlider?

    private var utilButton: FlexFlickButton?
    private var util2Button: FlexFlickButton?

    private var horizUtilButton: FlexFlickButton?

    private var stepper: FlexSnapStepper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.horiSlider = FlexMutableSlider(frame: CGRect(x: 10, y: 25, width: 100, height: 32))
        self.horiSlider?.backgroundInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.horiSlider?.minimumValue = 0
        self.horiSlider?.maximumValue = 1
        self.horiSlider?.borderColor = .black
        self.horiSlider?.borderWidth = 1
        self.horiSlider?.style = FlexShapeStyle(style: .rounded)
        self.horiSlider?.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        self.horiSlider?.getSeparator(at: 0)?.color = UIColor.MKColor.BlueGrey.P100
        self.view.addSubview(self.horiSlider!)
        
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.25, snappingBehaviour: .snapToValueRelative(v: 0.25)), separator: self.getSeparatorModel())
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.5, snappingBehaviour: .snapToValueRelative(v: 0.5)), separator: self.getSeparatorModel())
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.75, snappingBehaviour: .snapToValueRelative(v: 0.75)), separator: self.getSeparatorModel())

        // Debug
        self.horiSlider?.continuous = false
        
        self.vertiSlider = FlexMutableSlider(frame: CGRect(x: 10, y: 50, width: 32, height: 100))
        self.vertiSlider?.minimumValue = 0
        self.vertiSlider?.maximumValue = 1
        self.vertiSlider?.borderColor = UIColor.MKColor.BlueGrey.P700
        self.vertiSlider?.borderWidth = 1
        self.vertiSlider?.style = FlexShapeStyle(style: .rounded)
        self.vertiSlider?.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        self.vertiSlider?.getSeparator(at: 0)?.color = UIColor.MKColor.BlueGrey.P100
        self.vertiSlider?.direction = .vertical
        self.view.addSubview(self.vertiSlider!)
        
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.25, snappingBehaviour: .snapToValueRelative(v: 0.25)), separator: self.getSeparatorModel())
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.5, snappingBehaviour: .snapToValueRelative(v: 0.5)), separator: self.getSeparatorModel())
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.75, snappingBehaviour: .snapToValueRelative(v: 0.75)), separator: self.getSeparatorModel())
        
        self.vertiSlider?.eventTriggerHandler = {
            (index, value) in
            NSLog("Event trigger for \(index) at value \(value)")
        }
        
        // Debug
        self.vertiSlider?.continuous = false

        self.utilButton = FlexFlickButton(frame: CGRect(x: 10, y: 50, width: 48, height: 48))
        self.utilButton?.borderColor = UIColor.MKColor.BlueGrey.P700
        self.utilButton?.borderWidth = 1
        self.utilButton?.style = FlexShapeStyle(style: .thumb)
        self.utilButton?.styleColor = UIColor.MKColor.BlueGrey.P100
        self.utilButton?.thumbStyle = FlexShapeStyle(style: .box)
        self.utilButton?.direction = .vertical
        self.utilButton?.upperActionItem.text = "B"
        self.utilButton?.primaryActionItem.text = "A"
        self.utilButton?.lowerActionItem.text = "C"
        self.utilButton?.upperActionItem.icon = UIImage(color: UIColor.MKColor.Red.A200, size: CGSize(width: 32, height: 32))
        self.utilButton?.primaryActionItem.icon = UIImage(color: UIColor.MKColor.Green.A200, size: CGSize(width: 32, height: 32))
        self.utilButton?.lowerActionItem.icon = UIImage(color: UIColor.MKColor.Blue.A200, size: CGSize(width: 32, height: 32))
        self.view.addSubview(self.utilButton!)
        
        self.utilButton?.actionActivationHandler = {
            action in
            switch action {
            case .upper:
                NSLog("upper action triggered")
            case .primary:
                NSLog("primary action triggered")
            case .lower:
                NSLog("lower action triggered")
            }
        }
        
        self.util2Button = FlexFlickButton(frame: CGRect(x: 10, y: 50, width: 48, height: 48))
        self.util2Button?.borderColor = UIColor.MKColor.BlueGrey.P700
        self.util2Button?.borderWidth = 1
        self.util2Button?.style = FlexShapeStyle(style: .thumb)
        self.util2Button?.styleColor = UIColor.MKColor.BlueGrey.P100
        self.util2Button?.thumbStyle = FlexShapeStyle(style: .box)
        self.util2Button?.direction = .vertical
        self.util2Button?.upperActionItem.text = "Up"
        self.util2Button?.primaryActionItem.text = "Ver"
        self.util2Button?.primaryActionItem.textMaxFontSize = 32
        self.view.addSubview(self.util2Button!)
        
        self.horizUtilButton = FlexFlickButton(frame: CGRect(x: 10, y: 50, width: 48, height: 48))
        self.horizUtilButton?.borderColor = UIColor.MKColor.BlueGrey.P700
        self.horizUtilButton?.borderWidth = 1
        self.horizUtilButton?.style = FlexShapeStyle(style: .rounded)
        self.horizUtilButton?.styleColor = UIColor.MKColor.BlueGrey.P100
        self.horizUtilButton?.thumbStyle = FlexShapeStyle(style: .box)
        self.horizUtilButton?.direction = .horizontal
        self.horizUtilButton?.upperActionItem.text = "<"
        self.horizUtilButton?.upperActionItem.textMaxFontSize = 28
        self.horizUtilButton?.upperActionItem.textSizingType = .relativeToSlider(minSize: 8)
        self.horizUtilButton?.primaryActionItem.text = "Cn"
        self.horizUtilButton?.primaryActionItem.textMaxFontSize = 18
        self.horizUtilButton?.lowerActionItem.text = ">"
        self.horizUtilButton?.lowerActionItem.textMaxFontSize = 28
        self.horizUtilButton?.lowerActionItem.textSizingType = .relativeToSlider(minSize: 8)
        self.view.addSubview(self.horizUtilButton!)

        // Snap Stepper
        self.stepper = FlexSnapStepper(frame: .zero)
        self.stepper?.stepValueChangeHandler = {
            newValue in
            NSLog("new value is \(newValue)")
        }
        self.stepper?.thumbFactory = { index in
            let thumb = MutableSliderThumbItem()
            thumb.color = UIColor.MKColor.BlueGrey.P100
            return thumb
        }
        self.stepper?.style = FlexShapeStyle(style: .rounded)
        self.stepper?.borderColor = UIColor.MKColor.BlueGrey.P700
        self.stepper?.borderWidth = 1
        
        self.view.addSubview(self.stepper!)
    }
    
    func getThumbModel(value: Double, snappingBehaviour: StyledSliderThumbBehaviour, isRelative: Bool = false) -> MutableSliderThumbItem {
        let thumb = MutableSliderThumbItem()
        thumb.initialValue = value
        thumb.behaviour = snappingBehaviour
        thumb.color = UIColor.MKColor.BlueGrey.P500
        thumb.text = "TH"
        let sizeInfo = SliderThumbSizeInfo()
        sizeInfo.sizingType = .relativeToSlider(min: 10, max: 32)
        sizeInfo.textSizingType = .scaleToFit
        thumb.sizeInfo = sizeInfo
        
        thumb.triggerEventAbove = 0.9
        thumb.triggerEventBelow = 0.1
        
        return thumb
    }
    
    func getSeparatorModel() -> MutableSliderSeparatorItem {
        let sep = MutableSliderSeparatorItem()
        sep.color = UIColor.MKColor.BlueGrey.P200
        return sep
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.horiSlider?.frame = CGRect(x: 10, y: 80, width: self.view.bounds.size.width - 20, height: 32)
        self.vertiSlider?.frame = CGRect(x: 10, y: 120, width: 32, height: 300)
        self.utilButton?.frame = CGRect(x: self.view.bounds.size.width - (10 + 64), y: 150, width: 64, height: 64)
        self.util2Button?.frame = CGRect(x: self.view.bounds.size.width - (10 + 64), y: 150 + 80, width: 64, height: 64)
        self.horizUtilButton?.frame = CGRect(x: self.view.bounds.size.width - (10 + 64), y: 150 + 160, width: 64, height: 64)
        self.stepper?.frame = CGRect(x: (self.view.bounds.size.width - 128) * 0.5, y: 190, width: 128, height: 32)
    }
    
}
