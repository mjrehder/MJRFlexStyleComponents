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

        // The style for the collection view
        self.demoCollectionView.header.styleColor = UIColor.MKColor.Brown.P500
        self.demoCollectionView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 12)
        self.demoCollectionView.header.caption.labelTextAlignment = .center
        self.demoCollectionView.header.caption.labelTextColor = .white
        self.demoCollectionView.styleColor = UIColor.MKColor.Brown.P50
        self.demoCollectionView.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))

        /*
        Discussion:
         Using the UIAppearance for setting the style of the collection view elements.
         One can also use overrides of the collection view function, such as cellForItemAtIndexPath or by subclassing the cells and supplementary views
         */

        // Create sections with a title. Remember to set the height and if needed also the insets, as these parameters are otherwise 0 and .zero
        let secRef = self.demoCollectionView.addSection(NSAttributedString(string: "Section 1"), height: 18, insets: UIEdgeInsetsMake(2, 2, 2, 2))
        let sec2Ref = self.demoCollectionView.addSection(NSAttributedString(string: "Section 2"), height: 18, insets: UIEdgeInsetsMake(2, 2, 2, 2))

        // Set overall apperance for the section headers
        let headerAppearance = FlexLabel.appearance(whenContainedInInstancesOf: [SimpleHeaderCollectionReusableView.self])
        headerAppearance.styleColor = UIColor.MKColor.Brown.P300
        headerAppearance.style = FlexShapeStyle(style: .box)
        headerAppearance.labelFont = UIFont.systemFont(ofSize: 10)
        headerAppearance.labelTextColor = .white
        headerAppearance.labelTextAlignment = .center
        
        // Set the overall cell appearance
        let cellAppearance = FlexCollectionViewCell.appearance()
        cellAppearance.styleColor = UIColor.MKColor.Brown.P100

        // Set the appearance of complex cells, such as image, color, text area cells
        let cellViewAppearance = FlexCellView.appearance()
        cellViewAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))
        
        let cellBaseAppearance = FlexBaseCollectionViewCell.appearance()
        cellBaseAppearance.imageViewSize = CGSize(width: 48,height: 32)
        cellBaseAppearance.imageViewStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))
        cellBaseAppearance.accessoryViewSize = CGSize(width: 18,height: 18)

        // Set the supplementary (header) of cells style
        let cellHeaderViewAppearance = FlexViewSupplementaryView.appearance(whenContainedInInstancesOf: [FlexCollectionViewCell.self])
        cellHeaderViewAppearance.styleColor = UIColor.MKColor.Brown.P500

        // Set the cells header title style
        let cellHeaderAppearance = FlexLabel.appearance(whenContainedInInstancesOf: [FlexViewSupplementaryView.self, FlexCellView.self])
        cellHeaderAppearance.labelFont = UIFont.boldSystemFont(ofSize: 10)
        cellHeaderAppearance.labelTextAlignment = .center
        cellHeaderAppearance.labelTextColor = .white
        
        // This is the overall text in cell appearance
        let textLabelAppearance = FlexBaseCollectionViewCellTextLabel.appearance()
        textLabelAppearance.labelFont = UIFont.systemFont(ofSize: 12)
        textLabelAppearance.labelTextAlignment = .left
        textLabelAppearance.labelTextColor = .black

        
        // Quad Text
        let detailTextLabelAppearance = FlexBaseCollectionViewCellDetailTextLabel.appearance()
        detailTextLabelAppearance.labelFont = UIFont.systemFont(ofSize: 10)
        detailTextLabelAppearance.labelTextAlignment = .left
        detailTextLabelAppearance.labelTextColor = .black
        
        let infoTextLabelAppearance = FlexBaseCollectionViewCellInfoTextLabel.appearance()
        infoTextLabelAppearance.labelFont = UIFont.systemFont(ofSize: 10)
        infoTextLabelAppearance.labelTextAlignment = .right
        infoTextLabelAppearance.labelTextColor = .black
        
        let auxTextLabelAppearance = FlexBaseCollectionViewCellAuxTextLabel.appearance()
        auxTextLabelAppearance.labelFont = UIFont.systemFont(ofSize: 8)
        auxTextLabelAppearance.labelTextAlignment = .right
        auxTextLabelAppearance.labelTextColor = .black

        let item0 = FlexBaseCollectionItem(reference: "item0ref", text: NSAttributedString(string: "Text String"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 0"))
        item0.infoText = NSAttributedString(string: "Info")
        item0.detailText = NSAttributedString(string: "Detail Text")
        item0.auxText = NSAttributedString(string: "Aux Info")
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
        self.demoCollectionView.addItem(secRef, item: item1)

        
        // Text View Collection Item
        let item2 = FlexTextViewCollectionItem(reference: "item2ref", text: NSAttributedString(string: "This is a longer text in order to test the TextView"), title: NSAttributedString(string: "Item 1.1"))
        item2.canMoveItem = false
        item2.headerPosition = .left
        self.demoCollectionView.addItem(secRef, item: item2)
        
        
        // Color item
        let flexColorCellAppearance = FlexColorCollectionViewCell.appearance()
        flexColorCellAppearance.controlBorderColor = .black
        flexColorCellAppearance.controlBorderWidth = 0.5
        flexColorCellAppearance.controlStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))
        
        let colItem = FlexColorCollectionItem(reference: "colorItem", color: UIColor.MKColor.Orange.P200, text: NSAttributedString(string: "Color"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 2")) {
            NSLog("did press color view")
        }
        colItem.controlSize = CGSize(width: 32, height: 32)
        self.demoCollectionView.addItem(secRef, item: colItem)

        
        // Switch value
        let flexSwitchAppearance = FlexSwitch.appearance(whenContainedInInstancesOf: [FlexSwitchCollectionViewCell.self])
        flexSwitchAppearance.thumbTintColor = UIColor.MKColor.Brown.P700
        flexSwitchAppearance.onTintColor = UIColor.MKColor.Brown.P200

        let switchItem = FlexSwitchCollectionItem(reference: "switch", value: true, text: NSAttributedString(string: "Switch"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 3")) { (value) in
            NSLog("The switch is now \(value)")
        }
        switchItem.controlSize = CGSize(width: 32,height: 22)
        self.demoCollectionView.addItem(secRef, item: switchItem)
        
        
        // Slider value
        let flexSliderAppearance = FlexSlider.appearance(whenContainedInInstancesOf: [FlexSliderCollectionViewCell.self])
        flexSliderAppearance.thumbTintColor = UIColor.MKColor.Brown.P700
        flexSliderAppearance.minimumTrackTintColor = UIColor.MKColor.Brown.P200

        let sliderItem = FlexSliderCollectionItem(reference: "slider", value: 0.6, text: NSAttributedString(string: "Slider"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 4")) { (value) in
            NSLog("The slider is now \(value)")
        }
        sliderItem.controlInsets = UIEdgeInsetsMake(0, 0, 8, 8)
        self.demoCollectionView.addItem(secRef, item: sliderItem)

        
        // Image view
        let imageCellHeaderAppearance = FlexLabel.appearance(whenContainedInInstancesOf: [FlexViewSupplementaryView.self, FlexImageCollectionViewCell.self])
        imageCellHeaderAppearance.labelFont = UIFont.boldSystemFont(ofSize: 8)
        imageCellHeaderAppearance.labelTextAlignment = .center
        imageCellHeaderAppearance.labelTextColor = .white

        let imageCellViewAppearance = FlexImageShapeView.appearance()
        imageCellViewAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))

        let imageItem = FlexImageCollectionItem(reference: "image", image: UIImage(named: "DemoImage"), title: NSAttributedString(string: "Item 5"))
        imageItem.controlInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        self.demoCollectionView.addItem(sec2Ref, item: imageItem)
        

        // Double Text
        let item6 = FlexBaseCollectionItem(reference: "item6ref", text: NSAttributedString(string: "Text String"), icon: nil, accessoryImage: nil, title: NSAttributedString(string: "Item 6"))
        item6.infoText = NSAttributedString(string: "Info Text")

        let lsi = FlexLabel(frame: CGRect.zero)
        lsi.label.text = "Menu"
        lsi.style = FlexShapeStyle(style: .rounded)
        lsi.styleColor = UIColor.MKColor.Brown.P700
        lsi.labelTextColor = .white
        lsi.labelTextAlignment = .center
        let lsi2 = FlexLabel(frame: CGRect.zero)
        lsi2.label.text = "Delete"
        lsi2.style = FlexShapeStyle(style: .rounded)
        lsi2.styleColor = UIColor.MKColor.Brown.P200
        lsi2.labelTextColor = .white
        lsi2.labelTextAlignment = .center
        item6.swipeLeftMenuItems = [lsi, lsi2]
        
        let lsi3 = FlexLabel(frame: CGRect.zero)
        lsi3.label.text = "Options"
        lsi3.style = FlexShapeStyle(style: .rounded)
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
