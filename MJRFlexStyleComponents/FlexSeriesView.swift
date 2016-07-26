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
    func colorOfSeries(flexSeries: FlexSeriesView, series: Int) -> UIColor
    func dataChangedOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int, data: Double)
}

@IBDesignable
public class FlexSeriesView: UIControl {
    var sliders: [GenericStyleSlider] = []
    
    var bgShape = CAShapeLayer()
    
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
    
    func getCalculationSizeValue(s: CGSize) -> CGFloat {
        return self.direction == .Vertical ? s.width: s.height
    }
    
    func initFlexSeries() {
        self.removeAllSliders()
        if let nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nod > 1, "Number of data points must be larger than 1")
            
            for n in 0..<nod {
                let rect = CGRectMake(0,0,20,20)
                let slider = GenericStyleSlider(frame: rect)
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
        if let nos = self.dataSource?.numberOfSeries(self), nod = self.dataSource?.numberOfDataPoints(self) {
            assert(nos > 0, "Number of series must be larger than 0")
            assert(nod > 1, "Number of data points must be larger than 1")

            let tSize = self.getCalculationSizeValue(self.bounds.size)
            let tSpacing = CGFloat(nod - 1) * self.spacing
            let sliderSize = (tSize - tSpacing) / CGFloat(nod)
            
            for n in 0..<nod {
                let slider = self.sliders[n]
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
    
    func updateDataInSliders() {
        if let nos = self.dataSource?.numberOfSeries(self), nod = self.dataSource?.numberOfDataPoints(self) {
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
    
    // MARK: - Background layer

    /**
     The series are always drawn as full layers from the zero line to the curve formed by the data points.
     
     TODO:
     * Option to have lines only
     * Option to have straight connections instead of bezier curves
     */
    
    func addValueToCalculationPoint(p: CGPoint, val: CGFloat) -> CGPoint {
        return self.direction == .Horizontal ? CGPointMake(p.x, p.y + val) : CGPointMake(p.x + val, p.y)
    }
    
    func prevBezierPathLine(series: Int, path: UIBezierPath) {
        if self.direction == .Horizontal {
            path.addLineToPoint(CGPointZero)
        }
        else {
            path.addLineToPoint(CGPointMake(self.bounds.size.width, 0))
        }
    }

    func currentBezierPathLine(series: Int, path: UIBezierPath) {
        var points: [CGPoint] = []
        if let nod = self.dataSource?.numberOfDataPoints(self) {
            let tSize = self.getCalculationSizeValue(self.bounds.size)
            let tSpacing = CGFloat(nod - 1) * self.spacing
            let sliderSize = (tSize - tSpacing) / CGFloat(nod)
            
            for n in 0..<nod {
                let slider = self.sliders[n]
                let sliderOffset = (sliderSize + self.spacing)*CGFloat(n)
                let p = slider.thumbList.thumbs[series].center
                points.append(self.addValueToCalculationPoint(p, val: sliderOffset))
            }
        }
        let sp: CGPoint
        if self.direction == .Horizontal {
            sp = CGPointMake(points[0].x, 0)
        }
        else {
            sp = CGPointMake(self.bounds.size.width, points[0].y)
        }
        path.addLineToPoint(sp)
        BezierPathHelper.addBezierCurveWithPoints(path, points: points)
        let ep: CGPoint
        if self.direction == .Horizontal {
            ep = CGPointMake(points[points.count-1].x, self.bounds.size.height)
        }
        else {
            ep = CGPointMake(0, points[points.count-1].y)
        }
        path.addLineToPoint(ep)
    }
    
    func prevBezierPathStart(series: Int) -> CGPoint {
        if self.direction == .Horizontal {
            return CGPointMake(0, self.bounds.size.height)
        }
        else {
            return CGPointZero
        }
    }
    
    func createBezierPath(series: Int) -> UIBezierPath {
        let path = UIBezierPath()
        
        let sp = self.prevBezierPathStart(series)
        path.moveToPoint(sp)
        self.prevBezierPathLine(series, path: path)
        self.currentBezierPathLine(series, path: path)
        path.addLineToPoint(sp)
        return path
    }
    
    func createShapeLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        if let nos = self.dataSource?.numberOfSeries(self) {
            for s in (0..<nos).reverse() {
                let subShape = CAShapeLayer()
                let path = self.createBezierPath(s)
                subShape.path = path.CGPath
                subShape.fillColor = self.dataSource?.colorOfSeries(self, series: s).CGColor ?? UIColor.clearColor().CGColor
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
