//
//  BQSTColoredCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/11/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit
import SSDataSources

class BQSTColoredCollectionCell : SSBaseCollectionCell {
    
    var cellColor : UIColor?
    
    override func configureCell() {
        super.configureCell()
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        cellColor = UIColor.BQSTRedColor()
    }
    
    override func drawRect(rect: CGRect) {
        self.BQSTDrawColoredBox(rect, color: self.cellColor!)
    }
}