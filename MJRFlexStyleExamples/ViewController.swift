//
//  ViewController.swift
//  MJRFlexStyleExamples
//
//  Created by Martin Rehder on 16.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var simpleSlider: GenericStyleSlider!
    @IBOutlet weak var verticalSimpleSlider: GenericStyleSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSimpleSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupSimpleSlider() {
        self.simpleSlider.thumbBackgroundColor = UIColor.greenColor()
        self.simpleSlider.thumbWidthRatio = 0.1
        self.simpleSlider.thumbText = nil
        self.simpleSlider.values = [0.0, 0.5, 0.75]
        
        self.verticalSimpleSlider.thumbBackgroundColor = UIColor.greenColor()
        self.verticalSimpleSlider.direction = .Vertical
        self.verticalSimpleSlider.thumbWidthRatio = 0.1
        self.verticalSimpleSlider.thumbText = nil
        self.verticalSimpleSlider.values = [0.0, 0.5, 0.75]
        
    }
}

