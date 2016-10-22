//
//  NSAttributedStringExtension.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 20.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .max)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil))
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .max, height: height)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil))
        
        return boundingBox.width
    }
}
