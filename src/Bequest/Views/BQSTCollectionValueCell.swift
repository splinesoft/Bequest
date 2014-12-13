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
    var textField : UITextField?
    
    override func configureCell() {
        super.configureCell()
        
        label = UILabel(frame: CGRectMake(kBQSTBoxInsets.left,
            CGRectGetHeight(self.contentView.frame) - kBQSTBoxInsets.bottom,
            CGRectGetWidth(self.contentView.frame) - kBQSTBoxInsets.right,
            kBQSTBoxInsets.bottom))
        label!.font = UIFont.BQSTFont(14)
        label!.textColor = UIColor.darkTextColor()
        label!.textAlignment = .Right
        self.contentView.addSubview(label!)
        
        textField = UITextField(frame: CGRectMake(kBQSTBoxShadowInsets.left,
            0,
            CGRectGetWidth(self.contentView.frame) - kBQSTBoxInsets.right - kBQSTBoxShadowInsets.left,
            CGRectGetHeight(self.contentView.frame) - kBQSTBoxInsets.bottom))
        textField!.font = UIFont.BQSTMonoFont(16)
        textField!.textColor = UIColor.whiteColor()
        textField!.clearButtonMode = .WhileEditing
        textField!.returnKeyType = .Done
        textField!.autocapitalizationType = .None
        textField!.autocorrectionType = .No
        textField!.spellCheckingType = .No
        self.contentView.addSubview(textField!)
        
//        label!.mas_makeConstraints { (make : MASConstraintMaker!) in
//            // Absurd Swift syntax for Masonry
//            (((make.right.and().bottom().equalTo())(self.contentView)).insets())(kBQSTBoxShadowInsets)
//            (((make.left.equalTo())(self.contentView)).insets())(kBQSTBoxInsets)
//            ((make.height.equalTo())(kBQSTBoxShadowInsets.bottom))
//        }
    }
}