//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GenericStyleSliderDelegate, FlexMenuDataSource, FlexSeriesViewDataSource, FlexSwitchDelegate {
    var colorMenuItems: [FlexMenuItem] = []
    var numSeries = 2
    var numDataPoints = 3
    var dataSeries: [[Double]] = [[0,0,0],[0,0,0]]
    
    @IBOutlet weak var simpleSlider: GenericStyleSlider!
    @IBOutlet weak var menuSelectionSlider: GenericStyleSlider!
    
    @IBOutlet weak var colorMenuSelectionSlider: FlexMenu!
    
    @IBOutlet weak var sliderGraphView: FlexSeriesView!
    
    @IBOutlet weak var vhSwitch: FlexSwitch!
    
    @IBOutlet weak var dataPointSelector: FlexSlider!
    @IBOutlet weak var numSeriesSelector: FlexSlider!
    
    @IBOutlet weak var maxMinDataSlider: FlexDoubleSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSimpleSlider()
        self.setupMenuSelectionSlider()
        self.setupColorSelectionMenuSlider()
        self.setupSliderGraphView()
        self.setupVHSwitch()
        self.setupDataPointAndSeriesSelectors()
        self.setupMaxMinDataSlider()
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
    }
    
    func setupMaxMinDataSlider() {
        self.maxMinDataSlider.backgroundColor = UIColor.clearColor()
        self.maxMinDataSlider.direction = .Vertical
        self.maxMinDataSlider.minimumValue = 0
        self.maxMinDataSlider.maximumValue = 100
        self.maxMinDataSlider.thumbRatio = 0.1
        self.maxMinDataSlider.hintStyle = .Rounded
        self.maxMinDataSlider.numberFormatString = "%.1f"
        self.maxMinDataSlider.value = 0
        self.maxMinDataSlider.value2 = 100
        self.maxMinDataSlider.minimumTrackTintColor = UIColor.redColor().darkerColor()
        self.maxMinDataSlider.middleTrackTintColor = UIColor.redColor()
        self.maxMinDataSlider.maximumTrackTintColor = UIColor.clearColor()
        self.maxMinDataSlider.thumbTintColor = UIColor.grayColor()

        self.maxMinDataSlider.valueChangedBlock = {
            (value, index) in
            if index == 0 {
                if value != self.sliderGraphView.maximumValue {
                    self.sliderGraphView.minimumValue = value
                }
            }
            else {
                if value != self.sliderGraphView.minimumValue {
                    self.sliderGraphView.maximumValue = value
                }
            }
        }
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
        self.sliderGraphView.spacing = self.sliderGraphView.bounds.size.height * 0.1
        self.sliderGraphView.reloadData()
    }
    
    func setupVHSwitch() {
        self.vhSwitch.switchDelegate = self
    }
    
    func setupDataPointAndSeriesSelectors() {
        self.numSeriesSelector.backgroundColor = .clearColor()
        self.numSeriesSelector.minimumTrackTintColor = UIColor.redColor().darkerColor()
        self.numSeriesSelector.maximumTrackTintColor = UIColor.clearColor()
        self.numSeriesSelector.thumbTintColor = UIColor.grayColor()
        self.numSeriesSelector.minimumValue = 1
        self.numSeriesSelector.maximumValue = 4
        self.numSeriesSelector.value = Double(numSeries)
        self.numSeriesSelector.valueChangedBlock = {
            (value, index) in
            self.numSeries = Int(round(value))
            self.createDemoDataForGraph()
            self.sliderGraphView.reloadData()
        }
        
        self.dataPointSelector.backgroundColor = .clearColor()
        self.dataPointSelector.minimumTrackTintColor = UIColor.redColor().darkerColor()
        self.dataPointSelector.maximumTrackTintColor = UIColor.clearColor()
        self.dataPointSelector.thumbTintColor = UIColor.grayColor()
        self.dataPointSelector.minimumValue = 2
        self.dataPointSelector.maximumValue = 7
        self.dataPointSelector.value = Double(numDataPoints)
        self.dataPointSelector.valueChangedBlock = {
            (value, index) in
            self.numDataPoints = Int(round(value))
            self.createDemoDataForGraph()
            self.sliderGraphView.reloadData()
        }
    }
    
    // MARK: - Internal
    
    func createDemoDataForGraph() {
        var newDemoData: [[Double]] = []
        for s in 0..<self.numSeries {
            var dataPoints: [Double] = []
            for _ in 0..<self.numDataPoints {
                let r = Double(random() % 100) / 10.0
                dataPoints.append(Double(s)*10.0 + r)
            }
            newDemoData.append(dataPoints)
        }
        self.dataSeries = newDemoData
    }
    
    // MARK: - FlexSwitchDelegate
    
    func switchStateChanged(flexSwitch: FlexSwitch, on: Bool) {
        let on = self.vhSwitch.on
        self.sliderGraphView.spacing = on ? self.sliderGraphView.bounds.size.width * 0.1 : self.sliderGraphView.bounds.size.height * 0.1
        self.sliderGraphView.direction = on ? .Vertical : .Horizontal
    }
    
    // MARK: - FlexMenuDataSource
    // TODO: This is the old way... create a style selector example 
    
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
    
    func behaviourOfThumb(index: Int) -> StyledSliderThumbBehaviour? {
        return nil
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
        return self.dataSeries[series][point]
    }
    
    func dataChangedOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int, data: Double) {
        self.dataSeries[series][point] = data
    }
    
    func numberOfSeries(flexSeries: FlexSeriesView) -> Int {
        return self.numSeries
    }
    
    func numberOfDataPoints(flexSeries: FlexSeriesView) -> Int {
        return self.numDataPoints
    }
    
    func colorOfSeries(flexSeries: FlexSeriesView, series: Int) -> UIColor {
        var color = UIColor.redColor()
        for _ in 0..<series {
            color = color.lighterColor()
        }
        return color
    }
}

