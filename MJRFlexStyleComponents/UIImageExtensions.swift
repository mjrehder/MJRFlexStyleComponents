//
//  UIImageExtensions.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 21.10.2016.
/*
 * Copyright 2016-present Martin Jacob Rehder.
 * http://www.rehsco.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
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

    func overlayImage(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .normal, alpha: 1.0)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }

    func maskImage(mask: UIImage) -> UIImage? {
        if let imageReference = self.cgImage, let maskReference = mask.cgImage, let dataProvider = maskReference.dataProvider {
            if let imageMask = CGImage(maskWidth: maskReference.width,
                                    height: maskReference.height,
                                    bitsPerComponent: maskReference.bitsPerComponent,
                                    bitsPerPixel: maskReference.bitsPerPixel,
                                    bytesPerRow: maskReference.bytesPerRow,
                                    provider: dataProvider, decode: nil, shouldInterpolate: true) {
                if let maskedReference = imageReference.masking(imageMask) {
                    let maskedImage = UIImage(cgImage:maskedReference)
                    return maskedImage
                }
            }
        }
        return nil
    }
    
    func scaleToSizeKeepAspect(size: CGSize) -> UIImage {
        let ws = size.width/self.size.width
        let hs = size.height/self.size.height
        let scale = min( ws, hs)
        
        let srcSize = self.size
        let rect = CGRect(x: srcSize.width/2-(srcSize.width*scale)/2,
                          y: srcSize.height/2-(srcSize.height*scale)/2, width: srcSize.width*scale,
                          height: srcSize.height*scale)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0.0, y: rect.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
