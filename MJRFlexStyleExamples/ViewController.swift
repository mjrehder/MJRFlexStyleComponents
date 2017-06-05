//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import StyledLabel
import MJRFlexStyleComponents

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
        self.setStyleOfDemoControls(.tube)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupMaxMinDataSlider() {
        self.maxMinDataSlider.backgroundColor = UIColor.clear
        self.maxMinDataSlider.direction = .vertical
        self.maxMinDataSlider.minimumValue = 0
        self.maxMinDataSlider.maximumValue = 100
        self.maxMinDataSlider.thumbRatio = 0.1
        self.maxMinDataSlider.hintStyle = .rounded
        self.maxMinDataSlider.thumbText = nil
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
        self.styleMenuSelector.thumbStyle = FlexShapeStyle(style: .rounded)
        self.styleMenuSelector.style = FlexShapeStyle(style: .rounded)
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
        self.colorMenuSelectionSlider.thumbStyle = FlexShapeStyle(style: .rounded)
        self.colorMenuSelectionSlider.style = FlexShapeStyle(style: .rounded)
    }
    
    func setupSliderGraphView() {
        self.sliderGraphView.layer.borderWidth = 1.0
        self.sliderGraphView.layer.borderColor = UIColor.black.cgColor
        self.sliderGraphView.layer.masksToBounds = true
        self.sliderGraphView.layer.cornerRadius = 10
        self.sliderGraphView.itemSize = 24
        self.sliderGraphView.backgroundColor = UIColor.clear
        self.sliderGraphView.dataSource = self
        self.sliderGraphView.reloadData()
    }
    
    func setupVHSwitch() {
        self.vhSwitch.switchDelegate = self
    }
    
    func setupDataPointAndSeriesSelectors() {
        self.numSeriesSelector.backgroundColor = .clear
        self.numSeriesSelector.minimumValue = 1
        self.numSeriesSelector.maximumValue = 4
        self.numSeriesSelector.value = Double(numSeries)
        self.numSeriesSelector.thumbText = nil
        self.numSeriesSelector.numberFormatString = "%.0f"
        self.numSeriesSelector.maximumTrackText = "Series"
        self.numSeriesSelector.valueChangedBlock = {
            (value, index) in
            self.numSeries = Int(round(value))
            self.createDemoDataForGraph()
            self.sliderGraphView.reloadData()
        }
        
        self.dataPointSelector.backgroundColor = .clear
        self.dataPointSelector.minimumValue = 2
        self.dataPointSelector.maximumValue = 7
        self.dataPointSelector.thumbText = nil
        self.dataPointSelector.numberFormatString = "%.0f"
        self.dataPointSelector.value = Double(numDataPoints)
        self.dataPointSelector.maximumTrackText = "Data Points"
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
                let r = Double(arc4random() % 100) / 10.0
                dataPoints.append(Double(s)*10.0 + r)
            }
            newDemoData.append(dataPoints)
        }
        self.dataSeries = newDemoData
    }
    
    func setStyleOfDemoControls(_ style: ShapeStyle) {
        let st = FlexShapeStyle(style: style)
        self.numSeriesSelector.thumbStyle = st
        self.dataPointSelector.thumbStyle = st
        self.maxMinDataSlider.thumbStyle = st
        self.vhSwitch.thumbStyle = st
        self.numSeriesSelector.style = st
        self.dataPointSelector.style = st
        self.maxMinDataSlider.style = st
        self.vhSwitch.style = st
    }
    
    func applyColorToDemoControls() {
        self.dataPointSelector.minimumTrackTintColor = self.selectedColor.darkened()
        self.dataPointSelector.maximumTrackTintColor = UIColor.clear
        self.dataPointSelector.thumbTintColor = self.selectedThumbColor
        self.numSeriesSelector.minimumTrackTintColor = self.selectedColor.darkened()
        self.numSeriesSelector.maximumTrackTintColor = UIColor.clear
        self.numSeriesSelector.thumbTintColor = self.selectedThumbColor
        self.vhSwitch.thumbTintColor = self.selectedThumbColor
        self.vhSwitch.onTintColor = self.selectedColor
        self.vhSwitch.borderColor = .black
        self.vhSwitch.borderWidth = 0.5
        self.maxMinDataSlider.minimumTrackTintColor = self.selectedColor.darkened()
        self.maxMinDataSlider.middleTrackTintColor = self.selectedColor
        self.maxMinDataSlider.maximumTrackTintColor = UIColor.clear
        self.maxMinDataSlider.thumbTintColor = self.selectedThumbColor
        self.sliderGraphView.thumbTintColor = self.selectedThumbColor
        self.sliderGraphView.setNeedsLayout()
    }
    
    // MARK: - FlexSwitchDelegate
    
    func switchStateChanged(_ flexSwitch: FlexSwitch, on: Bool) {
        let on = self.vhSwitch.on
        self.sliderGraphView.direction = on ? .vertical : .horizontal
    }

    // MARK: - FlexMenuDataSource
    
    func numberOfMenuItems(_ menu: FlexMenu) -> Int {
        if menu == self.colorMenuSelectionSlider {
            return self.colorMenuItems.count
        }
        else if menu == self.styleMenuSelector {
            return self.styleMenuItems.count
        }
        return 0
    }
    
    func menuItemForIndex(_ menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.colorMenuSelectionSlider {
            return self.colorMenuItems[index]
        }
        else {
            return self.styleMenuItems[index]
        }
    }
    
    func menuItemSelected(_ menu: FlexMenu, index: Int) {
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
                self.setStyleOfDemoControls(.box)
            case 1:
                self.setStyleOfDemoControls(.rounded)
            case 2:
                self.setStyleOfDemoControls(.tube)
            default:
                break
            }
        }
    }
    
    // MARK: - FlexSeriesViewDataSource
    
    func dataOfSeriesAtPoint(_ flexSeries: FlexSeriesView, series: Int, point: Int) -> Double {
        return self.dataSeries[series][point]
    }
    
    func dataChangedOfSeriesAtPoint(_ flexSeries: FlexSeriesView, series: Int, point: Int, data: Double) {
        if self.dataSeries.count < series {
            if self.dataSeries[series].count < point {
                self.dataSeries[series][point] = data
            }
        }
    }
    
    func numberOfSeries(_ flexSeries: FlexSeriesView) -> Int {
        return self.numSeries
    }
    
    func numberOfDataPoints(_ flexSeries: FlexSeriesView) -> Int {
        return self.numDataPoints
    }
    
    func colorOfSeries(_ flexSeries: FlexSeriesView, series: Int) -> UIColor {
        var color = self.selectedColor
        for _ in 0..<series {
            color = color.lighter(amount: 0.1)
        }
        return color
    }
}

