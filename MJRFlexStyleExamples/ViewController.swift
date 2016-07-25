//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GenericStyleSliderDelegate, FlexMenuDataSource, FlexSeriesViewDataSource {
    var colorMenuItems: [FlexMenuItem] = []
    
    @IBOutlet weak var simpleSlider: GenericStyleSlider!
    @IBOutlet weak var verticalSimpleSlider: GenericStyleSlider!
    @IBOutlet weak var menuSelectionSlider: GenericStyleSlider!
    
    @IBOutlet weak var colorMenuSelectionSlider: FlexMenu!
    
    @IBOutlet weak var sliderGraphView: FlexSeriesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSimpleSlider()
        self.setupMenuSelectionSlider()
        self.setupColorSelectionMenuSlider()
        self.setupSliderGraphView()
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
    
    func setupColorSelectionMenuSlider() {
        let col1 = FlexMenuItem(title: "Grey", titleShortcut: "Gr", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col2 = FlexMenuItem(title: "Amber", titleShortcut: "Am", color: UIColor.MKColor.Amber.P200, thumbColor: UIColor.MKColor.Amber.P500)
        let col3 = FlexMenuItem(title: "Lime", titleShortcut: "Li", color: UIColor.MKColor.Lime.P200, thumbColor: UIColor.MKColor.Lime.P500)
        let col4 = FlexMenuItem(title: "Light Blue", titleShortcut: "LB", color: UIColor.MKColor.LightBlue.P200, thumbColor: UIColor.MKColor.LightBlue.P500)
        self.colorMenuItems.append(col1)
        self.colorMenuItems.append(col2)
        self.colorMenuItems.append(col3)
        self.colorMenuItems.append(col4)
        
        self.colorMenuSelectionSlider.menuDataSource = self
    }
    
    func setupSliderGraphView() {
        self.sliderGraphView.dataSource = self
        self.sliderGraphView.spacing = self.sliderGraphView.bounds.size.height / 3 * 0.75
        self.sliderGraphView.reloadData()
    }
    
    // MARK: - FlexMenuDataSource
    
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
    
    // MARK: - FlexMenuDataSource
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        if menu == self.colorMenuSelectionSlider {
            return 4
        }
        return 0
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
//        if menu == self.colorMenuSelectionSlider {
        return self.colorMenuItems[index]
//        }
//        return 0
    }
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
        NSLog("Menu item selected: \(index)")
    }
    
    // MARK: - FlexSeriesViewDataSource
    
    func dataOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int) -> Double {
        return 0
    }
    
    func dataChangedOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int, data: Double) {
    }
    
    func numberOfSeries(flexSeries: FlexSeriesView) -> Int {
        return 2
    }
    
    func numberOfDataPoints(flexSeries: FlexSeriesView) -> Int {
        return 3
    }
}

