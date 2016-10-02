//
//  ImageShapeDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 02/10/2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class ImageShapeDemoViewController: UIViewController, FlexMenuDataSource {

    @IBOutlet weak var imageShapeView: FlexImageShapeView!
    @IBOutlet weak var flexViewOrientation: FlexMenu!
    @IBOutlet weak var imageViewStyle: FlexMenu!
    
    var menuItems: [FlexMenuItem] = []
    var imageStyleMenuItems: [FlexMenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.title = "Image Shape View"
        
        let separatorColor = UIColor.MKColor.Orange.P200
        
        let col1 = FlexMenuItem(title: "Center", titleShortcut: "", color: separatorColor, thumbColor: .clearColor())
        let col2 = FlexMenuItem(title: "Scale To Fit", titleShortcut: "", color: separatorColor, thumbColor: .clearColor())
        let col3 = FlexMenuItem(title: "Scale To Fill", titleShortcut: "", color: separatorColor, thumbColor: .clearColor())
        self.menuItems.append(col1)
        self.menuItems.append(col2)
        self.menuItems.append(col3)
        
        let vih1 = FlexMenuItem(title: "Box", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        let vih2 = FlexMenuItem(title: "Rounded", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        let vih3 = FlexMenuItem(title: "Thumb", titleShortcut: "", color:separatorColor, thumbColor: UIColor.clearColor())
        let vih4 = FlexMenuItem(title: "Tube", titleShortcut: "", color: separatorColor, thumbColor: UIColor.clearColor())
        self.imageStyleMenuItems.append(vih1)
        self.imageStyleMenuItems.append(vih2)
        self.imageStyleMenuItems.append(vih3)
        self.imageStyleMenuItems.append(vih4)
        
        self.flexViewOrientation.menuDataSource = self
        self.flexViewOrientation.separatorFont = UIFont.systemFontOfSize(14)
        self.flexViewOrientation.menuItemStyle = .Rounded
        self.flexViewOrientation.menuInterItemSpacing = 10.0
        self.flexViewOrientation.menuStyle = .DynamicallySpaces(thumbPos: .Top)
        
        self.imageViewStyle.menuDataSource = self
        self.imageViewStyle.separatorFont = UIFont.systemFontOfSize(14)
        self.imageViewStyle.menuItemStyle = .Rounded
        self.imageViewStyle.menuInterItemSpacing = 10.0
        self.imageViewStyle.menuStyle = .DynamicallySpaces(thumbPos: .Top)
        
        // FlexView
        self.imageShapeView.headerText = "Image"
        self.imageShapeView.headerPosition = .Top
        self.imageShapeView.style = .RoundedFixed(cornerRadius: 10.0)
        self.imageShapeView.styleColor = UIColor.MKColor.Teal.P500
        self.imageShapeView.header.labelBackgroundColor = UIColor.MKColor.Teal.P700
        self.imageShapeView.header.labelFont = UIFont.boldSystemFontOfSize(14)
        self.imageShapeView.header.labelTextColor = UIColor.whiteColor()
        
        self.imageShapeView.image = UIImage(named: "DemoImage")
        self.imageShapeView.imageStyle = .RoundedFixed(cornerRadius: 10.0)
        self.imageShapeView.backgroundImageFit = .ScaleToFit
        self.imageShapeView.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
        if menu == self.flexViewOrientation {
            switch index {
            case 0:
                self.imageShapeView.backgroundImageFit = .Center
            case 1:
                self.imageShapeView.backgroundImageFit = .ScaleToFit
            default:
                self.imageShapeView.backgroundImageFit = .ScaleToFill
            }
        }
        else if menu == self.imageViewStyle {
            switch index {
            case 0:
                self.imageShapeView.imageStyle = .Box
            case 1:
                self.imageShapeView.imageStyle = .RoundedFixed(cornerRadius: 10.0)
            case 2:
                self.imageShapeView.imageStyle = .Thumb
            default:
                self.imageShapeView.imageStyle = .Tube
            }
        }
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
        if menu == self.flexViewOrientation {
            return self.menuItems[index]
        }
        else {
            return self.imageStyleMenuItems[index]
        }
    }
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        if menu == self.flexViewOrientation {
            return self.menuItems.count
        }
        else {
            return self.imageStyleMenuItems.count
        }
    }

}
