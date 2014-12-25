//
//  BQSTHeaderCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources
import TTTAttributedLabel

let kBQSTSimpleCellInsets = UIEdgeInsetsMake(3, 8, 3, 8)

extension NSAttributedString {
    
    class func headerAttributedString(string: String) -> NSAttributedString {
        return self(string: string, attributes: [NSFontAttributeName : UIFont.BQSTHTTPHeaderFont()])
    }
}

class BQSTHeaderCollectionCell : SSBaseCollectionCell {
    
    var label: TTTAttributedLabel?
    
    override func configureCell() {
        super.configureCell()

        label = TTTAttributedLabel(frame: self.contentView.frame)
        label!.font = UIFont.BQSTHTTPHeaderFont()
        label!.textColor = UIColor.BQSTRedColor()
        label!.backgroundColor = UIColor.clearColor()
        label!.numberOfLines = 0
        label!.verticalAlignment = .Center
        self.contentView.addSubview(label!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label!.frame = UIEdgeInsetsInsetRect(self.contentView.frame, kBQSTSimpleCellInsets)
    }
}
