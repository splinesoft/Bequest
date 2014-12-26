//
//  UIColor+BQSTColors.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/11/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func BQSTRedColor() -> UIColor {
        return self(red: CGFloat(0.7), green: CGFloat(0.11), blue: CGFloat(0.13), alpha: 1)
    }
    
    class func BQSTGrayColor() -> UIColor {
        return self(white: CGFloat(0.9), alpha: CGFloat(1.0))
    }
    
    class func BQSTGreenColor() -> UIColor {
        return self.greenColor()
    }
    
    class func BQSTNavColor() -> UIColor {
        return self(white: 0.05, alpha: 1.0)
    }
}
