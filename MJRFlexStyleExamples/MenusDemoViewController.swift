//
//  MenusDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 20.08.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class MenusDemoViewController: UIViewController, FlexMenuDataSource {
    @IBOutlet weak var compactMenu: FlexMenu!
    @IBOutlet weak var eqSpacedMenu: FlexMenu!
    @IBOutlet weak var dynSpacedMenu: FlexMenu!

    var menuItems: [FlexMenuItem] = []
    var spacedMenuItems: [FlexMenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    func setupView() {
        let col1 = FlexMenuItem(title: "First", titleShortcut: "F", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col2 = FlexMenuItem(title: "Second Larger", titleShortcut: "S", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col3 = FlexMenuItem(title: "Third Mid", titleShortcut: "T", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        self.menuItems.append(col1)
        self.menuItems.append(col2)
        self.menuItems.append(col3)

        let ti1 = UIImage(named: "ThumbIcon1")
        let ti2 = UIImage(named: "ThumbIcon2")
        let ti3 = UIImage(named: "ThumbIcon3")
        let scol1 = FlexMenuItem(title: "First", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500, thumbIcon: ti1)
        let scol2 = FlexMenuItem(title: "Second Larger", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500, thumbIcon: ti2)
        let scol3 = FlexMenuItem(title: "Third Mid", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500, thumbIcon: ti3)
        self.spacedMenuItems.append(scol1)
        self.spacedMenuItems.append(scol2)
        self.spacedMenuItems.append(scol3)

        self.compactMenu.menuDataSource = self
        
        self.eqSpacedMenu.menuDataSource = self
        self.eqSpacedMenu.thumbSize = ti1?.size

        self.dynSpacedMenu.menuDataSource = self
        self.dynSpacedMenu.thumbSize = ti1?.size
        
        self.eqSpacedMenu.menuStyle = .EquallySpaces(thumbPos: .Top)
//        self.dynSpacedMenu.menuStyle = .DynamicallySpaces(thumbPos: .Bottom)
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.compactMenu {
            return self.menuItems[index]
        }
        else {
            return self.spacedMenuItems[index]
        }
    }
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        if menu == self.compactMenu {
            return self.menuItems.count
        }
        else {
            return self.spacedMenuItems.count
        }
    }
}
