//
//  ImageViewDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 28.08.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ImageViewDemoViewController: UIViewController, FlexMenuDataSource {

    @IBOutlet weak var flexView: FlexImageView!
    @IBOutlet weak var imageViewStyle: FlexMenu!
    @IBOutlet weak var flexViewOrientation: FlexMenu!
    
    var menuItems: [FlexMenuItem] = []
    var imageStyleMenuItems: [FlexMenuItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.title = "Image View"
        
        let thumbColor = UIColor.MKColor.Orange.P500
        let separatorColor = UIColor.MKColor.Orange.P200
        
        let col1 = FlexMenuItem(title: "Top", titleShortcut: "T", color: separatorColor, thumbColor: thumbColor)
        let col2 = FlexMenuItem(title: "Left", titleShortcut: "L", color: separatorColor, thumbColor: thumbColor)
        let col3 = FlexMenuItem(title: "Right", titleShortcut: "R", color: separatorColor, thumbColor: thumbColor)
        self.menuItems.append(col1)
        self.menuItems.append(col2)
        self.menuItems.append(col3)
        
        let vih1 = FlexMenuItem(title: "Box", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        let vih2 = FlexMenuItem(title: "Rounded", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        let vih3 = FlexMenuItem(title: "Thumb", titleShortcut: "", color:separatorColor, thumbColor: UIColor.clear)
        let vih4 = FlexMenuItem(title: "Tube", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clear)
        self.imageStyleMenuItems.append(vih1)
        self.imageStyleMenuItems.append(vih2)
        self.imageStyleMenuItems.append(vih3)
        self.imageStyleMenuItems.append(vih4)

        self.flexViewOrientation.menuDataSource = self
        self.flexViewOrientation.setSelectedItem(0)
        
        self.imageViewStyle.menuDataSource = self
        self.imageViewStyle.separatorFont = UIFont.systemFont(ofSize: 14)
        self.imageViewStyle.menuItemStyle = .rounded
        self.imageViewStyle.menuInterItemSpacing = 10.0
        self.imageViewStyle.menuStyle = .dynamicallySpaces(thumbPos: .top)
        
        
        // FlexView
        self.flexView.headerText = "Image"
        self.flexView.headerPosition = .top
        self.flexView.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10.0))
        self.flexView.styleColor = UIColor.MKColor.Teal.P500
        self.flexView.header.styleColor = UIColor.MKColor.Teal.P700
        self.flexView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 14)
        self.flexView.header.caption.labelTextColor = UIColor.white
        self.flexView.header.caption.labelTextAlignment = .center
        
        self.flexView.imageView.image = UIImage(named: "DemoImage")
        self.flexView.imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(_ menu: FlexMenu, index: Int) {
        if menu == self.flexViewOrientation {
            switch index {
            case 0:
                self.flexView.headerPosition = .top
            case 1:
                self.flexView.headerPosition = .left
            default:
                self.flexView.headerPosition = .right
            }
        }
        else if menu == self.imageViewStyle {
            switch index {
            case 0:
                self.flexView.style = FlexShapeStyle(style: .box)
            case 1:
                self.flexView.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10.0))
            case 2:
                self.flexView.style = FlexShapeStyle(style: .thumb)
            default:
                self.flexView.style = FlexShapeStyle(style: .tube)
            }
        }
    }
    
    func menuItemForIndex(_ menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.flexViewOrientation {
            return self.menuItems[index]
        }
        else {
            return self.imageStyleMenuItems[index]
        }
    }
    
    func numberOfMenuItems(_ menu: FlexMenu) -> Int {
        if menu == self.flexViewOrientation {
            return self.menuItems.count
        }
        else {
            return self.imageStyleMenuItems.count
        }
    }
}
