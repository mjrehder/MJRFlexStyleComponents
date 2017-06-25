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
    private var utilButton: FlexMutableSlider?
    private var util2Button: FlexMutableSlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.horiSlider = FlexMutableSlider(frame: CGRect(x: 10, y: 25, width: 100, height: 32))
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

        self.vertiSlider = FlexMutableSlider(frame: CGRect(x: 10, y: 50, width: 32, height: 100))
        self.vertiSlider?.minimumValue = 0
        self.vertiSlider?.maximumValue = 1
        self.vertiSlider?.borderColor = .black
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

        self.utilButton = FlexMutableSlider(frame: CGRect(x: 10, y: 50, width: 48, height: 48))
        self.utilButton?.minimumValue = 0
        self.utilButton?.maximumValue = 1
        self.utilButton?.borderColor = .black
        self.utilButton?.borderWidth = 1
        self.utilButton?.style = FlexShapeStyle(style: .thumb)
        self.utilButton?.thumbStyle = FlexShapeStyle(style: .box)
        self.utilButton?.getSeparator(at: 0)?.color = .clear
        self.utilButton?.direction = .vertical
        self.utilButton?.thumbSize = CGSize(width: 48, height: 32)
        self.view.addSubview(self.utilButton!)
        
        let sizeInfo = SliderSeparatorSizeInfo()
        sizeInfo.autoAdjustTextFontSize = true
        sizeInfo.minFontSize = 8
        sizeInfo.maxFontSize = 18
        sizeInfo.maxIconSize = CGSize(width: 42, height: 42)
        sizeInfo.iconSizingType = .relativeToSlider(minSize: CGSize(width: 12, height: 12))
        sizeInfo.autoAdjustIconSize = true
        //        sizeInfo.textInsetsForAutoTextFont = .zero

        let u2 = self.getUtilThumbModel(value: 0.5, snappingBehaviour: .snapToValueRelative(v: 0.5))
        u2.text = "A"
        self.utilButton?.addThumb(u2, separator: self.getUtilSeparatorModel(sizeInfo: sizeInfo))
        
        self.utilButton?.getSeparator(at: 0)?.text = "B"
        self.utilButton?.getSeparator(at: 0)?.sizeInfo = sizeInfo
        self.utilButton?.recreateThumbs()
        
        self.utilButton?.eventTriggerHandler = {
            (index, value) in
            NSLog("Event trigger for \(index) at value \(value)")
        }

    
        self.util2Button = FlexMutableSlider(frame: CGRect(x: 10, y: 50, width: 48, height: 48))
        self.util2Button?.minimumValue = 0
        self.util2Button?.maximumValue = 1
        self.util2Button?.borderColor = .black
        self.util2Button?.borderWidth = 1
        self.util2Button?.style = FlexShapeStyle(style: .thumb)
        self.util2Button?.thumbStyle = FlexShapeStyle(style: .box)
        self.util2Button?.getSeparator(at: 0)?.color = .clear
        self.util2Button?.direction = .vertical
        self.util2Button?.thumbSize = CGSize(width: 48, height: 32)
        self.view.addSubview(self.util2Button!)
        
        let size2Info = SliderSeparatorSizeInfo()
        size2Info.autoAdjustTextFontSize = true
        size2Info.minFontSize = 8
        size2Info.maxFontSize = 18
        size2Info.maxIconSize = CGSize(width: 42, height: 42)
        size2Info.iconSizingType = .relativeToSlider(minSize: CGSize(width: 12, height: 12))
        size2Info.autoAdjustIconSize = true
        
        let u2b = self.getUtilThumbModel(value: 0.66, snappingBehaviour: .snapToValueRelative(v: 0.66))
        u2b.text = "A"
        u2b.lowerLimit = 0.66
        self.util2Button?.addThumb(u2b, separator: self.getUtil2SeparatorModel(sizeInfo: sizeInfo))
        
        self.util2Button?.getSeparator(at: 0)?.text = "B"
        self.util2Button?.getSeparator(at: 0)?.sizeInfo = sizeInfo
        let icon = UIImage(color: .red, size: CGSize(width: 32, height: 32))
        self.util2Button?.getSeparator(at: 0)?.icon = icon
        self.util2Button?.recreateThumbs()
        
        self.util2Button?.eventTriggerHandler = {
            (index, value) in
            NSLog("Event trigger for \(index) at value \(value)")
        }
}
    
    func getThumbModel(value: Double, snappingBehaviour: StyledSliderThumbBehaviour, isRelative: Bool = false) -> MutableSliderThumbItem {
        let thumb = MutableSliderThumbItem()
        thumb.initialValue = value
        thumb.behaviour = snappingBehaviour
        thumb.color = UIColor.MKColor.BlueGrey.P500
        thumb.text = "TH"
        let sizeInfo = SliderThumbSizeInfo()
        sizeInfo.sizingType = .relativeToSlider(min: 10, max: 32)
        sizeInfo.autoAdjustTextFontSize = true
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

    func getUtilThumbModel(value: Double, snappingBehaviour: StyledSliderThumbBehaviour, isRelative: Bool = false) -> MutableSliderThumbItem {
        let thumb = MutableSliderThumbItem()
        thumb.initialValue = value
        thumb.behaviour = snappingBehaviour
        thumb.color = .clear
        let sizeInfo = SliderThumbSizeInfo()
        sizeInfo.sizingType = .relativeToSlider(min: 10, max: 32)
        sizeInfo.autoAdjustTextFontSize = true
        sizeInfo.minFontSize = 10
        sizeInfo.maxFontSize = 32
        thumb.sizeInfo = sizeInfo
        
        thumb.triggerEventAbove = 0.9
        thumb.triggerEventBelow = 0.1
        
        return thumb
    }
    
    func getUtilSeparatorModel(sizeInfo: SliderSeparatorSizeInfo) -> MutableSliderSeparatorItem {
        let sep = MutableSliderSeparatorItem()
        sep.color = .clear
        sep.text = "C"
        sep.sizeInfo = sizeInfo
        sep.useOpacityForSizing = false
        let icon = UIImage(color: .red, size: CGSize(width: 32, height: 32))
        sep.icon = icon
        
        return sep
    }
    
    func getUtil2SeparatorModel(sizeInfo: SliderSeparatorSizeInfo) -> MutableSliderSeparatorItem {
        let sep = MutableSliderSeparatorItem()
        sep.color = .clear
        sep.sizeInfo = sizeInfo
        sep.useOpacityForSizing = false
        return sep
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.horiSlider?.frame = CGRect(x: 10, y: 80, width: self.view.bounds.size.width - 20, height: 32)
        self.vertiSlider?.frame = CGRect(x: 10, y: 120, width: 32, height: 300)
        self.utilButton?.frame = CGRect(x: self.view.bounds.size.width - (10 + 64), y: 120, width: 64, height: 64)
        self.util2Button?.frame = CGRect(x: self.view.bounds.size.width - (10 + 64) * 2, y: 120, width: 64, height: 64)
    }
    
}
