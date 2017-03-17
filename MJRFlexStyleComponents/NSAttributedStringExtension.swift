//
//  NSAttributedStringExtension.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 20.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return boundingBox.width
    }
    
    func heightWithConstrainedWidthSize(_ width: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return boundingBox.size
    }
    
    func widthWithConstrainedHeightSize(_ height: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return boundingBox.size
    }
}
