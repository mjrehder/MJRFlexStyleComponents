//
//  LabelFactory.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 22.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit
import SnappingStepper

final class LabelFactory {
    static func defaultLabel() -> UILabel {
        let label                    = UILabel()
        label.textAlignment          = .Center
        label.userInteractionEnabled = true
        
        return label
    }
    
    static func defaultStyledLabel() -> StyledLabel {
        let label           = StyledLabel()
        label.textAlignment = .Center
        label.text          = ""
        
        return label
    }
    
    static func defaultStyledThumb() -> StyledSliderThumb {
        let label           = StyledSliderThumb()
        label.textAlignment = .Center
        label.text          = ""
        
        return label
    }
}
