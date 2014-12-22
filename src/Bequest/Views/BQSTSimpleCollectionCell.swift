//
//  BQSTSimpleCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources

let kBQSTSimpleCellInsets = UIEdgeInsetsMake(8, 8, 8, 8)

class BQSTSimpleCollectionCell : SSBaseCollectionCell {
    
    var label : UILabel?
    
    override func configureCell() {
        super.configureCell()

        label = UILabel(frame: self.contentView.frame)
        label!.font = UIFont.BQSTHTTPHeaderFont()
        label!.textColor = UIColor.BQSTRedColor()
        label!.backgroundColor = UIColor.clearColor()
        label!.numberOfLines = 0
        label!.textAlignment = .Center
        self.contentView.addSubview(label!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label!.frame = UIEdgeInsetsInsetRect(self.contentView.frame, kBQSTSimpleCellInsets)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        
        CGContextSetStrokeColorWithColor(context, UIColor.BQSTRedColor().CGColor)
        CGContextSetLineWidth(context, 1)
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect) - 1)
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - 1)
        CGContextClosePath(context)
        CGContextStrokePath(context)
        
        CGContextRestoreGState(context)
    }
}
