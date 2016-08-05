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
        self.outerFlexView.headerBackgroundColor = UIColor.MKColor.BlueGrey.P500
        
        self.outerFlexView.headerSize = 22
        self.outerFlexView.headerFont = UIFont.systemFontOfSize(18)
        self.outerFlexView.footerFont = UIFont.systemFontOfSize(14)
        self.outerFlexView.headerTextColor = UIColor.whiteColor()

        leftFlexView.headerPosition = .Left
        leftFlexView.backgroundMargins = UIEdgeInsetsMake(0, 20, 0, 0)
        leftFlexView.headerText = "Left"
        leftFlexView.footerText = "Left Footer"
        leftFlexView.styleColor = UIColor.MKColor.Amber.P100
        leftFlexView.headerBackgroundColor = UIColor.MKColor.Amber.P500
        leftFlexView.headerClipToBackgroundShape = false
        leftFlexView.headerSize = 16
        leftFlexView.headerFont = UIFont.boldSystemFontOfSize(10)
        leftFlexView.footerFont = UIFont.systemFontOfSize(10)
        leftFlexView.headerTextColor = UIColor.whiteColor()
        leftFlexView.style = .Custom(path: UIBezierPath(roundedRect: leftFlexView.bounds, cornerRadius: 10))
        
        rightFlexView.headerPosition = .Right
        rightFlexView.backgroundMargins = UIEdgeInsetsMake(0, 15, 0, 20)
        rightFlexView.headerText = "Right"
        rightFlexView.footerText = "Right Footer"
        rightFlexView.styleColor = UIColor.MKColor.Amber.P100
        rightFlexView.headerBackgroundColor = UIColor.MKColor.Amber.P500
        rightFlexView.headerSize = 16
        rightFlexView.headerStyle = .Tube
        rightFlexView.headerClipToBackgroundShape = false
        rightFlexView.headerFont = UIFont.boldSystemFontOfSize(10)
        rightFlexView.footerFont = UIFont.systemFontOfSize(10)
        rightFlexView.footerClipToBackgroundShape = false
        rightFlexView.headerTextColor = UIColor.whiteColor()
        rightFlexView.style = .Custom(path: UIBezierPath(roundedRect: rightFlexView.bounds, cornerRadius: 10))

    }
}
