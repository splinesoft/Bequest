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
import TTTAttributedLabel
import Alamofire

enum BQSTResponseSection: Int {
    case Request
    case RequestHeaders
    case ResponseHeaders
    case Body
    case Unknown
}

class BQSTResponseController : UITableViewController {
    
    private var request : NSURLRequest?
    private var response : NSHTTPURLResponse?
    private var parsedResponse : BQSTHTTPResponse?
    private let dataSource : SSExpandingDataSource = {
        let dataSource = SSExpandingDataSource(items: nil)
        dataSource.removeAllSections()
        dataSource.rowAnimation = .Fade
        dataSource.tableActionBlock = { (action, tableView, indexPath) in
            return false
        }
        
        return dataSource
    }()
    
    convenience init(request: NSURLRequest, response: NSHTTPURLResponse?, parsedResponse: BQSTHTTPResponse) {
        self.init(style: .Plain)
        self.request = request
        self.response = response
        self.parsedResponse = parsedResponse
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = BQSTLocalizedString("RESPONSE")
        
        self.view.backgroundColor = UIColor.blackColor()

        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.accessibilityLabel = BQSTLocalizedString("RESPONSE")
        
        self.tableView.registerClass(BQSTTableHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: BQSTTableHeaderFooterView.identifier())
        
        let refreshControl = UIRefreshControl()
        refreshControl.accessibilityLabel = BQSTLocalizedString("RESPONSE_REFRESH")
        refreshControl.tintColor = UIColor.BQSTRedColor()
        refreshControl.addTarget(self, action: Selector("reloadRequest:"), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
        
        dataSource.cellCreationBlock = { (item, tableView, indexPath) in
            
            switch self.responseSectionAtIndex(indexPath.section) {
            case .Request, .RequestHeaders, .ResponseHeaders:
                return BQSTResponseHeaderCell(forTableView: tableView as UITableView)
            case .Body:
                return BQSTResponseCell(forTableView: tableView as UITableView)
            default:
                return nil // crash
            }
        }
        
        dataSource.collapsedSectionCountBlock = { (section, sectionIndex) in
            
            switch self.responseSectionAtIndex(sectionIndex) {
            case .RequestHeaders, .ResponseHeaders:
                return 3
            default:
                return 0
            }
        }
        
        dataSource.cellConfigureBlock = { (cell, items, collectionView, indexPath) in
            
            switch self.responseSectionAtIndex(indexPath.section) {
            case .RequestHeaders, .ResponseHeaders, .Request:
                (cell as BQSTResponseHeaderCell).configureWithValues(items as [String])
            case .Body:
                (cell as BQSTResponseCell).configureWithResponse(self.parsedResponse!)
            default:
                break
            }
        }
        
        self.refreshFromResponse()
        
        dataSource.tableView = self.tableView
    }
    
    /// MARK: Actions
    
    func toggleHeaders() {
        self.dataSource.toggleSectionAtIndex(Int(self.dataSource.indexOfSectionWithIdentifier(BQSTResponseSection.ResponseHeaders.rawValue)))
    }
    
    func reloadRequest(sender: UIRefreshControl) {
        if self.request == nil {
            sender.endRefreshing()
            return
        }
        
        BQSTHTTPClient.request(self.request!, progress: nil) {
            (request, httpResponse, parsedResponse, error) in
            
            self.request = request
            self.response = httpResponse
            self.parsedResponse = parsedResponse
            self.refreshFromResponse()
            sender.endRefreshing()
        }
    }
    
    /// MARK: Updating from an HTTP response
    
    private func refreshFromResponse() {
        dataSource.removeAllSections()
        dataSource.tableView = nil
        
        if (response?.statusCode != nil) {
            self.title = BQSTLocalizedString("RESPONSE") + " [\(response!.statusCode)]"
        }
        
        // Request details and headers
        if request != nil {
            let requestItems = NSMutableArray()
            requestItems.addObject([BQSTLocalizedString("REQUEST_URL"), self.request!.URL.absoluteString])
            requestItems.addObject([BQSTLocalizedString("REQUEST_METHOD"), self.request!.HTTPMethod ?? "GET"])
            requestItems.addObject([BQSTLocalizedString("REQUEST_TIMEOUT"), self.request!.timeoutInterval.description])
            
            let section = SSSection(items: requestItems)
            section.sectionIdentifier = NSNumber(integer: BQSTResponseSection.Request.rawValue)
            dataSource.appendSection(section)
            
            var requestHeaders: [NSObject:AnyObject] = [:]
            
            if let standardHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders {
                for (key, value) in standardHeaders {
                    requestHeaders[key] = value
                }
            }
            
            if let userHeaders = request!.allHTTPHeaderFields {
                for (key, value) in userHeaders {
                    requestHeaders[key] = value
                }
            }
            
            if requestHeaders.count > 0 {
                let sortedNames: [NSObject] = (requestHeaders.keys.array.sorted {
                    return ($0 as String) < ($1 as String)
                })
                
                var headerItems = NSMutableArray()
                
                for header in sortedNames {
                    headerItems.addObject([header, requestHeaders[header]!])
                }

                let headerSection = SSSection(items: headerItems)
                headerSection.sectionIdentifier = NSNumber(integer: BQSTResponseSection.RequestHeaders.rawValue)
                dataSource.appendSection(headerSection)
            }
        }
        
        // Response Headers
        if let responseHeaders = response?.allHeaderFields {
            if responseHeaders.count > 0 {
                let sortedNames: [NSObject] = (responseHeaders.keys.array.sorted {
                    return ($0 as String) < ($1 as String)
                })
                
                var headers = NSMutableArray()
                
                for key in sortedNames {
                    headers.addObject([key, responseHeaders[key]!])
                }
                
                let section = SSSection(items: headers)
                section.sectionIdentifier = NSNumber(integer: BQSTResponseSection.ResponseHeaders.rawValue)
                dataSource.appendSection(section)
            }
        }
        
        // Response object
        if parsedResponse != nil {
            
            let addBodySection: () -> () = {
                let bodySection = SSSection(numberOfItems: 1, header: nil, footer: nil, identifier: BQSTResponseSection.Body.rawValue)
                self.dataSource.appendSection(bodySection)
            }
            
            switch parsedResponse!.contentType {
            case .JSON, .HTML, .TXT:
                let str = parsedResponse?.object as? String
                
                if str != nil && countElements(str!) > 0 {
                    addBodySection()
                }
            default:
                addBodySection()
            }
        }
        
        dataSource.tableView = self.tableView
        self.dataSource.reloadData()
    }
    
    /// MARK: UITableViewDelegate
    
    private func responseSectionAtIndex(index: Int) -> BQSTResponseSection {
        return BQSTResponseSection(rawValue: self.dataSource.sectionAtIndex(index).sectionIdentifier.integerValue) ?? .Unknown
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch self.responseSectionAtIndex(section) {
        case .RequestHeaders, .ResponseHeaders, .Request:
            return 32
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch self.responseSectionAtIndex(section) {
        case .ResponseHeaders:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BQSTTableHeaderFooterView.identifier()) as BQSTTableHeaderFooterView
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            header.button?.setTitle(BQSTLocalizedString("RESPONSE_HEADERS") +
                " (\(self.dataSource.numberOfItemsInSection(section)))", forState:.Normal)
            header.button?.addTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            
            return header
        case .Request:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BQSTTableHeaderFooterView.identifier()) as BQSTTableHeaderFooterView
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: .TouchUpInside)
            header.button?.setTitle(BQSTLocalizedString("REQUEST"), forState: .Normal)
            
            return header
        case .RequestHeaders:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BQSTTableHeaderFooterView.identifier()) as BQSTTableHeaderFooterView
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: .TouchUpInside)
            header.button?.setTitle(BQSTLocalizedString("REQUEST_HEADERS") +
                " (\(self.dataSource.numberOfItemsInSection(section)))", forState: .Normal)
            
            return header
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch self.responseSectionAtIndex(indexPath.section) {
        case .RequestHeaders, .ResponseHeaders, .Request:
            let items = self.dataSource.itemAtIndexPath(indexPath) as [String]
            return BQSTResponseHeaderCell.heightForValues(items, availableWidth: CGRectGetWidth(tableView.frame))
        case .Body:
            return BQSTResponseCell.heightForResponse(self.parsedResponse!, availableWidth: CGRectGetWidth(tableView.frame))
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch self.responseSectionAtIndex(indexPath.section) {
        case .ResponseHeaders, .RequestHeaders, .Request:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case .Body:
            switch self.parsedResponse!.contentType {
            case .JPEG, .GIF, .PNG:
                
                let imageInfo = JTSImageInfo()
                imageInfo.image = self.parsedResponse!.object as UIImage
                imageInfo.referenceView = tableView
                imageInfo.referenceContentMode = .ScaleAspectFit
                
                let imageViewController = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
                
                imageViewController.showFromViewController(self, transition: ._FromOffscreen)
                
            default:
                break
            }
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch self.responseSectionAtIndex(indexPath.section) {
        case .ResponseHeaders, .RequestHeaders, .Request:
            return true
        default:
            return false
        }
    }
    
    override func tableView(tableView: UITableView,
        canPerformAction action: Selector,
        forRowAtIndexPath indexPath: NSIndexPath,
        withSender sender: AnyObject) -> Bool {
            
        switch self.responseSectionAtIndex(indexPath.section) {
        case .ResponseHeaders, .RequestHeaders, .Request:
            return NSStringFromSelector(action) == "copy:"
        default:
            return false
        }
    }
    
    override func tableView(tableView: UITableView,
        performAction action: Selector,
        forRowAtIndexPath indexPath: NSIndexPath,
        withSender sender: AnyObject!) {
            
        switch self.responseSectionAtIndex(indexPath.section) {
        case .ResponseHeaders, .RequestHeaders, .Request:
            let item = self.dataSource.itemAtIndexPath(indexPath) as [String]
            UIPasteboard.generalPasteboard().string = String(format: "%@: %@", item[0], item[1])
        default:
            break
        }
    }
}
