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
        let colItem = FlexColorCollectionViewItem(reference: "colorItem", color: .yellowColor(), text: NSAttributedString(string: "Color"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 2")) { 
            NSLog("did press color view")
        }
        self.demoCollectionView.addItem(secRef, item: colItem)
    }
    
    // MARK: - FlexCollectionViewDelegate
    
    func onFlexCollectionItemMoved(view: FlexCollectionView, item: FlexCollectionItem) {
    }
    
    func onFlexCollectionItemSelected(view: FlexCollectionView, item: FlexCollectionItem) {
        NSLog("Item \(item.reference) selected")
    }
}
