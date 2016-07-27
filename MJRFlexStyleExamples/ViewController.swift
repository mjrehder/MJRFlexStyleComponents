//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import SnappingStepper

class ViewController: UIViewController, FlexMenuDataSource, FlexSeriesViewDataSource, FlexSwitchDelegate {
    var colorMenuItems: [FlexMenuItem] = []
    var styleMenuItems: [FlexMenuItem] = []
    var numSeries = 2
    var numDataPoints = 3
    var dataSeries: [[Double]] = [[0,0,0],[0,0,0]]
    var selectedColor = UIColor.MKColor.LightBlue.P500
    var selectedThumbColor = UIColor.MKColor.Amber.P500
    
    @IBOutlet weak var colorMenuSelectionSlider: FlexMenu!
    @IBOutlet weak var styleMenuSelector: FlexMenu!
    
    @IBOutlet weak var sliderGraphView: FlexSeriesView!
    
    @IBOutlet weak var vhSwitch: FlexSwitch!
    
    @IBOutlet weak var dataPointSelector: FlexSlider!
    @IBOutlet weak var numSeriesSelector: FlexSlider!
    
    @IBOutlet weak var maxMinDataSlider: FlexDoubleSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupStyleMenuSelectionSlider()
        self.setupColorSelectionMenuSlider()
        self.setupSliderGraphView()
        self.setupVHSwitch()
        self.setupDataPointAndSeriesSelectors()
        self.setupMaxMinDataSlider()
        self.applyColorToDemoControls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func setupStyleMenuSelectionSlider() {
        let col1 = FlexMenuItem(title: "Box", titleShortcut: "B", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col2 = FlexMenuItem(title: "Rounded", titleShortcut: "R", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col3 = FlexMenuItem(title: "Tube", titleShortcut: "T", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        self.styleMenuItems.append(col1)
        self.styleMenuItems.append(col2)
        self.styleMenuItems.append(col3)
        
        self.styleMenuSelector.menuDataSource = self
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
        self.sliderGraphView.backgroundColor = UIColor.clearColor()
        self.sliderGraphView.dataSource = self
        self.sliderGraphView.spacing = self.sliderGraphView.bounds.size.height * 0.1
        self.sliderGraphView.reloadData()
    }
    
    func setupVHSwitch() {
        self.vhSwitch.switchDelegate = self
    }
    
    func setupDataPointAndSeriesSelectors() {
        self.numSeriesSelector.backgroundColor = .clearColor()
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
    
    func setStyleOfDemoControls(style: ShapeStyle) {
        self.numSeriesSelector.thumbStyle = style
        self.dataPointSelector.thumbStyle = style
        self.maxMinDataSlider.thumbStyle = style
        self.vhSwitch.thumbStyle = style
        self.numSeriesSelector.style = style
        self.dataPointSelector.style = style
        self.maxMinDataSlider.style = style
        self.vhSwitch.style = style
    }
    
    func applyColorToDemoControls() {
        self.dataPointSelector.minimumTrackTintColor = self.selectedColor.darkerColor()
        self.dataPointSelector.maximumTrackTintColor = UIColor.clearColor()
        self.dataPointSelector.thumbTintColor = self.selectedThumbColor
        self.numSeriesSelector.minimumTrackTintColor = self.selectedColor.darkerColor()
        self.numSeriesSelector.maximumTrackTintColor = UIColor.clearColor()
        self.numSeriesSelector.thumbTintColor = self.selectedThumbColor
        self.vhSwitch.thumbTintColor = self.selectedThumbColor
        self.vhSwitch.onTintColor = self.selectedColor
        self.maxMinDataSlider.minimumTrackTintColor = self.selectedColor.darkerColor()
        self.maxMinDataSlider.middleTrackTintColor = self.selectedColor
        self.maxMinDataSlider.maximumTrackTintColor = UIColor.clearColor()
        self.maxMinDataSlider.thumbTintColor = self.selectedThumbColor
        self.sliderGraphView.thumbTintColor = self.selectedThumbColor
        self.sliderGraphView.setNeedsLayout()
    }
    
    // MARK: - FlexSwitchDelegate
    
    func switchStateChanged(flexSwitch: FlexSwitch, on: Bool) {
        let on = self.vhSwitch.on
        self.sliderGraphView.spacing = on ? self.sliderGraphView.bounds.size.width * 0.1 : self.sliderGraphView.bounds.size.height * 0.1
        self.sliderGraphView.direction = on ? .Vertical : .Horizontal
    }

    // MARK: - FlexMenuDataSource
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        if menu == self.colorMenuSelectionSlider {
            return self.colorMenuItems.count
        }
        else if menu == self.styleMenuSelector {
            return self.styleMenuItems.count
        }
        return 0
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.colorMenuSelectionSlider {
            return self.colorMenuItems[index]
        }
        else {
            return self.styleMenuItems[index]
        }
    }
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
        if menu == self.colorMenuSelectionSlider {
            switch index {
            case 0:
                self.selectedColor = UIColor.MKColor.Grey.P500
                self.selectedThumbColor = UIColor.MKColor.Amber.P500
            case 1:
                self.selectedColor = UIColor.MKColor.Amber.P500
                self.selectedThumbColor = UIColor.MKColor.LightBlue.P500
            case 2:
                self.selectedColor = UIColor.MKColor.Lime.P500
                self.selectedThumbColor = UIColor.MKColor.Amber.P500
            case 3:
                self.selectedColor = UIColor.MKColor.LightBlue.P500
                self.selectedThumbColor = UIColor.MKColor.Amber.P500
            default:
                break
            }
            self.applyColorToDemoControls()
        }
        else {
            switch index {
            case 0:
                self.setStyleOfDemoControls(.Box)
            case 1:
                self.setStyleOfDemoControls(.Rounded)
            case 2:
                self.setStyleOfDemoControls(.Tube)
            default:
                break
            }
        }
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
        var color = self.selectedColor
        for _ in 0..<series {
            color = color.lightenColor(0.1)
        }
        return color
    }
}

