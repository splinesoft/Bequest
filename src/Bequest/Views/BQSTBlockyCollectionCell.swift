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

class BQSTBlockyCollectionCell : SSBaseCollectionCell {
    
    var cellColor : UIColor?
    
    // TODO: this is exactly what we want but it segfaults the swift compiler
//    override var highlighted : Bool = false {
//        didSet {
//            self.BQSTBounce(nil)
//        }
//    }
    
    override func configureCell() {
        super.configureCell()
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = false
        
        self.highlighted = false
        
        cellColor = UIColor.BQSTRedColor()
    }
    
    override func drawRect(rect: CGRect) {
        self.BQSTDrawColoredBox(rect, color: self.cellColor!)
    }
}