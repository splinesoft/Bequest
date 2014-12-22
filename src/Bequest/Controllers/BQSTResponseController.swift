//
//  BQSTResponseController.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit
import SSDataSources

class BQSTResponseController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let request : NSURLRequest
    private let response : NSHTTPURLResponse?
    private let parsedResponse : BQSTHTTPResponse
    private let dataSource : SSSectionedDataSource = {
        let dataSource = SSSectionedDataSource(items: nil)
        dataSource.removeAllSections()
        dataSource.collectionViewSupplementaryElementClass = BQSTCollectionHeaderFooterView.self
        dataSource.cellCreationBlock = { (item, collectionView, indexPath) in
            if indexPath.section == 0 {
                return BQSTSimpleCollectionCell(forCollectionView: collectionView as UICollectionView, indexPath: indexPath) as UICollectionViewCell
            }
            
            return nil
        }
        dataSource.cellConfigureBlock = { (cell, item, collectionView, indexPath) in
            if indexPath.section == 0 {
                (cell as BQSTSimpleCollectionCell).label!.text = item as? String
                (cell as BQSTSimpleCollectionCell).label!.textAlignment = (indexPath.row % 2 == 0
                    ? .Right
                    : .Left)
            }
        }
        
        dataSource.collectionSupplementaryConfigureBlock = { (v, kind, collectionView, indexPath) in
            let view = v as BQSTCollectionHeaderFooterView
            
            if indexPath.section == 0 {
                view.label?.text = "Headers (\(dataSource.numberOfItemsInSection(0) / 2))"
            }
        }
        
        return dataSource
    }()
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView.registerClass(BQSTSimpleCollectionCell.self,
            forCellWithReuseIdentifier: BQSTSimpleCollectionCell.identifier())
        collectionView.registerClass(BQSTCollectionHeaderFooterView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: BQSTCollectionHeaderFooterView.identifier())
        
        return collectionView
    }()
    
    init(request: NSURLRequest, response: NSHTTPURLResponse?, parsedResponse: BQSTHTTPResponse) {
        self.request = request
        self.response = response
        self.parsedResponse = parsedResponse
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        self.request = NSURLRequest()
        self.parsedResponse = BQSTHTTPResponse(contentType: nil, object: 0)
        super.init(coder: aDecoder)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Response"
        self.view.backgroundColor = UIColor.blackColor()
        
        collectionView.frame = self.view.bounds
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        
        if (response?.statusCode != nil) {
            self.title = self.title! + " (\(response!.statusCode))"
        }
        
        // HTTP Headers
        if response?.allHeaderFields != nil {
            let sortedNames: [NSObject] = (response?.allHeaderFields.keys.array.sorted {
                return ($0 as String) < ($1 as String)
            })!

            var headers = NSMutableArray()
            
            for key in sortedNames {
                headers.addObject(key)
                headers.addObject(response!.allHeaderFields[key]!)
            }
            
            dataSource.appendSection(SSSection(items: headers))
        }
        
        dataSource.collectionView = collectionView
    }
    
    /// MARK: UICollectionViewDelegate
    
    /// MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
            if section == 0 {
                return CGSizeMake(0, 60)
            }
            
            return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
            if section == 0 {
                return 0
            }
            
            return 0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
            if section == 0 {
                return 0
            }
            
            return 0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            if indexPath.section == 0 {
                if indexPath.row % 2 == 0 {
                    return self.collectionView(collectionView,
                        layout: collectionViewLayout,
                        sizeForItemAtIndexPath: NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section))
                }
                
                let text = dataSource.itemAtIndexPath(indexPath) as NSString
                let rect = text.boundingRectWithSize(CGSizeMake((CGRectGetWidth(collectionView.frame) / 2) - kBQSTSimpleCellInsets.left - kBQSTSimpleCellInsets.right, CGFloat.max),
                    options: .UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName: UIFont.BQSTHTTPHeaderFont()],
                    context: nil)
                
                return CGSizeMake(CGRectGetWidth(collectionView.frame) / 2,
                    ceil(CGRectGetHeight(rect)) + kBQSTSimpleCellInsets.bottom + kBQSTSimpleCellInsets.top)
            }
            
            return CGSizeZero
    }
}
