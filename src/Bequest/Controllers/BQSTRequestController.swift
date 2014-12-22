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

    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.registerClass(BQSTCollectionValueCell.self,
            forCellWithReuseIdentifier: BQSTCollectionValueCell.identifier())
        cv.keyboardDismissMode = .Interactive
        
        return cv
    }()
    
    private let dataSource : SSSectionedDataSource = {
        let section = SSSection(numberOfItems: UInt(BQSTRequestRow.NumRows.rawValue))
        let dataSource = SSSectionedDataSource(section: section)
        
        dataSource.rowAnimation = .Fade
        
        dataSource.cellCreationBlock = { (value, collectionView, indexPath) in
            return BQSTCollectionValueCell.self(forCollectionView: collectionView as UICollectionView,
                indexPath: indexPath as NSIndexPath)
        }
        
        return dataSource
    }()
    
    private let progressButton: BQSTProgressButton = {
        let button = BQSTProgressButton(frame: CGRectMake(0, 0, 44, 44))
        button.progressState = .Ready
        return button
    }()

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.progressButton.progressState = .Ready
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.title = UIApplication.BQSTApplicationName()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressButton)
        progressButton.addTarget(self, action: Selector("sendRequest"), forControlEvents: .TouchUpInside)
        
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

        collectionView.frame = self.view.frame
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        
        dataSource.collectionView = collectionView
    }
    
    /// MARK: Sending Requests
    
    func sendRequest() {
        
        if self.progressButton.progressState == .Loading {
            self.progressButton.progressState = .Ready
            return
        }
        
        self.view.endEditing(true)
        
        let request = BQSTRequestManager.sharedManager.currentRequest
        
        println("Sending a request of type \(request.HTTPMethod!) to URL \(request.URL)")
        
        self.progressButton.progressPercentage = 0
        self.progressButton.progressState = .Loading
        
        let progressBlock: BQSTProgressBlock = { (_, progress: NSProgress) in
            self.progressButton.progressPercentage = progress.fractionCompleted
        }
        
        BQSTHTTPClient.request(request, progress: progressBlock) {
            (request: NSURLRequest, response: NSHTTPURLResponse?, parsedResponse: BQSTHTTPResponse?, error: NSError?) in
            
            if let httpResponse = parsedResponse {
                println("response received: \(response!.statusCode)")
                self.progressButton.progressState = .Complete
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
