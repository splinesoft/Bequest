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
import JTSImageViewController

class BQSTResponseController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let request : NSURLRequest
    private let response : NSHTTPURLResponse?
    private let parsedResponse : BQSTHTTPResponse
    private let dataSource : SSExpandingDataSource = {
        let dataSource = SSExpandingDataSource(items: nil)
        dataSource.removeAllSections()
        dataSource.collectionViewSupplementaryElementClass = BQSTCollectionHeaderFooterView.self
        dataSource.cellCreationBlock = { (item, collectionView, indexPath) in
            if indexPath.section == 0 {
                return BQSTSimpleCollectionCell(forCollectionView: collectionView as UICollectionView, indexPath: indexPath)
            }
            
            return BQSTResponseCell(forCollectionView: collectionView as UICollectionView, indexPath: indexPath)
        }
        
        dataSource.collapsedSectionCountBlock = { (section, sectionIndex) in
            if sectionIndex == 0 {
                return 6
            }
            
            return 0
        }
        
        return dataSource
    }()
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView.registerClass(BQSTSimpleCollectionCell.self,
            forCellWithReuseIdentifier: BQSTSimpleCollectionCell.identifier())
        collectionView.registerClass(BQSTResponseCell.self,
            forCellWithReuseIdentifier: BQSTResponseCell.identifier())
        
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
    
    func toggleHeaders() {
        self.dataSource.toggleSectionAtIndex(0)
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
        
        dataSource.collectionSupplementaryConfigureBlock = { (v, kind, collectionView, indexPath) in
            let view = v as BQSTCollectionHeaderFooterView
            
            view.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            
            if indexPath.section == 0 {
                view.button?.setTitle("Headers (\(self.dataSource.numberOfItemsInSection(0) / 2))", forState:.Normal)
                view.button?.addTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        dataSource.cellConfigureBlock = { (cell, item, collectionView, indexPath) in
            switch indexPath.section {
            case 0:
                (cell as BQSTSimpleCollectionCell).label!.textAlignment = (indexPath.row % 2 == 0
                    ? .Right
                    : .Left)
                (cell as BQSTSimpleCollectionCell).label!.textColor = (indexPath.row % 2 == 0
                    ? UIColor.BQSTGrayColor()
                    : UIColor.BQSTRedColor())
                (cell as BQSTSimpleCollectionCell).label!.text = item as? String
            case 1:
                (cell as BQSTResponseCell).configureWithResponse(self.parsedResponse)
            default:
                break
            }
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
        
        // Response object
        dataSource.appendSection(SSSection(numberOfItems: 1))
        
        dataSource.collectionView = collectionView
    }
    
    /// MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            
            if indexPath.section == 1 {
                switch self.parsedResponse.contentType! {
                case .JPEG, .GIF, .PNG:
                    
                    let imageInfo = JTSImageInfo()
                    imageInfo.image = self.parsedResponse.object as UIImage
                    imageInfo.referenceView = collectionView
                    imageInfo.referenceContentMode = .ScaleAspectFit
                    
                    let imageViewController = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
                    
                    imageViewController.showFromViewController(self, transition: ._FromOffscreen)
                    
                default:
                    break
                }
            }
    }
    
    /// MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
            if section == 0 {
                return CGSizeMake(0, 44)
            }
            
            return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
            switch section {
            case 0:
                return UIEdgeInsetsZero
            default:
                return UIEdgeInsetsMake(20, 0, 20, 0)
            }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {

            return 0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            if indexPath.section == 0 {
                
                let cellWidth = CGRectGetWidth(collectionView.frame) / 2
                
                func sizeText(text: String) -> CGFloat {
                    let rect = text.boundingRectWithSize(CGSizeMake(cellWidth - kBQSTSimpleCellInsets.left - kBQSTSimpleCellInsets.right, CGFloat.max),
                        options: .UsesLineFragmentOrigin,
                        attributes: [NSFontAttributeName: UIFont.BQSTHTTPHeaderFont()],
                        context: nil)
                    
                    return ceil(CGRectGetHeight(rect) + kBQSTSimpleCellInsets.bottom + kBQSTSimpleCellInsets.top)
                }
                
                let text = dataSource.itemAtIndexPath(indexPath) as NSString
                let otherText = dataSource.itemAtIndexPath(NSIndexPath(forItem:(indexPath.row % 2 == 0
                    ? indexPath.row + 1
                    : indexPath.row - 1), inSection:indexPath.section)) as NSString
                
                return CGSizeMake(cellWidth, max(sizeText(text), sizeText(otherText)))
            }
            
            switch self.parsedResponse.contentType! {
            case .GIF, .JPEG, .PNG:
                let size = (self.parsedResponse.object as UIImage).size
                return CGSizeMake(min(size.width, CGRectGetWidth(collectionView.frame)), min(size.height, 100))
                
            case .HTML:
                return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame) - 90)
            default:
                return CGSizeZero
            }
    }
}
