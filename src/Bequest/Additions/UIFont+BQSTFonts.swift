//
//  UIFont+BQSTFonts.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func BQSTFont(size : CGFloat) -> UIFont {
        return self(name: "Avenir", size: size)!
    }
}