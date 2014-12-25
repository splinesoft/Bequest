//
//  BQSTSimpleCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources

let kBQSTSimpleCellInsets = UIEdgeInsetsMake(3, 8, 3, 8)

class BQSTSimpleCollectionCell : SSBaseCollectionCell {
    
    var label: UILabel?
    
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
}
