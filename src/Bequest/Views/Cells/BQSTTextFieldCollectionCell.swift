//
//  BQSTTextFieldCollectionCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation

class BQSTTextFieldCollectionCell : BQSTBlockyCollectionCell {

    lazy var textField : UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.font = UIFont.BQSTMonoFont(16)
        textField.textColor = UIColor.whiteColor()
        textField.clearButtonMode = .WhileEditing
        textField.returnKeyType = .Done
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.spellCheckingType = .No
        textField.keyboardAppearance = .Dark

        return textField
    }()

    override func configureCell() {
        super.configureCell()

        self.contentView.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 14, 14, 14))
        }
    }
}
