//
//  StyledSliderThumb.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 10.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import SnappingStepper

enum StyledSliderThumbBehaviour {
    case Freeform
    case SnapToLower
    case SnapToHigher
    case SnapToCenter
    case SnapToLowerAndHigher
    case FixateToLower
    case FixateToHigher
    case FixateToCenter
}

class StyledSliderThumb: StyledLabel {
    var snappingBehavior = SnappingThumbBehaviour(item: nil, snapToPoint: CGPointZero)
    var behaviour: StyledSliderThumbBehaviour = .Freeform    
}
