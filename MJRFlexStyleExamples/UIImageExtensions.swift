//
//  UIImageExtensions.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 21.10.2016.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

extension UIImage {
    func tint(_ color: UIColor) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.translateBy(x: 0, y: self.size.height)
        ctx!.scaleBy(x: 1.0, y: -1.0);
        ctx!.setBlendMode(CGBlendMode.normal)
        
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        ctx!.clip(to: area, mask: self.cgImage!)
        ctx!.fill(area)
        
        defer { UIGraphicsEndImageContext() };
        
        return UIGraphicsGetImageFromCurrentImageContext()!;
    }
    
    func circularImage(size: CGSize?) -> UIImage? {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
