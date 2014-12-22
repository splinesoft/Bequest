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

enum BQSTRequestSection : Int {
    case Request = 0
    case Response
    
    case NumSections
}

enum BQSTRequestRow : Int {
    case URL = 0
    case Method
    
    case NumRows
}

class BQSTRequestController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    internal var collectionView : UICollectionView?
    let dataSource : SSSectionedDataSource = {
        let section = SSSection(numberOfItems: UInt(BQSTRequestRow.NumRows.rawValue))
        let dataSource = SSSectionedDataSource(section: section)
        
        dataSource.rowAnimation = .Fade
        
        dataSource.cellCreationBlock = { (value, collectionView, indexPath) in
            return BQSTCollectionValueCell.self(forCollectionView: collectionView as UICollectionView,
                indexPath: indexPath as NSIndexPath)
        }
        
        return dataSource
    }()
    
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
        self.title = UIApplication.BQSTApplicationName()
        self.navigationController?.navigationBar.tintColor = UIColor.BQSTRedColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FastForward,
            target: self,
            action: Selector("sendRequest"))
        
        dataSource.cellConfigureBlock = { (c, value, collectionView, indexPath) in
            
            if let row = BQSTRequestRow(rawValue: indexPath.row) {
                
                let cell = c as BQSTCollectionValueCell
                
                cell.textField!.tag = indexPath.row
                cell.textField!.delegate = BQSTRequestManager.sharedManager
                cell.textField!.text = BQSTRequestManager.sharedManager.valueForRow(row)
                
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
        collectionView!.keyboardDismissMode = .Interactive
        
        self.view.addSubview(collectionView!)
        
        dataSource.collectionView = collectionView
    }
    
    /// MARK: Sending Requests
    
    func sendRequest() {
        self.view.endEditing(true)
        
        self.navigationItem.rightBarButtonItem!.enabled = false
        
        let request = BQSTRequestManager.sharedManager.currentRequest
        
        println("Sending a request of type \(request.HTTPMethod!) to URL \(request.URL)")
        
        BQSTHTTPClient.request(request, progress: nil) {
            (request: NSURLRequest, response: NSHTTPURLResponse?, parsedResponse: BQSTHTTPResponse?, error: NSError?) in
            
            self.navigationItem.rightBarButtonItem!.enabled = true
            
            if let httpResponse = parsedResponse {
                println("Received a response of type \(httpResponse.contentType?.description) and object \(httpResponse.object)")
                let responseController = BQSTResponseController(request: request, response: response, parsedResponse: httpResponse)
                self.navigationController!.pushViewController(responseController, animated: true)
            } else {
                let alert = UIAlertView(title: "Request Failed",
                    message: error?.description ?? "Could not parse a response for this request.",
                    delegate: nil,
                    cancelButtonTitle: "Darn")
                
                alert.show()
            }
        }
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
