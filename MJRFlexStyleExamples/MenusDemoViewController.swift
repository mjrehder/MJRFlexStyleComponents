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
    @IBOutlet weak var verticalDynSpacedMenu: FlexMenu!
    
    @IBOutlet weak var flexView: FlexView!
    
    var flexViewMenu: FlexViewMenu?
    
    var menuItems: [FlexMenuItem] = []
    var spacedMenuItems: [FlexMenuItem] = []
    var viewMenuHPosMenuItems: [FlexMenuItem] = []
    var viewMenuVPosMenuItems: [FlexMenuItem] = []
    var viewMenuItems: [FlexMenuItem] = []
    var viewMenu: FlexMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    func setupView() {
        self.title = "Flex Menus"
        
        let thumbColor = UIColor.MKColor.Orange.P500
        let separatorColor = UIColor.MKColor.Orange.P200
        
        let col1 = FlexMenuItem(title: "Top", titleShortcut: "T", color: separatorColor, thumbColor: thumbColor)
        let col2 = FlexMenuItem(title: "Left", titleShortcut: "L", color: separatorColor, thumbColor: thumbColor)
        let col3 = FlexMenuItem(title: "Right", titleShortcut: "R", color: separatorColor, thumbColor: thumbColor)
        self.menuItems.append(col1)
        self.menuItems.append(col2)
        self.menuItems.append(col3)

        let ti1 = UIImage(named: "ThumbIcon1")
        let ti2 = UIImage(named: "ThumbIcon2")
        let ti3 = UIImage(named: "ThumbIcon3")
        let scol1 = FlexMenuItem(title: "First", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clearColor(), thumbIcon: ti1)
        let scol2 = FlexMenuItem(title: "Second Larger", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clearColor(), thumbIcon: ti2)
        let scol3 = FlexMenuItem(title: "Third Med", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clearColor(), thumbIcon: ti3)
        self.spacedMenuItems.append(scol1)
        self.spacedMenuItems.append(scol2)
        self.spacedMenuItems.append(scol3)

        let ci = UIImage(named: "CenterIcon")
        let fi = UIImage(named: "FillIcon")
        let li = UIImage(named: "LeftIcon")
        let ri = UIImage(named: "RightIcon")
        let vih1 = FlexMenuItem(title: "Center", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: ci)
        let vih2 = FlexMenuItem(title: "Fill", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: fi)
        let vih3 = FlexMenuItem(title: "Left", titleShortcut: "", color:separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: li)
        let vih4 = FlexMenuItem(title: "Right", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: ri)
        self.viewMenuHPosMenuItems.append(vih1)
        self.viewMenuHPosMenuItems.append(vih2)
        self.viewMenuHPosMenuItems.append(vih3)
        self.viewMenuHPosMenuItems.append(vih4)
        
        let viv1 = FlexMenuItem(title: "Header", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        let viv2 = FlexMenuItem(title: "Top", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        let viv3 = FlexMenuItem(title: "Bottom", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        let viv4 = FlexMenuItem(title: "Footer", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        self.viewMenuVPosMenuItems.append(viv1)
        self.viewMenuVPosMenuItems.append(viv2)
        self.viewMenuVPosMenuItems.append(viv3)
        self.viewMenuVPosMenuItems.append(viv4)

        self.compactMenu.menuDataSource = self
        self.compactMenu.setSelectedItem(0)
        
        self.eqSpacedMenu.menuDataSource = self
        self.eqSpacedMenu.thumbSize = ci?.size
        self.eqSpacedMenu.separatorFont = UIFont.systemFontOfSize(12)
        self.eqSpacedMenu.menuItemStyle = .Rounded
        self.eqSpacedMenu.menuInterItemSpacing = 10.0

        self.dynSpacedMenu.menuDataSource = self
        self.dynSpacedMenu.thumbSize = ti1?.size
        self.dynSpacedMenu.menuItemStyle = .Rounded
        self.dynSpacedMenu.menuInterItemSpacing = 10.0

        self.verticalDynSpacedMenu.menuDataSource = self
        self.verticalDynSpacedMenu.thumbSize = ti1?.size
        self.verticalDynSpacedMenu.menuItemStyle = .Rounded
        self.verticalDynSpacedMenu.menuInterItemSpacing = 10.0
        self.verticalDynSpacedMenu.direction = .Vertical
        self.verticalDynSpacedMenu.separatorFont = UIFont.systemFontOfSize(12)

        self.eqSpacedMenu.menuStyle = .EquallySpaces(thumbPos: .Top)
        self.dynSpacedMenu.menuStyle = .DynamicallySpaces(thumbPos: .Bottom)
        self.verticalDynSpacedMenu.menuStyle = .DynamicallySpaces(thumbPos: .Top)
        self.verticalDynSpacedMenu.menuItemGravity = .Right
        
        // FlexView and FlexMenu Demo
        let vm1 = FlexMenuItem(title: "", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: ti1)
        let vm2 = FlexMenuItem(title: "", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor(), thumbIcon: ti2)
        self.viewMenuItems.append(vm1)
        self.viewMenuItems.append(vm2)
        self.viewMenu = FlexMenu(frame: CGRectMake(0,0,10,10))
        self.viewMenu?.menuDataSource = self
        self.viewMenu?.thumbSize = CGSizeMake(18, 18)
        self.viewMenu?.menuItemStyle = .Rounded
        self.viewMenu?.menuInterItemSpacing = 10.0
        self.viewMenu?.menuStyle = .EquallySpaces(thumbPos: .Top)
        self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSizeMake(100, 18), hPos: .Fill, vPos: .Footer)
        
        self.flexView.headerText = "Header"
        self.flexView.headerPosition = .Top
        self.flexView.style = .RoundedFixed(cornerRadius: 10.0)
        self.flexView.styleColor = UIColor.MKColor.Teal.P500
        self.flexView.headerBackgroundColor = UIColor.MKColor.Teal.P700
        self.flexView.headerFont = UIFont.boldSystemFontOfSize(14)
        self.flexView.headerTextColor = UIColor.whiteColor()
        
        self.flexView.addMenu(self.flexViewMenu!)
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
        if menu == self.compactMenu {
            switch index {
            case 0:
                self.flexView.headerPosition = .Top
            case 1:
                self.flexView.headerPosition = .Left
            default:
                self.flexView.headerPosition = .Right
            }
        }
        else if menu == self.eqSpacedMenu {
            if let fvm = self.flexViewMenu {
                self.flexView.removeMenu(fvm)
                let hPos: FlexViewMenuHorizontalPosition
                switch index {
                case 0:
                    hPos = .Center
                case 1:
                    hPos = .Fill
                case 2:
                    hPos = .Left
                default:
                    hPos = .Right
                }
                self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSizeMake(100, 18), hPos: hPos, vPos: fvm.vPos)
                self.flexView.addMenu(self.flexViewMenu!)
            }
        }
        else if menu == self.dynSpacedMenu {
            if let fvm = self.flexViewMenu {
                self.flexView.removeMenu(fvm)
                let vPos: FlexViewMenuVerticalPosition
                switch index {
                case 0:
                    vPos = .Header
                case 1:
                    vPos = .Top
                case 2:
                    vPos = .Bottom
                default:
                    vPos = .Footer
                }
                self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSizeMake(100, 18), hPos: fvm.hPos, vPos: vPos)
                self.flexView.addMenu(self.flexViewMenu!)
            }
        }
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.viewMenu {
            return self.viewMenuItems[index]
        }
        else if menu == self.compactMenu {
            return self.menuItems[index]
        }
        else if menu == self.eqSpacedMenu {
            return self.viewMenuHPosMenuItems[index]
        }
        else if menu == self.dynSpacedMenu {
            return self.viewMenuVPosMenuItems[index]
        }
        else {
            return self.spacedMenuItems[index]
        }
    }
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        if menu == self.viewMenu {
            return self.viewMenuItems.count
        }
        else if menu == self.compactMenu {
            return self.menuItems.count
        }
        else if menu == self.eqSpacedMenu {
            return self.viewMenuHPosMenuItems.count
        }
        else if menu == self.dynSpacedMenu {
            return self.viewMenuVPosMenuItems.count
        }
        else {
            return self.spacedMenuItems.count
        }
    }
}
