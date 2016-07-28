# MJRFlexStyleComponents

Sliding components with easy layout options written in Swift.

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
pod 'SnappingStepper', :git => 'https://github.com/yannickl/SnappingStepper.git', :branch => 'master'
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

Note 1: The flex components currently need the SnappingStepper ‘master’ branch
Note 2: If you need to use the ShapeStyle class in your project, then remember to ‘import SnappingStepper’ as well

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

This is a compact menu with a thumb shortcut text and a menu title for an arbitrary number of FlexMenuItems

Example (from the example project):
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

### GenericStyleSlider

This is the class used by all other classes, either as superclass or in the case of the FlexSeriesView as sub components.
You can use the generic slider directly or make other subclasses from it.

## TODO
Here are some item, which could improve the components. Any contribution is welcome and this list might be an inspiration.

### Discrete/Step Values
Right now the sliders are continous. It would be nice to have stepping values, which allow the slider to snap to these.

### Insets for the background
Some styles do not match correctly with the control background, for example a tube style of the control with a rounded thumb style.
In order to avoid artifacts, an inset could help to have a matching background layout.

### Inverse Direction
Currently only left-to-right (horizontal) and top-down (vertical) layout is supported. Especially for the FlexSeriesView it would make sense to have bottom-up also.


## Acknowledgements

Using SnappingStepper by Yannick Loriot (https://github.com/yannickl/SnappingStepper.git)
and inspirations from BEMSimpleLineGraph by Boris Emorine and Sam Spencer (https://github.com/Boris-Em/BEMSimpleLineGraph)

## License

MJRFlexStyleComponents is available under the MIT license. See the LICENSE file for more info.
