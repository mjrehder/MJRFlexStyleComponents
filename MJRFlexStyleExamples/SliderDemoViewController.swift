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
        self.horiSlider?.thumbStyle = FlexShapeStyle(style: .rounded)
        self.horiSlider?.minimumTrackTintColor = UIColor.MKColor.BlueGrey.P100
        self.view.addSubview(self.horiSlider!)
        
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.25, snappingBehaviour: .snapToValue(v: 0.25)))
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.5, snappingBehaviour: .snapToValue(v: 0.5)))
        self.horiSlider?.addThumb(self.getThumbModel(value: 0.75, snappingBehaviour: .snapToValue(v: 0.75)))
    }
    
    func getThumbModel(value: Double, snappingBehaviour: StyledSliderThumbBehaviour) -> MutableSliderThumbItem {
        let thumb = MutableSliderThumbItem()
        thumb.initialValue = value
        thumb.behaviour = snappingBehaviour
        thumb.separatorColor = UIColor.MKColor.BlueGrey.P200
        thumb.thumbColor = UIColor.MKColor.BlueGrey.P500
        return thumb
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.horiSlider?.frame = CGRect(x: 10, y: 80, width: self.view.bounds.size.width - 20, height: 32)
    }
    
}
