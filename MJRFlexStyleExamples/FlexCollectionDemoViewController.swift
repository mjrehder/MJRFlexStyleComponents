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
        self.automaticallyAdjustsScrollViewInsets = false

        self.demoCollectionView.flexCollectionDelegate = self
        self.demoCollectionView.defaultCellSize = CGSizeMake(250, 64)
        self.demoCollectionView.headerText = "Collection Demo"
        
        // Setup demo style
        let collectionDemoStyle = FlexCollectionViewAppearance()
        collectionDemoStyle.viewAppearance.styleColor = UIColor.MKColor.Brown.P50
        collectionDemoStyle.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        collectionDemoStyle.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        self.demoCollectionView.collectionViewAppearance = collectionDemoStyle
        
        let secRef = self.demoCollectionView.addSection()

        let cellAppearance = FlexStyleCollectionCellAppearance()
        cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        cellAppearance.controlSize = CGSizeMake(32,32)
        cellAppearance.controlBorderWidth = 1.0
        cellAppearance.controlBorderColor = UIColor.MKColor.Brown.P500
        
        // Simple Text
        let item0 = FlexBaseCollectionItem(reference: "item0ref", text: NSAttributedString(string: "Simple Text"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 0"))
        let i0App = FlexStyleCollectionCellAppearance()
        i0App.styleColor = UIColor.MKColor.Brown.P100
        i0App.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i0App.controlStyleColor = UIColor.MKColor.Brown.P100
        i0App.textAppearance.insets = UIEdgeInsetsMake(0, 8, 0, 8)
        i0App.textAppearance.style = .Box
        item0.cellAppearance = i0App
        self.demoCollectionView.addItem(secRef, item: item0)
        
        // Simple Image,Text,Accessory Item. Accessory will only show on selection. Selection is triggered also for pressing icon and accessory image in this cell.
        let ti1 = UIImage(named: "DemoImage2")
        let ti2 = UIImage(named: "ThumbIcon3")
        let item1 = FlexBaseCollectionItem(reference: "item1ref", text: NSAttributedString(string: "Text"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 1")) {
            NSLog("did press accessory image")
        }
        item1.imageViewActionHandler = {
            NSLog("image view pressed")
        }
        item1.showAccessoryImageOnlyWhenSelected = true
        item1.contentInteractionWillSelectItem = true
        let i1App = FlexStyleCollectionCellAppearance()
        i1App.styleColor = UIColor.MKColor.Brown.P100
        i1App.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        item1.cellAppearance = i1App
        self.demoCollectionView.addItem(secRef, item: item1)

        // Text View Collection Item
        let item2 = FlexTextViewCollectionItem(reference: "item2ref", text: NSAttributedString(string: "This is a longer text in order to test the TextView"), title: NSAttributedString(string: "Item 1.1"))
        item2.canMoveItem = false
        let i2App = FlexStyleCollectionCellAppearance()
        i2App.styleColor = UIColor.MKColor.Brown.P100
        i2App.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i2App.viewAppearance.headerPosition = .Left
        i2App.viewAppearance.headerAppearance.textFont = UIFont.systemFontOfSize(10)
        i2App.viewAppearance.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        i2App.viewAppearance.styleColor = .clearColor()
        item2.cellAppearance = i2App
        self.demoCollectionView.addItem(secRef, item: item2)
        
        // Color item
        let colItem = FlexColorCollectionItem(reference: "colorItem", color: UIColor.MKColor.Orange.P200 , text: NSAttributedString(string: "Color"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 2")) {
            NSLog("did press color view")
        }
        let scApp = FlexStyleCollectionCellAppearance()
        scApp.styleColor = UIColor.MKColor.Brown.P100
        scApp.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        colItem.cellAppearance = scApp
        self.demoCollectionView.addItem(secRef, item: colItem)
        
        // Switch value
        let switchItem = FlexSwitchCollectionItem(reference: "switch", value: true, text: NSAttributedString(string: "Switch"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 3")) { (value) in
            NSLog("The switch is now \(value)")
        }
        let siApp = FlexStyleCollectionCellAppearance()
        siApp.styleColor = UIColor.MKColor.Brown.P100
        siApp.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        siApp.controlStyleColor = UIColor.MKColor.Brown.P100
        siApp.controlSize = CGSizeMake(48,32)
        siApp.switchAppearance.switchOnColor = UIColor.MKColor.Brown.P200
        siApp.switchAppearance.switchThumbColor = UIColor.MKColor.Brown.P700
        switchItem.cellAppearance = siApp
        self.demoCollectionView.addItem(secRef, item: switchItem)
        
        // Slider value
        let sliderItem = FlexSliderCollectionItem(reference: "slider", value: 0.6, text: NSAttributedString(string: "Slider"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 4")) { (value) in
            NSLog("The slider is now \(value)")
        }
        let slApp = FlexStyleCollectionCellAppearance()
        slApp.styleColor = UIColor.MKColor.Brown.P100
        slApp.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        slApp.controlStyleColor = UIColor.MKColor.Brown.P100
        slApp.controlInsets = UIEdgeInsetsMake(0, 0, 5, 8)
        slApp.sliderAppearance.sliderThumbColor = UIColor.MKColor.Brown.P700
        slApp.sliderAppearance.sliderMinimumTrackColor = UIColor.MKColor.Brown.P200
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
