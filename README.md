# MJRFlexStyleComponents

Sliding components and containers with easy layout options written in Swift.

The example shows the sliding components, where the components themselves are used to manipulate the others in order to see many of the features.
Any component can of course be used separately.

<p align="center">
  <img src="http://www.rehsco.com/resources/MJRFlexStyleComponentsDemo.gif" alt="screenshot" />
</p>

## Installation

### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _MJRFlexStyleComponents_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘9.0’

use_frameworks!
pod 'SnappingStepper', '~> 2.3.1’
pod ‘MJRFlexStyleComponents’, '~> 1.0.0’
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import MJRFlexStyleComponents` framework into your files.

Note: If you need to use the ShapeStyle class in your project, then remember to ‘import SnappingStepper’ as well

## The Components

There is an example project included in the source, which shows many of the features.

Each component has styling options, which are configured in the same way and with the same values, in order to easily have the same look and feel for the entire UI.
The goal for these components was to have very compact and still flexible components for designing a UI with a minimum amount of explaining labels.

### FlexSwitch

A switch very similar to UISwitch

Example:
```swift
    let switch = FlexSwitch()
    switch.switchDelegate = self

    func switchStateChanged(flexSwitch: FlexSwitch, on: Bool) {
	. . . 
    }
```

### FlexSlider

A slider very similar to UISlider

Example:
```swift
	let slider = FlexSlider()
        slider.backgroundColor = .clearColor()
        slider.minimumValue = 1
        slider.maximumValue = 4
        slider.value = 2
        slider.thumbText = nil
        slider.numberFormatString = "%.0f"
        slider.maximumTrackText = "Series"
        slider.valueChangedBlock = {
            (value, index) in
		. . .
        }
```

### FlexDoubleSlider

This is a slider with two thumbs instead of one. The lower value cannot be larger than the upper at any time.

Example:
```swift
	let slider = FlexDoubleSlider()
        slider.backgroundColor = UIColor.clearColor()
        slider.direction = .Vertical
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.thumbRatio = 0.1
        slider.hintStyle = .Rounded
        slider.thumbText = nil
        slider.numberFormatString = "%.1f"
        slider.value = 0
        slider.value2 = 100

        slider.valueChangedBlock = {
            (value, index) in
            if index == 0 {
		. . .
            }
            else {
		. . .
            }
        }
```

### FlexMenu

![flexmenusdemo](https://cloud.githubusercontent.com/assets/476994/18223685/9608dbc6-71bf-11e6-9939-e1554d6ed890.gif)

FlexMenu has three different layout types:
* Compact
* Equally Spaced
* Dynamically Spaced

The compact menu has a thumb shortcut text and a menu title for an arbitrary number of FlexMenuItems. You can swipe the thumbs to change the selected menu item or press the thumbs.

The equally and dynamically spaced layouts are similar to the familiar Toolbar or NavigationBar from iOS.

All menu layouts support vertical layout and you can specify the gravity of the text labels in order to rotate the text
```swift
    flexMenuExample.menuItemGravity: FlexMenuItemGravity = .Normal // .Left or .Right
