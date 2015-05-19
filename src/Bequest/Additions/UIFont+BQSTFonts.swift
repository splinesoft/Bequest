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

    class func BQSTMonoFont(size : CGFloat) -> UIFont {
        return self(name: "Menlo", size: size)!
    }

    class func BQSTItalicFont(size: CGFloat) -> UIFont {
        return self(name: "HelveticaNeue-MediumItalic", size: size)!
    }

    /// MARK - UI Elements

    class func BQSTHTTPHeaderFont() -> UIFont {
        return self.BQSTMonoFont(11)
    }

    class func BQSTRawResponseFont() -> UIFont {
        return self.BQSTMonoFont(12)
    }
}
