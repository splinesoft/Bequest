//
//  BQSTCollectionHeaderFooterView.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources

class BQSTTableHeaderFooterView : SSBaseHeaderFooterView {
    
    var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let background = UIView()
        background.backgroundColor = UIColor.BQSTNavColor()
        self.backgroundView = background
        
        if self.button == nil {
            self.button = UIButton.buttonWithType(UIButtonType.System) as? UIButton //UILabel(frame: view.frame)
            self.button!.setTitleColor(UIColor.BQSTRedColor(), forState: .Normal)
            self.button!.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            self.button!.titleLabel?.font = UIFont.BQSTFont(18)
            self.button!.titleLabel?.textAlignment = .Left
            self.button!.backgroundColor = UIColor.clearColor()
            self.contentView.addSubview(self.button!)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button?.frame = UIEdgeInsetsInsetRect(self.contentView.frame, kBQSTSimpleCellInsets)
    }
}
