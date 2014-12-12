//
//  BQSTCollectionValueCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import Masonry

class BQSTCollectionValueCell : BQSTBlockyCollectionCell {
    
    var label : UILabel?
    
    override func configureCell() {
        super.configureCell()
        
        label = UILabel(frame: CGRectMake(kBQSTBoxInsets.left,
            CGRectGetHeight(self.frame) - kBQSTBoxInsets.bottom,
            CGRectGetWidth(self.frame) - kBQSTBoxInsets.right,
            kBQSTBoxInsets.bottom))
        label!.font = UIFont.BQSTFont(15)
        label!.textColor = UIColor.darkTextColor()
        label!.textAlignment = .Right
        self.contentView.addSubview(label!)
//        label!.mas_makeConstraints { (make : MASConstraintMaker!) in
//            // Absurd Swift syntax for Masonry
//            (((make.right.and().bottom().equalTo())(self.contentView)).insets())(kBQSTBoxShadowInsets)
//            (((make.left.equalTo())(self.contentView)).insets())(kBQSTBoxInsets)
//            ((make.height.equalTo())(kBQSTBoxShadowInsets.bottom))
//        }
    }
}