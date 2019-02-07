//
//  FlexCollectionDemoViewController.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 06.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

class FlexCollectionDemoViewController: UIViewController, FlexCollectionViewDelegate, FlexCollectionItemSwipeDelegate, UITextFieldDelegate {
    
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
        self.demoCollectionView.subHeaderText = "Sub Header"

        // The style for the collection view
        self.demoCollectionView.headerSize = 30
        self.demoCollectionView.header.styleColor = UIColor.MKColor.Brown.P500
        self.demoCollectionView.header.caption.labelFont = UIFont.boldSystemFont(ofSize: 12)
        self.demoCollectionView.header.caption.labelTextAlignment = .center
        self.demoCollectionView.header.caption.labelTextColor = .white
        self.demoCollectionView.styleColor = UIColor.MKColor.Brown.P50
        self.demoCollectionView.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))
        self.demoCollectionView.header.subCaption.labelFont = UIFont.boldSystemFont(ofSize: 7)
        self.demoCollectionView.header.subCaption.labelTextAlignment = .center
        self.demoCollectionView.header.subCaption.labelTextColor = .white

        // Search Bar demo
        let sb = FlexViewSearchTopBar(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        sb.barStyleColor = UIColor.MKColor.Brown.P500
        sb.controlInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.demoCollectionView.topBar = sb
        self.demoCollectionView.topBarHeight = 36
        sb.filterContentForSearchText = { searchText in
            NSLog("Should search/filter for text: \(searchText)")
        }
        /*
        Discussion:
         Using the UIAppearance for setting the style of the collection view elements.
         One can also use overrides of the collection view function, such as cellForItemAtIndexPath or by subclassing the cells and supplementary views
         */

        let uiviewApp = UIImageView.appearance(whenContainedInInstancesOf: [FlexViewSupplementaryView.self])
        uiviewApp.contentScaleFactor = UIScreen().scale + 1.5
        uiviewApp.contentMode = .center
        uiviewApp.backgroundColor = UIColor.MKColor.Brown.P50

        // Create sections with a title. Remember to set the height and if needed also the insets, as these parameters are otherwise 0 and .zero
        let secRef = self.demoCollectionView.addSection(NSAttributedString(string: "Section 1"), height: 18, insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        let sec2Ref = self.demoCollectionView.addSection(NSAttributedString(string: "Section 2"), height: 18, insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))

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
        cellBaseAppearance.controlInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)

        // Set the supplementary (header) of cells style
        let cellHeaderViewAppearance = FlexViewSupplementaryView.appearance(whenContainedInInstancesOf: [FlexCollectionViewCell.self])
        cellHeaderViewAppearance.styleColor = UIColor.MKColor.Brown.P500

        // Set the cells header title style
        let cellHeaderAppearance = FlexPrimaryLabel.appearance(whenContainedInInstancesOf: [FlexHeaderView.self, FlexCellView.self])
        cellHeaderAppearance.labelFont = UIFont.boldSystemFont(ofSize: 10)
        cellHeaderAppearance.labelTextAlignment = .center
        cellHeaderAppearance.labelTextColor = .white
        
        // This is the overall text in cell appearance
        let textLabelAppearance = FlexBaseCollectionViewCellTextLabel.appearance()
        textLabelAppearance.labelFont = UIFont.systemFont(ofSize: 12)
        textLabelAppearance.labelTextAlignment = .left
        textLabelAppearance.labelTextColor = .black
        
        // Sub captions when used in collection cells
        let subCaptionApp = FlexSubPrimaryLabel.appearance()//whenContainedInInstancesOf: [FlexViewSupplementaryView.self, FlexCellView.self])
        subCaptionApp.labelFont = UIFont.systemFont(ofSize: 6)
        subCaptionApp.labelTextAlignment = .center
        subCaptionApp.labelTextColor = .white
        
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
        item2.textIsMutable = true
        item2.textTitle = NSAttributedString(string: "Text Title Very Long in order to test the auto cut-off and layout")
        item2.autodetectTextSizeFittingAndTruncateWithString = NSAttributedString(string: "...")
        item2.textViewInsets = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        self.demoCollectionView.addItem(secRef, item: item2)
        
        // Text Field Collection Item
        let item21 = FlexTextFieldCollectionItem(reference: "item21ref", text: NSAttributedString(string: "This is a text field cell"), title: NSAttributedString(string: "Item 2.1"))
        item21.canMoveItem = false
        item21.headerPosition = .left
        item21.textIsMutable = true
        item21.textFieldDelegate = self
        self.demoCollectionView.addItem(secRef, item: item21)
        
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
        flexSwitchAppearance.borderWidth = 0.5
        flexSwitchAppearance.borderColor = .black
        flexSwitchAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))
        flexSwitchAppearance.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))

        let switchItem = FlexSwitchCollectionItem(reference: "switch", value: true, text: NSAttributedString(string: "Switch"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 3")) { (value) in
            NSLog("The switch is now \(value)")
        }
        switchItem.controlSize = CGSize(width: 32,height: 22)
        self.demoCollectionView.addItem(secRef, item: switchItem)
        
        
        // Slider value
        let flexSliderAppearance = FlexSlider.appearance(whenContainedInInstancesOf: [FlexSliderCollectionViewCell.self])
        flexSliderAppearance.thumbTintColor = UIColor.MKColor.Brown.P700
        flexSliderAppearance.minimumTrackTintColor = UIColor.MKColor.Brown.P200
        flexSliderAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        flexSliderAppearance.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        flexSliderAppearance.borderWidth = 0.5
        flexSliderAppearance.borderColor = UIColor.MKColor.Brown.P500
        
        let sliderItem = FlexSliderCollectionItem(reference: "slider", value: 0.6, text: NSAttributedString(string: "Slider"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 4")) { (value) in
            NSLog("The slider is now \(value)")
        }
        sliderItem.controlInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 8)
        sliderItem.numberFormatString = nil
        sliderItem.thumbText = ""

        self.demoCollectionView.addItem(secRef, item: sliderItem)

        
        // Image view
        let imageCellViewAppearance = FlexImageShapeView.appearance()
        imageCellViewAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 5))

        let imageItem = FlexImageCollectionItem(reference: "image", image: UIImage(named: "DemoImage"), title: NSAttributedString(string: "Item 5"))
        imageItem.underTitle = NSAttributedString(string: "subtitle for demo image")
        imageItem.controlInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
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
        
        
        // Button cell
        let buttonCellLabelAppearance = FlexLabel.appearance(whenContainedInInstancesOf: [FlexButtonCollectionViewCell.self])
        buttonCellLabelAppearance.labelFont = UIFont.boldSystemFont(ofSize: 14)
        buttonCellLabelAppearance.labelTextAlignment = .center

        let item7 = FlexButtonCollectionItem(reference: "item7ref", text: NSAttributedString(string: "Press Me"))
        item7.itemSelectionActionHandler = {
            NSLog("Cell button pressed!")
        }
        item7.preferredCellSize = CGSize(width: 250, height: 30)
        self.demoCollectionView.addItem(sec2Ref, item: item7)
        
        
        // Card Text View
        let ftvApp = FlexTextView.appearance(whenContainedInInstancesOf: [FlexCardTextViewCollectionViewCell.self])
        ftvApp.controlInsets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        ftvApp.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        ftvApp.styleColor = UIColor.MKColor.Brown.P50
        ftvApp.contentViewMargins = UIEdgeInsets(top: 2, left: 0, bottom: 1, right: 0)
        
        let cardApp = FlexCardTextViewCollectionViewCell.appearance()
        cardApp.textColor = UIColor.MKColor.Grey.P800
        cardApp.textContainerInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let item8 = FlexCardTextViewCollectionItem(reference: "item8ref", text: NSAttributedString(string: "Text String"), icon: ti1, accessoryImage: nil, title: NSAttributedString(string: "Item 8"))
        item8.infoText = NSAttributedString(string: "Info")
        item8.detailText = NSAttributedString(string: "Detail Text")
        item8.auxText = NSAttributedString(string: "Aux Info")
        item8.preferredCellSize = CGSize(width: 250, height: 200)
        item8.cardHeaderHeight = 48
        item8.cardText = NSAttributedString(string: "This is a demo text for the FlexTextView. What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
        item8.textIsScrollable = true
        
        self.demoCollectionView.addItem(sec2Ref, item: item8)
        
        
        // Snap Stepper
        let flexSnapAppearance = FlexSnapStepper.appearance(whenContainedInInstancesOf: [FlexSnapStepperCollectionViewCell.self])
        flexSnapAppearance.thumbTintColor = UIColor.MKColor.Brown.P700
        flexSnapAppearance.separatorTintColor = UIColor.MKColor.Brown.P200
        flexSnapAppearance.style = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        flexSnapAppearance.thumbStyle = FlexShapeStyle(style: .roundedFixed(cornerRadius: 10))
        flexSnapAppearance.borderWidth = 0.5
        flexSnapAppearance.borderColor = UIColor.MKColor.Brown.P500
        flexSnapAppearance.thumbTextColor = UIColor.MKColor.Brown.P100
        
        let snapperItem = FlexSnapStepperCollectionItem(reference: "snapStepper", value: 0.0, text: NSAttributedString(string: "Snap Stepper"), icon: ti1, accessoryImage: ti2, title: NSAttributedString(string: "Item 9")) { (value) in
            NSLog("The snap stepper value is now \(value)")
        }
        snapperItem.controlInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 60)
        snapperItem.numberFormatString = "%0.2lf"
        
        self.demoCollectionView.addItem(sec2Ref, item: snapperItem)

    }
    
    // MARK: - FlexCollectionItemSwipeDelegate
    
    func swipeMenuSelected(_ item: FlexCollectionItem, menuItem: FlexLabel) {
        if let text = menuItem.label.text {
            NSLog("swipe menu item selected with text \(text)")
        }
    }
    
    // MARK: - FlexCollectionViewDelegate
    
    func onFlexCollectionItemMoved(_ view: FlexCollectionView, item: FlexCollectionItem) {
    }
    
    func onFlexCollectionItemSelected(_ view: FlexCollectionView, item: FlexCollectionItem) {
        NSLog("Item \(item.reference) selected")
    }
    
    // MARK: - TextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
