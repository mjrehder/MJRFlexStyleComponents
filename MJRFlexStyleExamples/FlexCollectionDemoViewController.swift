//
//  FlexCollectionDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 06.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class FlexCollectionDemoViewController: UIViewController, FlexCollectionViewDelegate, FlexCollectionItemSwipeDelegate {
    
    @IBOutlet weak var demoCollectionView: FlexCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false

        self.demoCollectionView.flexCollectionDelegate = self
        self.demoCollectionView.defaultCellSize = CGSize(width: 250, height: 64)
        self.demoCollectionView.headerText = "Collection Demo"
        
        // Setup demo style
        let collectionDemoStyle = FlexCollectionViewAppearance()
        collectionDemoStyle.viewAppearance.styleColor = UIColor.MKColor.Brown.P50
        collectionDemoStyle.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        collectionDemoStyle.cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        collectionDemoStyle.sectionHeaderAppearance.styleColor = UIColor.MKColor.Brown.P300
        collectionDemoStyle.sectionHeaderAppearance.insets = UIEdgeInsetsMake(2, 2, 2, 2)
        collectionDemoStyle.sectionHeaderAppearance.style = .roundedFixed(cornerRadius: 5)
        collectionDemoStyle.sectionHeaderAppearance.textFont = UIFont.systemFont(ofSize: 10)
        self.demoCollectionView.collectionViewAppearance = collectionDemoStyle
        
        let secRef = self.demoCollectionView.addSection(NSAttributedString(string: "Section 1"))
        let sec2Ref = self.demoCollectionView.addSection(NSAttributedString(string: "Section 2"))

        let cellAppearance = FlexStyleCollectionCellAppearance()
        cellAppearance.controlStyleColor = UIColor.MKColor.Brown.P100
        cellAppearance.controlSize = CGSize(width: 32,height: 32)
        cellAppearance.controlBorderWidth = 1.0
        cellAppearance.controlBorderColor = UIColor.MKColor.Brown.P500
        
        // Quad Text
        let item0 = FlexBaseCollectionItem(reference: "item0ref", text: NSAttributedString(string: "Text String"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 0"))
        item0.infoText = NSAttributedString(string: "Info")
        item0.detailText = NSAttributedString(string: "Detail Text")
        item0.auxText = NSAttributedString(string: "Aux Info")
        let i0App = FlexStyleCollectionCellAppearance()
        i0App.controlInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        i0App.styleColor = UIColor.MKColor.Brown.P100
        i0App.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i0App.controlStyleColor = UIColor.MKColor.Brown.P100
        i0App.textAppearance.style = .box
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
        i2App.viewAppearance.headerPosition = .left
        i2App.viewAppearance.headerAppearance.textFont = UIFont.systemFont(ofSize: 10)
        i2App.viewAppearance.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        i2App.viewAppearance.styleColor = .clear
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
        siApp.controlSize = CGSize(width: 48,height: 32)
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

        // Image view
        let imageItem = FlexImageCollectionItem(reference: "image", image: UIImage(named: "DemoImage"), title: NSAttributedString(string: "Item 5"))
        let iApp = FlexStyleCollectionCellAppearance()
        iApp.styleColor = UIColor.MKColor.Brown.P100
        iApp.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        iApp.controlInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        imageItem.cellAppearance = iApp
        self.demoCollectionView.addItem(sec2Ref, item: imageItem)
        
        // Double Text
        let item6 = FlexBaseCollectionItem(reference: "item6ref", text: NSAttributedString(string: "Text String"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 6"))
        item6.infoText = NSAttributedString(string: "Info Text")
        let i6App = FlexStyleCollectionCellAppearance()
        i6App.controlInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        i6App.styleColor = UIColor.MKColor.Brown.P100
        i6App.viewAppearance.headerAppearance.backgroundColor = UIColor.MKColor.Brown.P500
        i6App.controlStyleColor = UIColor.MKColor.Brown.P100
        i6App.textAppearance.style = .box
        item6.cellAppearance = i6App
        
        let lsi = FlexLabel(frame: CGRect.zero)
        lsi.label.text = "Menu"
        lsi.style = .rounded
        lsi.styleColor = UIColor.MKColor.Brown.P700
        lsi.labelTextColor = .white
        lsi.labelTextAlignment = .center
        let lsi2 = FlexLabel(frame: CGRect.zero)
        lsi2.label.text = "Delete"
        lsi2.style = .rounded
        lsi2.styleColor = UIColor.MKColor.Brown.P200
        lsi2.labelTextColor = .white
        lsi2.labelTextAlignment = .center
        item6.swipeLeftMenuItems = [lsi, lsi2]
        
        let lsi3 = FlexLabel(frame: CGRect.zero)
        lsi3.label.text = "Options"
        lsi3.style = .rounded
        lsi3.styleColor = UIColor.MKColor.Brown.P500
        lsi3.labelTextColor = .white
        lsi3.labelTextAlignment = .center
        item6.swipeRightMenuItems = [lsi3]

        item6.swipeMenuDelegate = self
        
        self.demoCollectionView.addItem(sec2Ref, item: item6)

    }
    
    // MARK: - FlexCollectionItemSwipeDelegate
    
    func swipeMenuSelected(_ item: FlexCollectionItem, menuItem: FlexLabel) {
        NSLog("swipe menu item selected with text \(menuItem.label.text)")
    }
    
    // MARK: - FlexCollectionViewDelegate
    
    func onFlexCollectionItemMoved(_ view: FlexCollectionView, item: FlexCollectionItem) {
    }
    
    func onFlexCollectionItemSelected(_ view: FlexCollectionView, item: FlexCollectionItem) {
        NSLog("Item \(item.reference) selected")
    }
}
