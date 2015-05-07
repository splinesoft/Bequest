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

class BQSTRequestController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var currentRequest: BQSTRequest?

    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.registerClass(BQSTTextFieldCollectionCell.self,
            forCellWithReuseIdentifier: BQSTTextFieldCollectionCell.identifier())
        cv.registerClass(BQSTHTTPMethodCell.self, forCellWithReuseIdentifier: BQSTHTTPMethodCell.identifier())
        cv.keyboardDismissMode = .Interactive
        
        return cv
    }()
    
    private let dataSource : SSSectionedDataSource = {
        let section = SSSection(numberOfItems: UInt(BQSTRequestRow.NumRows.rawValue))
        let dataSource = SSSectionedDataSource(section: section)
        
        dataSource.rowAnimation = .Fade
        
        dataSource.cellCreationBlock = { value, collectionView, indexPath in
            
            if let row = BQSTRequestRow(rawValue: indexPath.row) {
                if row == .Method {
                    return BQSTHTTPMethodCell(forCollectionView: collectionView as! UICollectionView, indexPath: indexPath as NSIndexPath)
                } else {
                    return BQSTTextFieldCollectionCell(forCollectionView: collectionView as! UICollectionView,
                        indexPath: indexPath as NSIndexPath)
                }
            }
            
            return BQSTTextFieldCollectionCell(forCollectionView: collectionView as! UICollectionView,
                indexPath: indexPath as NSIndexPath)
        }
        
        return dataSource
    }()
    
    private let progressButton: BQSTProgressButton = BQSTProgressButton(frame: CGRectMake(0, 0, 45, 45))

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
        
        dataSource.cellConfigureBlock = { (c, _, collectionView, indexPath) in
            
            if let row = BQSTRequestRow(rawValue: indexPath.row) {
                
                switch row {
                case .Method:
                    
                    let cell = c as! BQSTHTTPMethodCell
                    
                    cell.label.text = BQSTLocalizedString("REQUEST_METHOD")
                    cell.accessibilityLabel = BQSTLocalizedString("REQUEST_METHOD")
                    cell.method = BQSTRequestManager.sharedManager.valueForRow(row) ?? "GET"
                                        
                    cell.changeBlock = { (newType: String) in
                        BQSTRequestManager.sharedManager.mutableRequest.HTTPMethod = newType
                    }
                
                case .URL:
                    
                    let cell = c as! BQSTTextFieldCollectionCell
                    
                    cell.textField.tag = indexPath.row
                    cell.textField.keyboardType = .Default
                    cell.textField.accessibilityLabel = BQSTLocalizedString("REQUEST_URL")
                    cell.textField.keyboardType = .URL
                    cell.textField.delegate = BQSTRequestManager.sharedManager
                    cell.textField.text = BQSTRequestManager.sharedManager.valueForRow(row)
                
                    cell.label.text = BQSTLocalizedString("REQUEST_URL")
                    
                default:
                    break
                }
            }
        }

        collectionView.delegate = self
        self.view.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        dataSource.collectionView = collectionView
    }
    
    /// MARK: Sending Requests
    
    func sendRequest() {
        
        switch self.progressButton.progressState {
            
        case .Loading, .Unknown, .Complete:
            self.progressButton.progressState = .Ready
            self.currentRequest?.cancel()
            return
        default:
            break
        }
        
        self.view.endEditing(true)
        
        let request: NSURLRequest = BQSTRequestManager.sharedManager.currentRequest
        
        if count(request.URL!.absoluteString!) == 0 {
            self.BQSTShowSimpleErrorAlert(BQSTLocalizedString("REQUEST_URL_MISSING"),
                message: BQSTLocalizedString("REQUEST_URL_MISSING_DETAIL"))
            return
        }
        
        if request.HTTPMethod == nil || count(request.HTTPMethod!) == 0 {
            self.BQSTShowSimpleErrorAlert(BQSTLocalizedString("REQUEST_METHOD_MISSING"),
                message: BQSTLocalizedString("REQUEST_METHOD_MISSING_DETAIL"))
            return
        }
        
        println("Sending a request of type \(request.HTTPMethod!) to URL \(request.URL!)")
        
        self.progressButton.progressPercentage = 0
        self.progressButton.progressState = .Loading
        
        let progressBlock: BQSTProgressBlock = { (_, progress: NSProgress) in
            dispatch_async(dispatch_get_main_queue()) {
                self.progressButton.progressPercentage = Float(progress.fractionCompleted)
            }
        }

        let responseBlock: BQSTResponseBlock = {
            (request: NSURLRequest,
            response: NSHTTPURLResponse?,
            parsedResponse: BQSTHTTPResponse?,
            error: NSError?) in
            
            if error?.code == NSURLErrorCancelled {
                return
            }
            
            self.progressButton.progressState = .Complete
            
            let failure: (error: NSError?) -> (Void) = {
                error in
                self.progressButton.progressState = .Ready
                self.BQSTShowSimpleErrorAlert(BQSTLocalizedString("REQUEST_FAILED"), error: error)
            }
            
            if let httpResponse = parsedResponse {
                
                if response == nil {
                    failure(error: error)
                    return
                }
                
                let responseController = BQSTResponseController(request: request, response: response, parsedResponse: httpResponse)
                
                dispatch_after(
                    dispatch_time(
                        DISPATCH_TIME_NOW,
                        Int64(0.15 * Double(NSEC_PER_SEC))
                    ),
                    dispatch_get_main_queue(), {
                        self.navigationController!.pushViewController(responseController, animated: true)
                })
            } else {
                failure(error: error)
            }
        }
        
        self.currentRequest = BQSTHTTPClient.request(request, progress: progressBlock, responseBlock)
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
            case .URL, .Method:
                return fullWidth
            default:
                return halfWidth
            }
        }
        
        return CGSizeZero
    }
}
