//
//  UIApplication+BQSTAdditions.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/13/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    class func BQSTApplicationName() -> String? {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as? String
    }
}
