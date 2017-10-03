//
//  FlexSeriesView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
/*
 * Copyright 2016-present Martin Jacob Rehder.
 * http://www.rehsco.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

public protocol FlexSeriesViewDataSource {
    func numberOfSeries(_ flexSeries: FlexSeriesView) -> Int
    func numberOfDataPoints(_ flexSeries: FlexSeriesView) -> Int
    func dataOfSeriesAtPoint(_ flexSeries: FlexSeriesView, series: Int, point: Int) -> Double
    func colorOfSeries(_ flexSeries: FlexSeriesView, series: Int) -> UIColor
    func dataChangedOfSeriesAtPoint(_ flexSeries: FlexSeriesView, series: Int, point: Int, data: Double)
}

@IBDesignable
open class FlexSeriesView: UIControl {
    var sliders: [GenericStyleSlider] = []
    
    var bgShape = CAShapeLayer()
    
    open var dataSource: FlexSeriesViewDataSource? {
        didSet {
            self.initFlexSeries()
        }
    }
    
    /**
     The lowest possible numeric value.
     
     The default value for this property is 0.
     */
    @IBInspectable open var minimumValue: Double = 0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
            self.assignMaxMinToSliders()
        }
    }
    
    /**
     The highest possible numeric value.
     
     The default value of this property is 100.
     */
    @IBInspectable open var maximumValue: Double = 100 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
            self.assignMaxMinToSliders()
        }
    }

    /**
     The direction of the control
     
     The default is horizontal
     */
    open var direction: StyledControlDirection = .horizontal {
        didSet {
            for slider in self.sliders {
                slider.direction = direction
            }
            self.layoutSliders()
        }
    }
    
    /**
     Size of the sliders
     This is the height or the width, depending on the direction
     
     The default value of this property is 32pt
     */
    @IBInspectable open var itemSize: CGFloat = 32 {
        didSet {
            self.layoutSliders()
        }
    }
    
    @IBInspectable open var thumbTintColor: UIColor? = UIColor.gray {
        didSet {
            for slider in self.sliders {
                slider.thumbBackgroundColor = self.thumbTintColor
            }
        }
    }
    
    public override init(frame: CGRect) {
        var targetFrame = frame
        if frame.isNull {
            targetFrame = CGRect(x: 0,y: 0,width: 90,height: 30)
        }
        super.init(frame: targetFrame)
        self.initComponent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponent()
    }
    
    open func reloadData() {
        self.initFlexSeries()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutSliders()
        self.applyBackgroundLayer()
    }
    
    func initComponent() {
        self.layer.addSublayer(self.bgShape)
    }
    
    // MARK: - Slider management
    
    func assignMaxMinToSliders() {
        for slider in self.sliders {
            slider.maximumValue = self.maximumValue
            slider.minimumValue = self.minimumValue
        }
        self.layoutSliders()
        self.applyBackgroundLayer()
    }
    
    func getCalculationSizeValue(_ s: CGSize) -> CGFloat {
        return self.direction == .vertical ? s.width: s.height
    }
    
    func initFlexSeries() {
        self.removeAllSliders()
        if let nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nod > 1, "Number of data points must be larger than 1")
            
            for n in 0..<nod {
                let rect = CGRect(x: 0,y: 0,width: 20,height: 20)
                let slider = GenericStyleSlider(frame: rect)
                slider.direction = self.direction
                self.sliders.append(slider)
                self.addSubview(slider)
                self.initSlider(slider)
                slider.valueChangedBlock = {
                    (value, index) in
                    self.dataSource?.dataChangedOfSeriesAtPoint(self, series: index, point: n, data: value)
                    self.applyBackgroundLayer()
                }
            }
            self.layoutSliders()
            self.updateDataInSliders()
        }
    }
    
    func layoutSliders() {
        if let nos = self.dataSource?.numberOfSeries(self), let nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nos > 0, "Number of series must be larger than 0")
            assert(nod > 1, "Number of data points must be larger than 1")

            let tSize = self.getCalculationSizeValue(self.bounds.size)
            let tSpacing = (tSize - (self.itemSize * CGFloat(nod))) / CGFloat(nod-1)
            
            for n in 0..<nod {
                let slider = self.sliders[n]
                let sliderOffset = self.itemSize + tSpacing
                let rect: CGRect
                if self.direction == .horizontal {
                    rect = CGRect(x: 0, y: sliderOffset * CGFloat(n), width: self.bounds.size.width, height: self.itemSize)
                }
                else {
                    rect = CGRect(x: sliderOffset * CGFloat(n), y: 0, width: self.itemSize, height: self.bounds.size.height)
                }
                slider.frame = rect
                slider.thumbRatio = self.direction == .horizontal ? rect.size.height / rect.size.width : rect.size.width / rect.size.height
                slider.layoutComponents()
            }
        }
    }
    
    func updateDataInSliders() {
        if let nos = self.dataSource?.numberOfSeries(self), let nod = self.dataSource?.numberOfDataPoints(self) {
            for n in 0..<nod {
                let slider = self.sliders[n]
                var values: [Double] = []
                for s in 0..<nos {
                    let data = self.dataSource?.dataOfSeriesAtPoint(self, series: s, point: n) ?? 0
                    values.append(data)
                }
                slider.values = values
            }
        }
    }
    
    func initSlider(_ slider: GenericStyleSlider) {
        slider.backgroundColor = .clear
        slider.continuous = true
        slider.style = FlexShapeStyle(style: .thumb)
        slider.thumbStyle = FlexShapeStyle(style: .thumb)
        slider.separatorStyle = FlexShapeStyle(style: .box)
        slider.minimumValue = self.minimumValue
        slider.maximumValue = self.maximumValue
        slider.thumbSnappingBehaviour = .freeform
        slider.thumbBackgroundColor = self.thumbTintColor
    }
    
    func removeAllSliders() {
        for slider in self.sliders {
            slider.removeFromSuperview()
        }
        self.sliders.removeAll()
    }
    
    // MARK: - Background layer

    /**
     The series are always drawn as full layers from the zero line to the curve formed by the data points.
     
     TODO:
     * Option to have lines only
     * Option to have straight connections instead of bezier curves
     */
    
    func valueOffsetRatio() -> CGFloat {
        let d = self.maximumValue / (self.maximumValue - self.minimumValue)
        return CGFloat(d)
    }
    
    func addValueToCalculationPoint(_ p: CGPoint, val: CGFloat) -> CGPoint {
        return self.direction == .horizontal ? CGPoint(x: p.x, y: p.y + val) : CGPoint(x: p.x + val, y: p.y)
    }
    
    func prevBezierPathLine(_ series: Int, path: UIBezierPath) {
        if self.direction == .horizontal {
            path.addLine(to: CGPoint.zero)
        }
        else {
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        }
    }

    func currentBezierPathLine(_ series: Int, path: UIBezierPath) {
        var points: [CGPoint] = []
        if let nod = self.dataSource?.numberOfDataPoints(self) {
            let tSize = self.getCalculationSizeValue(self.bounds.size)
            let tSpacing = (tSize - (self.itemSize * CGFloat(nod))) / CGFloat(nod-1)
            
            if self.direction == .vertical {
                for n in (0..<nod).reversed() {
                    let slider = self.sliders[n]
                    let sliderOffset = (self.itemSize + tSpacing)*CGFloat(n)
                    let p = slider.thumbList.thumbs[series].center
                    points.append(self.addValueToCalculationPoint(p, val: sliderOffset))
                }
            }
            else {
                for n in 0..<nod {
                    let slider = self.sliders[n]
                    let sliderOffset = (self.itemSize + tSpacing)*CGFloat(n)
                    let p = slider.thumbList.thumbs[series].center
                    points.append(self.addValueToCalculationPoint(p, val: sliderOffset))
                }
            }
        }
        let sp: CGPoint
        if self.direction == .horizontal {
            sp = CGPoint(x: points[0].x, y: 0)
        }
        else {
            sp = CGPoint(x: self.bounds.size.width, y: points[0].y)
        }
        path.addLine(to: sp)
        BezierPathHelper.addBezierCurveWithPoints(path, points: points)
        let ep: CGPoint
        if self.direction == .horizontal {
            ep = CGPoint(x: points[points.count-1].x, y: self.bounds.size.height)
        }
        else {
            ep = CGPoint(x: 0, y: points[points.count-1].y)
        }
        path.addLine(to: ep)
    }
    
    func prevBezierPathStart(_ series: Int) -> CGPoint {
        if self.direction == .horizontal {
            return CGPoint(x: 0, y: self.bounds.size.height)
        }
        else {
            return CGPoint.zero
        }
    }
    
    func createBezierPath(_ series: Int) -> UIBezierPath {
        let path = UIBezierPath()
        
        let sp = self.prevBezierPathStart(series)
        path.move(to: sp)
        self.prevBezierPathLine(series, path: path)
        self.currentBezierPathLine(series, path: path)
        path.addLine(to: sp)
        return path
    }
    
    func createShapeLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        if let nos = self.dataSource?.numberOfSeries(self) {
            for s in (0..<nos).reversed() {
                let subShape = CAShapeLayer()
                let path = self.createBezierPath(s)
                subShape.path = path.cgPath
                subShape.fillColor = self.dataSource?.colorOfSeries(self, series: s).cgColor ?? UIColor.clear.cgColor
                shape.addSublayer(subShape)
            }
        }
        return shape
    }
    
    func applyBackgroundLayer() {
        let bgsLayer = self.createShapeLayer()
        
        if self.bgShape.superlayer != nil {
            layer.replaceSublayer(self.bgShape, with: bgsLayer)
        }
        
        self.bgShape = bgsLayer
    }
}
