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
        let ti1d = UIImage(named: "ThumbIcon1")?.tint(.gray)
        let ti2 = UIImage(named: "ThumbIcon2")
        let ti2d = UIImage(named: "ThumbIcon2")?.tint(.gray)
        let ti3 = UIImage(named: "ThumbIcon3")
        let ti3d = UIImage(named: "ThumbIcon3")?.tint(.gray)
        let ti3s = UIImage(named: "ThumbIcon3")?.tint(.green)
        let scol1 = FlexMenuItem(title: "First", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clear, thumbIcon: ti1, disabledThumbIcon: ti1d)
        let scol2 = FlexMenuItem(title: "Second Larger", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clear, thumbIcon: ti2, disabledThumbIcon: ti2d)
        let scol3 = FlexMenuItem(title: "Third Med", titleShortcut: "", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.clear, thumbIcon: ti3, disabledThumbIcon: ti3d, selectedThumbIcon: ti3s)
        var spacedMenuItems: [FlexMenuItem] = []
        spacedMenuItems.append(scol1)
        spacedMenuItems.append(scol2)
        spacedMenuItems.append(scol3)
        scol1.selectionHandler = {
            scol1.enabled = !scol1.enabled
        }
        scol2.selectionHandler = {
            scol2.enabled = !scol2.enabled
        }
        scol3.selectionHandler = {
            scol3.selected = !scol3.selected
        }

        let ci = UIImage(named: "CenterIcon")
        let fi = UIImage(named: "FillIcon")
        let li = UIImage(named: "LeftIcon")
        let ri = UIImage(named: "RightIcon")
        let vih1 = FlexMenuItem(title: "Center", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear, thumbIcon: ci)
        let vih2 = FlexMenuItem(title: "Fill", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear, thumbIcon: fi)
        let vih3 = FlexMenuItem(title: "Left", titleShortcut: "", color:separatorColor, thumbColor: UIColor.clear, thumbIcon: li)
        let vih4 = FlexMenuItem(title: "Right", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear, thumbIcon: ri)
        self.viewMenuHPosMenuItems.append(vih1)
        self.viewMenuHPosMenuItems.append(vih2)
        self.viewMenuHPosMenuItems.append(vih3)
        self.viewMenuHPosMenuItems.append(vih4)
        
        let viv1 = FlexMenuItem(title: "Header", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        let viv2 = FlexMenuItem(title: "Top", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        let viv3 = FlexMenuItem(title: "Bottom", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        let viv4 = FlexMenuItem(title: "Footer", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        self.viewMenuVPosMenuItems.append(viv1)
        self.viewMenuVPosMenuItems.append(viv2)
        self.viewMenuVPosMenuItems.append(viv3)
        self.viewMenuVPosMenuItems.append(viv4)

        self.compactMenu.menuDataSource = self
        self.compactMenu.setSelectedItem(0)
        
        self.eqSpacedMenu.menuDataSource = self
        self.eqSpacedMenu.thumbSize = ci?.size
        self.eqSpacedMenu.separatorFont = UIFont.systemFont(ofSize: 12)
        self.eqSpacedMenu.menuItemStyle = .rounded
        self.eqSpacedMenu.menuInterItemSpacing = 10.0

        self.dynSpacedMenu.menuDataSource = self
        self.dynSpacedMenu.thumbSize = ti1?.size
        self.dynSpacedMenu.menuItemStyle = .rounded
        self.dynSpacedMenu.menuInterItemSpacing = 10.0

        // The vertical DynSpacedMenu does not use the menu data source!
        self.verticalDynSpacedMenu.thumbSize = ti1?.size
        self.verticalDynSpacedMenu.menuItemStyle = .rounded
        self.verticalDynSpacedMenu.menuInterItemSpacing = 10.0
        self.verticalDynSpacedMenu.direction = .vertical
        self.verticalDynSpacedMenu.separatorFont = UIFont.systemFont(ofSize: 12)
        self.verticalDynSpacedMenu.menuItems = spacedMenuItems

        self.eqSpacedMenu.menuStyle = .equallySpaces(thumbPos: .top)
        self.dynSpacedMenu.menuStyle = .dynamicallySpaces(thumbPos: .bottom)
        self.verticalDynSpacedMenu.menuStyle = .dynamicallySpaces(thumbPos: .top)
        self.verticalDynSpacedMenu.menuItemGravity = .right
        
        // FlexView and FlexMenu Demo
        let vm1 = FlexMenuItem(title: "", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear, thumbIcon: ti1)
        let vm2 = FlexMenuItem(title: "", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear, thumbIcon: ti2)
        self.viewMenuItems.append(vm1)
        self.viewMenuItems.append(vm2)
        self.viewMenu = FlexMenu(frame: CGRect(x: 0,y: 0,width: 10,height: 10))
        self.viewMenu?.menuDataSource = self
        self.viewMenu?.thumbSize = CGSize(width: 18, height: 18)
        self.viewMenu?.menuItemStyle = .rounded
        self.viewMenu?.menuInterItemSpacing = 10.0
        self.viewMenu?.menuStyle = .equallySpaces(thumbPos: .top)
        self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSize(width: 100, height: 18), hPos: .fill, vPos: .footer)
        
        self.flexView.headerText = "Header"
        self.flexView.headerPosition = .top
        self.flexView.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10.0))
        self.flexView.styleColor = UIColor.MKColor.Teal.P500
        self.flexView.header.styleColor = UIColor.MKColor.Teal.P700
        self.flexView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 14)
        self.flexView.header.caption.labelTextColor = UIColor.white
        self.flexView.header.caption.labelTextAlignment = .center

        self.flexView.addMenu(self.flexViewMenu!)
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(_ menu: FlexMenu, index: Int) {
        if menu == self.compactMenu {
            switch index {
            case 0:
                self.flexView.headerPosition = .top
            case 1:
                self.flexView.headerPosition = .left
            default:
                self.flexView.headerPosition = .right
            }
        }
        else if menu == self.eqSpacedMenu {
            if let fvm = self.flexViewMenu {
                self.flexView.removeMenu(fvm)
                let hPos: FlexViewMenuHorizontalPosition
                switch index {
                case 0:
                    hPos = .center
                case 1:
                    hPos = .fill
                case 2:
                    hPos = .left
                default:
                    hPos = .right
                }
                self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSize(width: 100, height: 18), hPos: hPos, vPos: fvm.vPos)
                self.flexView.addMenu(self.flexViewMenu!)
            }
        }
        else if menu == self.dynSpacedMenu {
            if let fvm = self.flexViewMenu {
                self.flexView.removeMenu(fvm)
                let vPos: FlexViewMenuVerticalPosition
                switch index {
                case 0:
                    vPos = .header
                case 1:
                    vPos = .top
                case 2:
                    vPos = .bottom
                default:
                    vPos = .footer
                }
                self.flexViewMenu = FlexViewMenu(menu: self.viewMenu!, size: CGSize(width: 100, height: 18), hPos: fvm.hPos, vPos: vPos)
                self.flexView.addMenu(self.flexViewMenu!)
            }
        }
    }
    
    func menuItemForIndex(_ menu: FlexMenu, index: Int) -> FlexMenuItem {
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
        // dummy return
        return FlexMenuItem(title: "", titleShortcut: "", color: .clear, thumbColor: .clear)
    }
    
    func numberOfMenuItems(_ menu: FlexMenu) -> Int {
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
        return 0
    }
}