```

Simple example for the compact style (from the example project):
```swift
    var styleMenuItems: [FlexMenuItem] = []
    let styleMenuSelector = FlexMenu()

    func setupStyleMenuSelectionSlider() {
        let col1 = FlexMenuItem(title: "Box", titleShortcut: "B", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col2 = FlexMenuItem(title: "Rounded", titleShortcut: "R", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        let col3 = FlexMenuItem(title: "Tube", titleShortcut: "T", color: UIColor.MKColor.Grey.P200, thumbColor: UIColor.MKColor.Grey.P500)
        self.styleMenuItems.append(col1)
        self.styleMenuItems.append(col2)
        self.styleMenuItems.append(col3)
        
        self.styleMenuSelector.menuDataSource = self
    }

    // MARK: - FlexMenuDataSource
    
    func numberOfMenuItems(menu: FlexMenu) -> Int {
        return self.styleMenuItems.count
    }
    
    func menuItemForIndex(menu: FlexMenu, index: Int) -> FlexMenuItem {
        return self.styleMenuItems[index]
    }
    
    func menuItemSelected(menu: FlexMenu, index: Int) {
        switch index {
            case 0:
                self.setStyleOfDemoControls(.Box)
            case 1:
                self.setStyleOfDemoControls(.Rounded)
            case 2:
                self.setStyleOfDemoControls(.Tube)
            default:
                break
        }
    }
```

### FlexSeriesView

A component using FlexSlider controls for showing and editing value graphs

Example (from the example project):
```swift
    let sliderGraphView = FlexSeriesView()

    func setupSliderGraphView() {
        // Standard iOS UI
        self.sliderGraphView.layer.borderWidth = 1.0
        self.sliderGraphView.layer.borderColor = UIColor.blackColor().CGColor
        self.sliderGraphView.layer.masksToBounds = true
        self.sliderGraphView.layer.cornerRadius = 10

        // The graph setup
        self.sliderGraphView.itemSize = 24
        self.sliderGraphView.backgroundColor = UIColor.clearColor()
        self.sliderGraphView.dataSource = self
        self.sliderGraphView.reloadData()
    }

    // MARK: - FlexSeriesViewDataSource
    
    func dataOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int) -> Double {
        return self.dataSeries[series][point]
    }
    
    func dataChangedOfSeriesAtPoint(flexSeries: FlexSeriesView, series: Int, point: Int, data: Double) {
        self.dataSeries[series][point] = data
    }
    
    func numberOfSeries(flexSeries: FlexSeriesView) -> Int {
        return self.numSeries
    }
    
    func numberOfDataPoints(flexSeries: FlexSeriesView) -> Int {
        return self.numDataPoints
    }
```

### FlexView

![flexviewdemo](https://cloud.githubusercontent.com/assets/476994/17434897/6638ad5e-5b0d-11e6-8082-903326f31c28.png)

This view is similar to a UIView, but has support for header and footer labels. You can use the same styling for the view, the header and the footer as for all the other components and the header/footer can also appear on the left or right side.
Margins allow the header and footer to be detached of the background, if that is desired.

The FlexView can have FlexViewMenu menus, which are added by using:
```swift
    viewMenu = ... (Omitted the code. See example from the FlexMenu section)
    flexViewMenu = FlexViewMenu(menu: viewMenu, size: CGSizeMake(100, 18), hPos: .Center, vPos: .Top)
    flexView.addMenu(flexViewMenu)
```
The size of the FlexViewMenu is relevant, if you do not fill the menu. The height in the size will be the height of the menu.
The horizontal position (hPos) can be .Left, .Right, .Center and .Fill.
The vertical position (vPos) can be .Header, .Top, .Bottom and .Footer and places the menu inside the FlexView at that location. The headerSize and footerSize of the FlexView is used as the vertical offset when you choose .Bottom (ie. above the footer) or .Top (below the header)

Example (from the example project):
```swift
        rightFlexView.headerPosition = .Right
        rightFlexView.backgroundMargins = UIEdgeInsetsMake(0, 15, 0, 20)
        rightFlexView.headerText = "Right"
        rightFlexView.footerText = "Right Footer"
        rightFlexView.styleColor = UIColor.MKColor.Amber.P100
        rightFlexView.headerBackgroundColor = UIColor.MKColor.Amber.P500
        rightFlexView.headerSize = 16
        rightFlexView.headerStyle = .Tube
        rightFlexView.headerClipToBackgroundShape = false
        rightFlexView.headerFont = UIFont.boldSystemFontOfSize(10)
        rightFlexView.footerFont = UIFont.systemFontOfSize(10)
        rightFlexView.footerClipToBackgroundShape = false
        rightFlexView.headerTextColor = UIColor.whiteColor()
        rightFlexView.style = .Custom(path: UIBezierPath(roundedRect: rightFlexView.bounds, cornerRadius: 10))
```

This example also shows the custom style option, where an arbitrary UIBezierPath is used to define the background style.

### GenericStyleSlider

This is the class used by all other slider classes, either as superclass or in the case of the FlexSeriesView as sub components.
You can use the generic slider directly or make other subclasses from it.

### MJRFlexBaseControl

This is the base class for all flex style controls. Extend this control, if you want to create a control based on the same styles and principles as the other components in this library.

## TODO
Here are some item, which could improve the components. Any contribution is welcome and this list might be an inspiration.

### Discrete/Step Values
Right now the sliders are continous. It would be nice to have stepping values, which allow the slider to snap to these.

### Inverse Direction
Currently only left-to-right (horizontal) and top-down (vertical) layout is supported. Especially for the FlexSeriesView it would make sense to have bottom-up also.


## Acknowledgements

Using SnappingStepper by Yannick Loriot (https://github.com/yannickl/SnappingStepper.git)
and inspirations from BEMSimpleLineGraph by Boris Emorine and Sam Spencer (https://github.com/Boris-Em/BEMSimpleLineGraph)

## License

MJRFlexStyleComponents is available under the MIT license. See the LICENSE file for more info.
