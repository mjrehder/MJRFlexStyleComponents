//
//  SnappingThumbBehaviour.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

final internal class SnappingThumbBehaviour: UIDynamicBehavior {
    init(item: UIDynamicItem?, snapToPoint point: CGPoint) {
        super.init()
        
        if let _item = item {
            let dynamicItemBehavior            = UIDynamicItemBehavior(items: [_item])
            dynamicItemBehavior.allowsRotation = false
            
            let snapBehavior     = UISnapBehavior(item: _item, snapToPoint: point)
            snapBehavior.damping = 0.25
            
            addChildBehavior(dynamicItemBehavior)
            addChildBehavior(snapBehavior)
        }
    }
}