//
//  NSStringExtension.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 21.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .max)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil))
        return boundingBox.height
    }

    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .max, height: height)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil))
        return boundingBox.width
    }

    func heightWithConstrainedWidthSize(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .max)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil))
        return boundingBox.size
    }
    
    func widthWithConstrainedHeightSize(height: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: .max, height: height)
        let boundingBox = CGRectIntegral(self.boundingRectWithSize(constraintRect, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil))
        return boundingBox.size
    }
}
