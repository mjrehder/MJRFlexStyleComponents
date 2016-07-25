//
//  FlexSeriesView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

public protocol FlexSeriesViewDataSource {
    func numberOfSeries(flexSeries: FlexSeriesView) -> Int
    func numberOfDataPoints(flexSeries: FlexSeriesView) -> Int
    func dataOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int) -> Double
    func dataChangedOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int, data: Double)
}

@IBDesignable
public class FlexSeriesView: UIControl {
    var sliders: [GenericStyleSlider] = []
    
    public var dataSource: FlexSeriesViewDataSource? {
        didSet {
            self.initFlexSeries()
        }
    }
    
    /**
     The lowest possible numeric value.
     
     The default value for this property is 0.
     */
    @IBInspectable public var minimumValue: Double = 0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
            // TODO
        }
    }
    
    /**
     The highest possible numeric value.
     
     The default value of this property is 100.
     */
    @IBInspectable public var maximumValue: Double = 100 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
            // TODO
        }
    }

    /**
     The direction of the control
     
     The default is horizontal
     */
    @IBInspectable public var direction: StyleSliderDirection = .Horizontal {
        didSet {
            self.layoutSliders()
        }
    }
    
    /**
     Space between the value sliders
     
     The default value of this property is 10px
     */
    @IBInspectable public var spacing: CGFloat = 10 {
        didSet {
            self.layoutSliders()
        }
    }
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if CGRectIsNull(frame) {
            targetFrame = CGRectMake(0,0,90,30)
        }
        super.init(frame: targetFrame)
        self.initComponent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponent()
    }
    
    public func reloadData() {
        self.initFlexSeries()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutSliders()
    }
    
    func initComponent() {
        // TODO
    }
    
    // MARK: - Slider management
    
    func getCalculationSizeValue(s: CGSize) -> CGFloat {
        return self.direction == .Vertical ? s.width: s.height
    }
    
    func initFlexSeries() {
        self.removeAllSliders()
        if let nos = self.dataSource?.numberOfSeries(self), nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nos > 0, "Number of series must be larger than 0")
            assert(nod > 1, "Number of data points must be larger than 1")
            
            for n in 0..<nod {
                let rect = CGRectMake(0,0,20,20)
                let slider = GenericStyleSlider(frame: rect)
                self.sliders.append(slider)
                self.addSubview(slider)
                self.initSlider(slider)
                slider.valueChangedBlock = {
                    (value, index) in
                    NSLog("Value of index \(index) changed to \(value) in data point \(n)")
                }
            }
            self.layoutSliders()
        }
    }
    
    func layoutSliders() {
        if let nos = self.dataSource?.numberOfSeries(self), nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nos > 0, "Number of series must be larger than 0")
            assert(nod > 1, "Number of data points must be larger than 1")

            let tSize = self.getCalculationSizeValue(self.bounds.size)
            let tSpacing = CGFloat(nod - 1) * self.spacing
            let sliderSize = (tSize - tSpacing) / CGFloat(nod)
            
            for n in 0..<nod {
                let slider = self.sliders[n]
                var values: [Double] = []
                for s in 0..<nos {
                    let data = self.dataSource?.dataOfSeriesAtPoint(self, series: s, point: n) ?? 0
                    values.append(data)
                }
                slider.values = values

                let sliderOffset = sliderSize + self.spacing
                let rect: CGRect
                if self.direction == .Horizontal {
                    rect = CGRectMake(0, sliderOffset * CGFloat(n), self.bounds.size.width, sliderSize)
                }
                else {
                    rect = CGRectMake(sliderOffset * CGFloat(n), 0, sliderSize, self.bounds.size.height)
                }
                slider.frame = rect
                slider.thumbRatio = rect.size.height / rect.size.width
                slider.layoutComponents()
            }
        }
    }
    
    func initSlider(slider: GenericStyleSlider) {
        slider.backgroundColor = .clearColor()
        slider.continuous = true
        slider.style = .Thumb
        slider.thumbStyle = .Thumb
        slider.separatorStyle = .Box
        slider.minimumValue = self.minimumValue
        slider.maximumValue = self.maximumValue
        slider.thumbSnappingBehaviour = .Freeform
        slider.thumbBackgroundColor = UIColor.grayColor()
    }
    
    func removeAllSliders() {
        for slider in self.sliders {
            slider.removeFromSuperview()
        }
        self.sliders.removeAll()
    }
    
}
