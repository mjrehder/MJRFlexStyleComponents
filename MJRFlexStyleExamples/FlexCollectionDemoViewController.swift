//
//  FlexCollectionDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 06.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class FlexCollectionDemoViewController: UIViewController, FlexCollectionViewDelegate {
    
    @IBOutlet weak var demoCollectionView: FlexCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.demoCollectionView.flexCollectionDelegate = self
        self.demoCollectionView.defaultCellSize = CGSizeMake(250, 64)
        
        let secRef = self.demoCollectionView.addSection()

        // Simple Image,Text,Accessory Item
        let ti1 = UIImage(named: "ThumbIcon1")
        let ti2 = UIImage(named: "ThumbIcon2")
        let item1 = FlexBaseCollectionItem(reference: "item1ref", text: NSAttributedString(string: "Text"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 1")) {
            NSLog("did press accessory image")
        }
        item1.imageViewActionHandler = {
            NSLog("image view pressed")
        }
        self.demoCollectionView.addItem(secRef, item: item1)
        
        // Color item
        let colItem = FlexColorCollectionItem(reference: "colorItem", color: .yellowColor(), text: NSAttributedString(string: "Color"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 2")) { 
            NSLog("did press color view")
        }
        self.demoCollectionView.addItem(secRef, item: colItem)
        
        // Switch value
        let switchItem = FlexSwitchCollectionItem(reference: "switch", value: true, text: NSAttributedString(string: "Switch"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 3")) { (value) in
            NSLog("The switch is now \(value)")
        }
        let siApp = FlexStyleAppearance()
        siApp.cellControlSize = CGSizeMake(48,32)
        switchItem.cellAppearance = siApp
        self.demoCollectionView.addItem(secRef, item: switchItem)
        
        // Slider value
        let sliderItem = FlexSliderCollectionItem(reference: "slider", value: 0, text: NSAttributedString(string: "Slider"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 4")) { (value) in
            NSLog("The slider is now \(value)")
        }
        let slApp = FlexStyleAppearance()
        slApp.cellControlInsets = UIEdgeInsetsMake(0, 0, 5, 0)
        sliderItem.cellAppearance = slApp
        self.demoCollectionView.addItem(secRef, item: sliderItem)
    }
    
    // MARK: - FlexCollectionViewDelegate
    
    func onFlexCollectionItemMoved(view: FlexCollectionView, item: FlexCollectionItem) {
    }
    
    func onFlexCollectionItemSelected(view: FlexCollectionView, item: FlexCollectionItem) {
        NSLog("Item \(item.reference) selected")
    }
}
