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
    
    class func BQSTRedColor() -> UIColor! {
        return self(red: CGFloat(0.9), green: CGFloat(0.1), blue: CGFloat(0.1), alpha: 1)
    }
    
    class func BQSTGrayColor() -> UIColor! {
        return self(white: CGFloat(0.9), alpha: CGFloat(1.0))
    }
}