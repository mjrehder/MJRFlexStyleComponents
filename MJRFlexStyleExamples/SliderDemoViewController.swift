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
        self.horiSlider?.minimumTrackTintColor = UIColor.MKColor.BlueGrey.P100
        self.view.addSubview(self.horiSlider!)
        
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.25, snappingBehaviour: .snapToValueRelative(v: 0.25)))
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.5, snappingBehaviour: .snapToValueRelative(v: 0.5)))
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.75, snappingBehaviour: .snapToValueRelative(v: 0.75)))

        self.vertiSlider = FlexMutableSlider(frame: CGRect(x: 10, y: 50, width: 32, height: 100))
        self.vertiSlider?.minimumValue = 0
        self.vertiSlider?.maximumValue = 1
        self.vertiSlider?.borderColor = .black
        self.vertiSlider?.borderWidth = 1
        self.vertiSlider?.style = FlexShapeStyle(style: .rounded)
        self.vertiSlider?.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        self.vertiSlider?.minimumTrackTintColor = UIColor.MKColor.BlueGrey.P100
        self.vertiSlider?.direction = .vertical
        self.view.addSubview(self.vertiSlider!)
        
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.25, snappingBehaviour: .snapToValueRelative(v: 0.25)))
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.5, snappingBehaviour: .snapToValueRelative(v: 0.5)))
        self.vertiSlider?.addThumb(self.getThumbModel(value: 0.75, snappingBehaviour: .snapToValueRelative(v: 0.75)))
    }
    
    func getThumbModel(value: Double, snappingBehaviour: StyledSliderThumbBehaviour, isRelative: Bool = false) -> MutableSliderThumbItem {
        let thumb = MutableSliderThumbItem()
        thumb.initialValue = value
        thumb.behaviour = snappingBehaviour
        thumb.separatorColor = UIColor.MKColor.BlueGrey.P200
        thumb.thumbColor = UIColor.MKColor.BlueGrey.P500
        thumb.thumbText = "TH"
        let sizeInfo = SliderThumbSizeInfo()
        sizeInfo.sizingType = .relativeToSlider(min: 10, max: 32)
        sizeInfo.autoAdjustTextFontSize = true
        thumb.sizeInfo = sizeInfo
        
        return thumb
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.horiSlider?.frame = CGRect(x: 10, y: 80, width: self.view.bounds.size.width - 20, height: 32)
        self.vertiSlider?.frame = CGRect(x: 10, y: 120, width: 32, height: 300)
    }
    
}
