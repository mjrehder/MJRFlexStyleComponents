//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GenericStyleSliderDelegate {
    @IBOutlet weak var simpleSlider: GenericStyleSlider!
    @IBOutlet weak var verticalSimpleSlider: GenericStyleSlider!
    @IBOutlet weak var menuSelectionSlider: GenericStyleSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSimpleSlider()
        self.setupMenuSelectionSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupSimpleSlider() {
        self.simpleSlider.thumbBackgroundColor = UIColor.greenColor()
        self.simpleSlider.minimumValue = 0
        self.simpleSlider.maximumValue = 1
        self.simpleSlider.thumbRatio = 0.1
        self.simpleSlider.thumbText = nil
        self.simpleSlider.separatorBackgroundColor = UIColor.blueColor()
        self.simpleSlider.separatorRatio = 0.5
        self.simpleSlider.separatorStyle = .Tube
        self.simpleSlider.values = [0.0, 0.5, 0.75]
        self.simpleSlider.style = .Tube
        self.simpleSlider.styleColor = UIColor.grayColor()
        self.simpleSlider.backgroundColor = UIColor.clearColor()
        self.simpleSlider.thumbSnappingBehaviour = .SnapToLowerAndHigher
        self.simpleSlider.hintStyle = .Rounded
        self.simpleSlider.numberFormatString = "%.1f"
        
        self.simpleSlider.valueChangedBlock = {
            (value, index) in
            NSLog("Value of index \(index) changed to \(value)")
        }
        
        self.verticalSimpleSlider.thumbBackgroundColor = UIColor.greenColor()
        self.verticalSimpleSlider.direction = .Vertical
        self.verticalSimpleSlider.minimumValue = 0
        self.verticalSimpleSlider.maximumValue = 1
        self.verticalSimpleSlider.thumbRatio = 0.1
        self.verticalSimpleSlider.separatorBackgroundColor = UIColor.blueColor()
        self.verticalSimpleSlider.separatorRatio = 0.2
        self.verticalSimpleSlider.thumbText = nil
        self.verticalSimpleSlider.values = [0.0, 0.5, 0.75]
        self.verticalSimpleSlider.hintStyle = .Rounded
        self.verticalSimpleSlider.numberFormatString = "%.1f"
    }
    
    func setupMenuSelectionSlider() {
        self.menuSelectionSlider.minimumValue = 0
        self.menuSelectionSlider.maximumValue = 1
        self.menuSelectionSlider.thumbRatio = 0.1
        self.menuSelectionSlider.separatorStyle = .Box
        self.menuSelectionSlider.values = [0.0, 0.0, 0.0]
        self.menuSelectionSlider.style = .Rounded
        self.menuSelectionSlider.styleColor = UIColor.grayColor()
        self.menuSelectionSlider.backgroundColor = UIColor.clearColor()
        self.menuSelectionSlider.thumbSnappingBehaviour = .SnapToLowerAndHigher
        
        self.menuSelectionSlider.valueChangedBlock = {
            (value, index) in
            NSLog("Value of index \(index) changed to \(value)")
        }
        
        self.menuSelectionSlider.sliderDelegate = self
    }
    
    func textOfThumb(index: Int) -> String? {
        return ["S","M","L"][index]
    }
    
    func textOfSeparatorLabel(index: Int) -> String? {
        return ["Test", "Small","Medium","Large"][index]
    }
    
    func colorOfThumb(index: Int) -> UIColor? {
        return UIColor.brownColor()
    }
    
    func colorOfSeparatorLabel(index: Int) -> UIColor? {
        return UIColor.yellowColor()
    }
}

