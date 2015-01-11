//
//  BQSTTextFieldCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation

class BQSTTextFieldCollectionCell : BQSTBlockyCollectionCell {
    
    lazy var label : UILabel = {
        let label = UILabel(frame: CGRectMake(kBQSTBoxInsets.left,
            CGRectGetHeight(self.contentView.frame) - kBQSTBoxInsets.bottom,
            CGRectGetWidth(self.contentView.frame) - kBQSTBoxInsets.right,
            kBQSTBoxInsets.bottom))
        label.font = UIFont.BQSTFont(14)
        label.textColor = UIColor.darkTextColor()
        label.textAlignment = .Right
        
        return label
    }()
    
    lazy var textField : UITextField = {
        let textField = UITextField(frame: CGRectMake(kBQSTBoxShadowInsets.left,
            0,
            CGRectGetWidth(self.contentView.frame) - kBQSTBoxInsets.right - kBQSTBoxShadowInsets.left,
            CGRectGetHeight(self.contentView.frame) - kBQSTBoxInsets.bottom))
        textField.font = UIFont.BQSTMonoFont(16)
        textField.textColor = UIColor.whiteColor()
        textField.clearButtonMode = .WhileEditing
        textField.returnKeyType = .Done
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.spellCheckingType = .No
        
        return textField
    }()
    
    override func configureCell() {
        super.configureCell()
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(textField)
    }
}
