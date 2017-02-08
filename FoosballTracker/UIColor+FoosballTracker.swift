//
//  UIColor+FoosballTracker.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/8/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

extension UIColor {
    class var appBlue: UIColor {
        return UIColor.hexColor(0x2196f3)
    }
    class var appBlueDisabled: UIColor {
        return UIColor.hexColor(0x8AC4F3)
    }

    public class func RGBColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let alphaMax = max(0.0, alpha)
        let alphaMin = min(1.0, alphaMax)

        return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: alphaMin)
    }

    public class func hexColor(_ hexValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        return RGBColor(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }


    func resizeableImageFromColor() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
