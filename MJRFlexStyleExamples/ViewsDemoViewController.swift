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
        self.outerFlexView.style = .custom(path: cpath)
        self.outerFlexView.styleColor = UIColor.MKColor.BlueGrey.P100
        self.outerFlexView.header.labelBackgroundColor = UIColor.MKColor.BlueGrey.P500
        
        self.outerFlexView.headerSize = 22
        self.outerFlexView.header.labelFont = UIFont.systemFont(ofSize: 18)
        self.outerFlexView.footer.labelFont = UIFont.systemFont(ofSize: 14)
        self.outerFlexView.header.labelTextColor = UIColor.white
        self.outerFlexView.footer.labelBackgroundColor = .clear

        leftFlexView.headerPosition = .left
        leftFlexView.backgroundInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        leftFlexView.headerText = "Left"
        leftFlexView.footerText = "Left Footer"
        leftFlexView.styleColor = UIColor.MKColor.Amber.P100
        leftFlexView.header.labelBackgroundColor = UIColor.MKColor.Amber.P500
        leftFlexView.headerClipToBackgroundShape = false
        leftFlexView.headerSize = 16
        leftFlexView.header.labelFont = UIFont.boldSystemFont(ofSize: 10)
        leftFlexView.footer.labelFont = UIFont.systemFont(ofSize: 10)
        leftFlexView.header.labelTextColor = UIColor.white
        leftFlexView.footer.labelTextColor = UIColor.black
        leftFlexView.footer.labelBackgroundColor = .clear
        leftFlexView.style = .custom(path: UIBezierPath(roundedRect: leftFlexView.bounds, cornerRadius: 10))
        
        rightFlexView.headerPosition = .right
        rightFlexView.backgroundInsets = UIEdgeInsetsMake(0, 15, 0, 20)
        rightFlexView.headerText = "Right"
        rightFlexView.footerText = "Right Footer"
        rightFlexView.styleColor = UIColor.MKColor.Amber.P100
        rightFlexView.header.labelBackgroundColor = UIColor.MKColor.Amber.P500
        rightFlexView.headerSize = 16
        rightFlexView.header.style = .tube
        rightFlexView.headerClipToBackgroundShape = false
        rightFlexView.header.labelFont = UIFont.boldSystemFont(ofSize: 10)
        rightFlexView.footer.labelFont = UIFont.systemFont(ofSize: 10)
        rightFlexView.footerClipToBackgroundShape = false
        rightFlexView.footer.labelBackgroundColor = .clear
        rightFlexView.header.labelTextColor = UIColor.white
        rightFlexView.footer.labelTextColor = UIColor.black
        rightFlexView.style = .custom(path: UIBezierPath(roundedRect: rightFlexView.bounds, cornerRadius: 10))

    }
}
