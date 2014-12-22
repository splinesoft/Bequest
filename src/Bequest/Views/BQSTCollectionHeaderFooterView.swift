//
//  BQSTCollectionHeaderFooterView.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources

class BQSTCollectionHeaderFooterView : SSBaseCollectionReusableView {
    
    var button: UIButton?
    
    override class func supplementaryViewForCollectionView(cv: UICollectionView!, kind: String!, indexPath: NSIndexPath!) -> BQSTCollectionHeaderFooterView {
        
        let view = super.supplementaryViewForCollectionView(cv, kind: kind, indexPath: indexPath) as BQSTCollectionHeaderFooterView
        
        if view.button == nil {
            view.button = UIButton.buttonWithType(UIButtonType.System) as? UIButton //UILabel(frame: view.frame)
            view.button?.setTitleColor(UIColor.BQSTRedColor(), forState: .Normal)
            view.button?.setTitleColor(UIColor.lightGrayColor(), forState: .Selected)
            view.button?.titleLabel?.font = UIFont.BQSTFont(18)
            view.button?.titleLabel?.textAlignment = .Left
            view.addSubview(view.button!)
        }
        
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button?.frame = UIEdgeInsetsInsetRect(self.frame, kBQSTSimpleCellInsets)
    }
}