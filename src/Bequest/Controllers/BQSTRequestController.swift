//
//  BQSTRequestController.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/11/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit
import SSDataSources

let kBQSTRequestInsets = UIEdgeInsetsMake(30, 10, 10, 10)
let kBQSTLineSpacing = CGFloat(14)

class BQSTRequestController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    internal var collectionView : UICollectionView?
    internal var dataSource : SSExpandingDataSource?
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        dataSource = SSExpandingDataSource(items: [1, 2, 3])
        dataSource!.cellClass = BQSTColoredCollectionCell.self

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView!.registerClass(BQSTColoredCollectionCell.self,
            forCellWithReuseIdentifier: BQSTColoredCollectionCell.identifier())
        collectionView!.delegate = self
        
        self.view.addSubview(collectionView!)
        
        dataSource!.collectionView = collectionView
    }
    
    /// MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Selected index \(indexPath)")
    }
    
    /// MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return kBQSTLineSpacing
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return kBQSTRequestInsets
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: CGRectGetWidth(collectionView.frame) - kBQSTRequestInsets.left - kBQSTRequestInsets.right,
            height: 60)
    }
}
