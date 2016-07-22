//
//  StyledSliderThumb.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 10.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import SnappingStepper

public class StyledSliderThumb: StyledLabel {
    var snappingBehavior = SnappingThumbBehaviour(item: nil, snapToPoint: CGPointZero)
    var behaviour: StyledSliderThumbBehaviour = .Freeform
    var index = 0
}
