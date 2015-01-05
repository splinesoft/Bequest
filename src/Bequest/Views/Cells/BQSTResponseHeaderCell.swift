//
//  BQSTResponseHeaderCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources
import TTTAttributedLabel

let kBQSTSimpleCellInsets = UIEdgeInsetsMake(3, 8, 3, 8)

extension NSAttributedString {
    
    class func headerAttributedString(string: String) -> NSAttributedString {
        return self(string: string, attributes: [NSFontAttributeName : UIFont.BQSTHTTPHeaderFont()])
    }
}

class BQSTResponseHeaderCell : SSBaseTableCell {
    
    var label: TTTAttributedLabel?
    var value: TTTAttributedLabel?
    
    class func heightForValues(values: [String], availableWidth: CGFloat) -> CGFloat {
        
        func sizeText(text: String) -> CGFloat {
            let attributedString = NSAttributedString.headerAttributedString(text)
            let size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString,
                withConstraints: CGSizeMake((availableWidth / 2) - kBQSTSimpleCellInsets.left - kBQSTSimpleCellInsets.right, CGFloat.max),
                limitedToNumberOfLines: 0)
            
            return ceil(size.height + kBQSTSimpleCellInsets.bottom + kBQSTSimpleCellInsets.top)
        }
        
        if values.count > 1 {
            return max(sizeText(values[0]), sizeText(values[1]))
        } else if values.count > 0 {
            return sizeText(values.first!)
        } else {
            return 0
        }
    }
    
    override func configureCell() {
        super.configureCell()
        
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .Gray

        label = TTTAttributedLabel(frame: self.contentView.frame)
        label!.font = UIFont.BQSTHTTPHeaderFont()
        label!.textColor = UIColor.BQSTGrayColor()
        label!.backgroundColor = UIColor.clearColor()
        label!.numberOfLines = 0
        label!.verticalAlignment = .Center
        label!.textAlignment = .Right;
        self.contentView.addSubview(label!)
        
        value = TTTAttributedLabel(frame: self.contentView.frame)
        value!.font = UIFont.BQSTHTTPHeaderFont()
        value!.textColor = UIColor.BQSTRedColor()
        value!.backgroundColor = UIColor.clearColor()
        value!.numberOfLines = 0
        value!.verticalAlignment = .Center
        value!.textAlignment = .Left;
        self.contentView.addSubview(value!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = (CGRectGetWidth(self.contentView.frame) / 2) - kBQSTSimpleCellInsets.left - kBQSTSimpleCellInsets.right
        let height = CGRectGetHeight(self.contentView.frame) - kBQSTSimpleCellInsets.top - kBQSTSimpleCellInsets.bottom
        
        label!.frame = CGRectMake(kBQSTSimpleCellInsets.left,
            kBQSTSimpleCellInsets.top,
            width,
            height)
        
        value!.frame = CGRectMake(width + (2 * kBQSTSimpleCellInsets.left) + kBQSTSimpleCellInsets.right,
            kBQSTSimpleCellInsets.top,
            width,
            height)
    }
    
    func configureWithValues(items: [String]) {
        self.label!.text = items[0]
        self.value!.text = items[1]
        self.setNeedsLayout()
    }
}
