//
//  FlexTextViewDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 06.09.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class FlexTextViewDemoViewController: UIViewController {

    @IBOutlet weak var flexTextView: FlexTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.flexTextView.headerText = "FlexTextView"
        self.flexTextView.textView.attributedText = NSAttributedString(string: "This is a demo text for the FlexTextView. What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
        self.flexTextView.textView.backgroundColor = UIColor.clearColor()
        
        self.flexTextView.headerPosition = .Top
        self.flexTextView.style = .RoundedFixed(cornerRadius: 10.0)
        self.flexTextView.styleColor = UIColor.MKColor.Teal.P50
        self.flexTextView.headerBackgroundColor = UIColor.MKColor.Teal.P700
        self.flexTextView.headerFont = UIFont.boldSystemFontOfSize(14)
        self.flexTextView.headerTextColor = UIColor.whiteColor()
    }
}
