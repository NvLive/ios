//
//  UIImage+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func tintWithColor(color:UIColor)->UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context!.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context!.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
}
