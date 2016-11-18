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
        
        let col1 = FlexMenuItem(title: "Center", titleShortcut: "", color: separatorColor, thumbColor: .clear)
        let col2 = FlexMenuItem(title: "Scale To Fit", titleShortcut: "", color: separatorColor, thumbColor: .clear)
        let col3 = FlexMenuItem(title: "Scale To Fill", titleShortcut: "", color: separatorColor, thumbColor: .clear)
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
        self.flexViewOrientation.separatorFont = UIFont.systemFont(ofSize: 14)
        self.flexViewOrientation.menuItemStyle = .rounded
        self.flexViewOrientation.menuInterItemSpacing = 10.0
        self.flexViewOrientation.menuStyle = .dynamicallySpaces(thumbPos: .top)
        
        self.imageViewStyle.menuDataSource = self
        self.imageViewStyle.separatorFont = UIFont.systemFont(ofSize: 14)
        self.imageViewStyle.menuItemStyle = .rounded
        self.imageViewStyle.menuInterItemSpacing = 10.0
        self.imageViewStyle.menuStyle = .dynamicallySpaces(thumbPos: .top)
        
        // FlexView
        self.imageShapeView.headerText = "Image"
        self.imageShapeView.headerPosition = .top
        self.imageShapeView.style = .roundedFixed(cornerRadius: 10.0)
        self.imageShapeView.styleColor = UIColor.MKColor.Teal.P500
        self.imageShapeView.header.labelBackgroundColor = UIColor.MKColor.Teal.P700
        self.imageShapeView.header.labelFont = UIFont.boldSystemFont(ofSize: 14)
        self.imageShapeView.header.labelTextColor = UIColor.white
        
        self.imageShapeView.image = UIImage(named: "DemoImage")
        self.imageShapeView.imageStyle = .roundedFixed(cornerRadius: 10.0)
        self.imageShapeView.backgroundImageFit = .scaleToFit
        self.imageShapeView.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    // MARK: - FlexMenuDataSource
    
    func menuItemSelected(_ menu: FlexMenu, index: Int) {
        if menu == self.flexViewOrientation {
            switch index {
            case 0:
                self.imageShapeView.backgroundImageFit = .center
            case 1:
                self.imageShapeView.backgroundImageFit = .scaleToFit
            default:
                self.imageShapeView.backgroundImageFit = .scaleToFill
            }
        }
        else if menu == self.imageViewStyle {
            switch index {
            case 0:
                self.imageShapeView.imageStyle = .box
            case 1:
                self.imageShapeView.imageStyle = .roundedFixed(cornerRadius: 10.0)
            case 2:
                self.imageShapeView.imageStyle = .thumb
            default:
                self.imageShapeView.imageStyle = .tube
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
