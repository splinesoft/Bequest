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
    
    lazy var cellColor : UIColor = {
        return UIColor.BQSTRedColor()
    }()
    
    lazy var label : UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.font = UIFont.BQSTFont(14)
        label.textColor = UIColor.darkTextColor()
        label.textAlignment = .Right
        
        return label
    }()
    
    override var highlighted : Bool {
        didSet {
            self.BQSTBounce(nil)
        }
    }
    
    override func configureCell() {
        super.configureCell()
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = false
        
        self.contentView.addSubview(label)
        label.snp_makeConstraints { make in
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView).insets(kBQSTBoxInsets)
            make.height.equalTo(kBQSTBoxInsets.bottom)
        }
        
        self.highlighted = false
    }
    
    override func drawRect(rect: CGRect) {
        self.BQSTDrawColoredBox(rect, color: self.cellColor)
    }
}
