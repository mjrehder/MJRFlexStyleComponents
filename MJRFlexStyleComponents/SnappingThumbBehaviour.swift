//
//  SnappingThumbBehaviour.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 09.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

final internal class SnappingThumbBehaviour: UIDynamicBehavior {
    init(item: UIDynamicItem?, snapToPoint point: CGPoint, damping: CGFloat = 0.25) {
        super.init()
        
        if let _item = item {
            let dynamicItemBehavior = UIDynamicItemBehavior(items: [_item])
            dynamicItemBehavior.allowsRotation = false
            
            let snapBehavior     = UISnapBehavior(item: _item, snapToPoint: point)
            snapBehavior.damping = damping
            
            addChildBehavior(dynamicItemBehavior)
            addChildBehavior(snapBehavior)
        }
    }
}