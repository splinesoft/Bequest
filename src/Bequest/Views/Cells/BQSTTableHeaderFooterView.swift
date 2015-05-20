//
//  BQSTCollectionHeaderFooterView.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources

class BQSTTableHeaderFooterView: SSBaseHeaderFooterView {

    let button: UIButton = {
        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.setTitleColor(UIColor.BQSTRedColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.titleLabel?.font = UIFont.BQSTFont(18)
        button.titleLabel?.textAlignment = .Left
        button.backgroundColor = UIColor.clearColor()

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let background = UIView()
        background.backgroundColor = UIColor.BQSTNavColor()
        self.backgroundView = background

        self.contentView.addSubview(self.button)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.frame = UIEdgeInsetsInsetRect(self.contentView.frame, kBQSTSimpleCellInsets)
    }
}
