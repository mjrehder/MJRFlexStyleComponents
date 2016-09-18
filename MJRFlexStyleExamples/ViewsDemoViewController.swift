//
//  ViewsDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 04.08.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ViewsDemoViewController: UIViewController {

    @IBOutlet weak var outerFlexView: FlexView!
    
    @IBOutlet weak var leftFlexView: FlexView!
    
    @IBOutlet weak var rightFlexView: FlexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        let cpath = UIBezierPath(roundedRect: self.outerFlexView.bounds, cornerRadius: 10)
        self.outerFlexView.style = .Custom(path: cpath)
        self.outerFlexView.styleColor = UIColor.MKColor.BlueGrey.P100
        self.outerFlexView.headerLabel.labelBackgroundColor = UIColor.MKColor.BlueGrey.P500
        
        self.outerFlexView.headerSize = 22
        self.outerFlexView.headerLabel.labelFont = UIFont.systemFontOfSize(18)
        self.outerFlexView.footerLabel.labelFont = UIFont.systemFontOfSize(14)
        self.outerFlexView.headerLabel.labelTextColor = UIColor.whiteColor()

        leftFlexView.headerPosition = .Left
        leftFlexView.backgroundMargins = UIEdgeInsetsMake(0, 20, 0, 0)
        leftFlexView.headerText = "Left"
        leftFlexView.footerText = "Left Footer"
        leftFlexView.styleColor = UIColor.MKColor.Amber.P100
        leftFlexView.headerLabel.labelBackgroundColor = UIColor.MKColor.Amber.P500
        leftFlexView.headerClipToBackgroundShape = false
        leftFlexView.headerSize = 16
        leftFlexView.headerLabel.labelFont = UIFont.boldSystemFontOfSize(10)
        leftFlexView.footerLabel.labelFont = UIFont.systemFontOfSize(10)
        leftFlexView.headerLabel.labelTextColor = UIColor.whiteColor()
        leftFlexView.style = .Custom(path: UIBezierPath(roundedRect: leftFlexView.bounds, cornerRadius: 10))
        
        rightFlexView.headerPosition = .Right
        rightFlexView.backgroundMargins = UIEdgeInsetsMake(0, 15, 0, 20)
        rightFlexView.headerText = "Right"
        rightFlexView.footerText = "Right Footer"
        rightFlexView.styleColor = UIColor.MKColor.Amber.P100
        rightFlexView.headerLabel.labelBackgroundColor = UIColor.MKColor.Amber.P500
        rightFlexView.headerSize = 16
        rightFlexView.headerLabel.style = .Tube
        rightFlexView.headerClipToBackgroundShape = false
        rightFlexView.headerLabel.labelFont = UIFont.boldSystemFontOfSize(10)
        rightFlexView.footerLabel.labelFont = UIFont.systemFontOfSize(10)
        rightFlexView.footerClipToBackgroundShape = false
        rightFlexView.headerLabel.labelTextColor = UIColor.whiteColor()
        rightFlexView.style = .Custom(path: UIBezierPath(roundedRect: rightFlexView.bounds, cornerRadius: 10))

    }
}
