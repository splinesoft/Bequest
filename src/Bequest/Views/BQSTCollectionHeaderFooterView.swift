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
    
    var label: UILabel?
    
    override class func supplementaryViewForCollectionView(cv: UICollectionView!, kind: String!, indexPath: NSIndexPath!) -> BQSTCollectionHeaderFooterView {
        
        let view = super.supplementaryViewForCollectionView(cv, kind: kind, indexPath: indexPath) as BQSTCollectionHeaderFooterView
        
        if view.label == nil {
            view.label = UILabel(frame: view.frame)
            view.label!.font = UIFont.BQSTFont(18)
            view.label!.textColor = UIColor.BQSTRedColor()
            view.addSubview(view.label!)
        }
        
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label?.frame = UIEdgeInsetsInsetRect(self.frame, kBQSTSimpleCellInsets)
    }
}