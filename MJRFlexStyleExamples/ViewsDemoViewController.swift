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
        self.outerFlexView.style = FlexShapeStyle(style: .custom(path: cpath))
        self.outerFlexView.styleColor = UIColor.MKColor.BlueGrey.P100
        self.outerFlexView.header.styleColor = UIColor.MKColor.BlueGrey.P500
        self.outerFlexView.header.caption.labelTextAlignment = .center
        
        self.outerFlexView.headerSize = 22
        self.outerFlexView.header.caption.labelFont = UIFont.systemFont(ofSize: 18)
        self.outerFlexView.footer.caption.labelFont = UIFont.systemFont(ofSize: 14)
        self.outerFlexView.header.caption.labelTextColor = UIColor.white
        self.outerFlexView.footer.styleColor = .clear
        self.outerFlexView.footer.caption.labelTextAlignment = .center

        leftFlexView.headerPosition = .left
        leftFlexView.backgroundInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        leftFlexView.headerText = "Left"
        leftFlexView.footerText = "Left Footer"
        leftFlexView.styleColor = UIColor.MKColor.Amber.P100
        leftFlexView.header.styleColor = UIColor.MKColor.Amber.P500
        leftFlexView.headerClipToBackgroundShape = false
        leftFlexView.headerSize = 16
        leftFlexView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 10)
        leftFlexView.footer.caption.labelFont = UIFont.systemFont(ofSize: 10)
        leftFlexView.header.caption.labelTextColor = UIColor.white
        leftFlexView.header.caption.labelTextAlignment = .center
        leftFlexView.footer.caption.labelTextAlignment = .center
        leftFlexView.footer.caption.labelTextColor = UIColor.black
        leftFlexView.footer.styleColor = .clear
        leftFlexView.style = FlexShapeStyle(style: .custom(path: UIBezierPath(roundedRect: leftFlexView.bounds, cornerRadius: 10)))
        
        rightFlexView.headerPosition = .right
        rightFlexView.backgroundInsets = UIEdgeInsetsMake(0, 15, 0, 20)
        rightFlexView.headerText = "Right"
        rightFlexView.footerText = "Footer"
        rightFlexView.footerSecondaryText = "2nd Caption"
        rightFlexView.styleColor = UIColor.MKColor.Amber.P100
        rightFlexView.header.styleColor = UIColor.MKColor.Amber.P500
        rightFlexView.headerSize = 16
        rightFlexView.header.style = FlexShapeStyle(style: .tube)
        rightFlexView.headerClipToBackgroundShape = false

        rightFlexView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 10)
        rightFlexView.header.caption.labelTextAlignment = .center
        rightFlexView.header.caption.labelTextColor = UIColor.white

        rightFlexView.footer.caption.labelFont = UIFont.systemFont(ofSize: 10)
        rightFlexView.footer.caption.labelTextAlignment = .left
        rightFlexView.footer.caption.labelTextColor = UIColor.black

        rightFlexView.footer.secondaryCaption.labelFont = UIFont.systemFont(ofSize: 10)
        rightFlexView.footer.secondaryCaption.labelTextAlignment = .right
        rightFlexView.footer.secondaryCaption.labelTextColor = UIColor.darkGray

        rightFlexView.footerClipToBackgroundShape = false
        rightFlexView.footer.styleColor = .clear
        rightFlexView.style = FlexShapeStyle(style: .custom(path: UIBezierPath(roundedRect: rightFlexView.bounds, cornerRadius: 10)))

    }
}
