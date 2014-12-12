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

let kBQSTRequestInsets = UIEdgeInsetsMake(10, 10, 10, 10)
let kBQSTLineSpacing = CGFloat(14)

enum BQSTRequestRow : Int {
    case URL = 0
    case Method
    
    
    case NumRows
}

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
        self.title = "Bequest"
        
        let section = SSSection(numberOfItems: UInt(BQSTRequestRow.NumRows.rawValue))
        dataSource = SSExpandingDataSource(section: section)
        
        dataSource!.cellCreationBlock = { (value, collectionView, indexPath) in
            return BQSTCollectionValueCell.self(forCollectionView: collectionView as UICollectionView,
                indexPath: indexPath as NSIndexPath)
        }
        
        dataSource!.cellConfigureBlock = {
            (c, value, collectionView, indexPath) in
            
            if let row = BQSTRequestRow(rawValue: indexPath.row) {
                
                let cell = c as BQSTCollectionValueCell
                
                switch row {
                case .Method:
                    cell.label?.text = "Method"
                case .URL:
                    cell.label?.text = "URL"
                default:
                    break
                }
            }
        }

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView!.registerClass(BQSTCollectionValueCell.self,
            forCellWithReuseIdentifier: BQSTCollectionValueCell.identifier())
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
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
        let fullWidth = CGSize(width: CGRectGetWidth(collectionView.frame) - kBQSTRequestInsets.left - kBQSTRequestInsets.right,
            height: 60)
        let halfWidth = CGSizeMake(fullWidth.width / 2, fullWidth.height)
    
        if let row = BQSTRequestRow(rawValue: indexPath.row) {
            
            switch row {
            case .URL:
                return fullWidth
            default:
                return halfWidth
            }
            
        }
        
        return CGSizeZero
    }
}
