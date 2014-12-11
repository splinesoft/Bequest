//
//  UIView+BQSTDrawing.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/11/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

let kBQSTBoxInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 10)
let kBQSTBoxShadowInsets : UIEdgeInsets = UIEdgeInsetsMake(10, 10, 0, 0)

extension UIView {
    
    func BQSTDrawColoredBox(rect : CGRect, color : UIColor) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw gray box shadow
        CGContextSaveGState(context)
        
        CGContextSetFillColorWithColor(context, UIColor.BQSTGrayColor().CGColor)
        CGContextFillRect(context, UIEdgeInsetsInsetRect(rect, kBQSTBoxShadowInsets))
        
        CGContextRestoreGState(context)
        
        // Draw colored background
        CGContextSaveGState(context)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, UIEdgeInsetsInsetRect(rect, kBQSTBoxInsets))
        
        CGContextRestoreGState(context)
        
        // Draw lower left shadow corner
        CGContextSaveGState(context)
        
        CGContextSetFillColorWithColor(context, UIColor.BQSTGrayColor().CGColor)
        
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - kBQSTBoxInsets.bottom)
        CGContextAddLineToPoint(context, CGRectGetMinX(rect) + kBQSTBoxShadowInsets.left, CGRectGetMaxY(rect))
        CGContextAddLineToPoint(context, CGRectGetMinX(rect) + kBQSTBoxShadowInsets.left, CGRectGetMaxY(rect) - kBQSTBoxInsets.bottom)
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - kBQSTBoxInsets.bottom)
        CGContextClosePath(context)
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
    }
}