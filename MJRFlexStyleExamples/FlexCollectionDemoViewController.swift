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
        self.demoCollectionView.headerText = "Collection Demo"
        
        // Setup demo style
        let collectionDemoStyle = FlexStyleAppearance()
        collectionDemoStyle.styleColor = UIColor.MKColor.Brown.P50
        collectionDemoStyle.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        collectionDemoStyle.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        self.demoCollectionView.appearance = collectionDemoStyle
        self.demoCollectionView.collectionCellAppearance = collectionDemoStyle
        
        let secRef = self.demoCollectionView.addSection()

        let cellAppearance = FlexStyleCollectionCellAppearance()
        cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        cellAppearance.controlSize = CGSizeMake(32,32)
        cellAppearance.controlBorderWidth = 1.0
        cellAppearance.controlBorderColor = UIColor.MKColor.Brown.P500
        
        // Simple Text
        let item0 = FlexBaseCollectionItem(reference: "item0ref", text: NSAttributedString(string: "Simple Text"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 0"))
        let i0App = FlexStyleAppearance()
        i0App.styleColor = UIColor.MKColor.Brown.P100
        i0App.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i0App.cellAppearance = FlexStyleCollectionCellAppearance()
        i0App.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        i0App.cellAppearance.textInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        item0.cellAppearance = i0App
        self.demoCollectionView.addItem(secRef, item: item0)
        
        // Simple Image,Text,Accessory Item
        let ti1 = UIImage(named: "DemoImage2")
        let ti2 = UIImage(named: "ThumbIcon3")
        let item1 = FlexBaseCollectionItem(reference: "item1ref", text: NSAttributedString(string: "Text"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 1")) {
            NSLog("did press accessory image")
        }
        item1.imageViewActionHandler = {
            NSLog("image view pressed")
        }
        let i1App = FlexStyleAppearance()
        i1App.styleColor = UIColor.MKColor.Brown.P100
        i1App.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i1App.cellAppearance = cellAppearance
        item1.cellAppearance = i1App
        self.demoCollectionView.addItem(secRef, item: item1)
        
        // Color item
        let colItem = FlexColorCollectionItem(reference: "colorItem", color: UIColor.MKColor.Orange.P200 , text: NSAttributedString(string: "Color"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 2")) {
            NSLog("did press color view")
        }
        let scApp = FlexStyleAppearance()
        scApp.styleColor = UIColor.MKColor.Brown.P100
        scApp.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        scApp.cellAppearance = cellAppearance
        colItem.cellAppearance = scApp
        self.demoCollectionView.addItem(secRef, item: colItem)
        
        // Switch value
        let switchItem = FlexSwitchCollectionItem(reference: "switch", value: true, text: NSAttributedString(string: "Switch"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 3")) { (value) in
            NSLog("The switch is now \(value)")
        }
        let siApp = FlexStyleAppearance()
        siApp.styleColor = UIColor.MKColor.Brown.P100
        siApp.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        siApp.cellAppearance = FlexStyleCollectionCellAppearance()
        siApp.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        siApp.cellAppearance.controlSize = CGSizeMake(48,32)
        siApp.switchOnColor = UIColor.MKColor.Brown.P200
        siApp.switchThumbColor = UIColor.MKColor.Brown.P700
        switchItem.cellAppearance = siApp
        self.demoCollectionView.addItem(secRef, item: switchItem)
        
        // Slider value
        let sliderItem = FlexSliderCollectionItem(reference: "slider", value: 0, text: NSAttributedString(string: "Slider"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 4")) { (value) in
            NSLog("The slider is now \(value)")
        }
        let slApp = FlexStyleAppearance()
        slApp.styleColor = UIColor.MKColor.Brown.P100
        slApp.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        slApp.cellAppearance = FlexStyleCollectionCellAppearance()
        slApp.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        slApp.cellAppearance.controlInsets = UIEdgeInsetsMake(0, 0, 5, 8)
        slApp.sliderThumbColor = UIColor.MKColor.Brown.P700
        slApp.sliderMinimumTrackColor = UIColor.MKColor.Brown.P200
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
