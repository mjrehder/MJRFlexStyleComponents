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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSimpleSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupSimpleSlider() {
        self.simpleSlider.thumbBackgroundColor = UIColor.greenColor()
        self.simpleSlider.thumbWidthRatio = 0.06
        self.simpleSlider.addThumb(0.0)
    }
}

