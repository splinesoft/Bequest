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
        
        self.title = "Response"
        
        self.view.backgroundColor = UIColor.blackColor()

        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.accessibilityLabel = "Response"
        
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
                return BQSTHeaderCell(forTableView: tableView as UITableView)
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
                (cell as BQSTHeaderCell).configureWithValues(items as [String])
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
        
        BQSTHTTPClient.request(self.request!, progress: nil, {
            (request, httpResponse, parsedResponse, error) in
            
            self.request = request
            self.response = httpResponse
            self.parsedResponse = parsedResponse
            self.refreshFromResponse()
            sender.endRefreshing()
        })
    }
    
    /// MARK: Updating from an HTTP response
    
    private func refreshFromResponse() {
        dataSource.removeAllSections()
        dataSource.tableView = nil
        
        if (response?.statusCode != nil) {
            self.title = "Response [\(response!.statusCode)]"
        }
        
        // Request details and headers
        if request != nil {
            let requestItems = NSMutableArray()
            requestItems.addObject(["URL" as NSString!, self.request!.URL.absoluteString])
            requestItems.addObject(["Method" as NSString!, self.request!.HTTPMethod ?? "GET"])
            requestItems.addObject(["Timeout" as NSString!, self.request!.timeoutInterval.description])
            
            let section = SSSection(items: requestItems)
            section.sectionIdentifier = NSNumber(integer: BQSTResponseSection.Request.rawValue)
            dataSource.appendSection(section)
            
            if let requestHeaders = request!.allHTTPHeaderFields {
                if requestHeaders.count > 0 {
                    let sortedNames: [NSObject] = (requestHeaders.keys.array.sorted {
                        return ($0 as String) < ($1 as String)
                    })
                    
                    var headerItems: [NSObject] = []
                    
                    for header in sortedNames {
                        let value = requestHeaders[header] as String
                        headerItems += [header, value]
                    }
                    
                    let headerSection = SSSection(items: headerItems)
                    headerSection.sectionIdentifier = NSNumber(integer: BQSTResponseSection.RequestHeaders.rawValue)
                    dataSource.appendSection(headerSection)
                }
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
        let bodySection = SSSection(numberOfItems: 1, header: nil, footer: nil, identifier: BQSTResponseSection.Body.rawValue)
        dataSource.appendSection(bodySection)
        
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
            header.button?.setTitle("Response Headers (\(self.dataSource.numberOfItemsInSection(section)))", forState:.Normal)
            header.button?.addTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            
            return header
        case .Request:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BQSTTableHeaderFooterView.identifier()) as BQSTTableHeaderFooterView
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: .TouchUpInside)
            header.button?.setTitle("Request", forState: .Normal)
            
            return header
        case .RequestHeaders:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BQSTTableHeaderFooterView.identifier()) as BQSTTableHeaderFooterView
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: .TouchUpInside)
            header.button?.setTitle("Request Headers (\(self.dataSource.numberOfItemsInSection(section)))", forState: .Normal)
            
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
            let items: [String] = self.dataSource.itemAtIndexPath(indexPath) as [String]!
            
            let cellWidth = CGRectGetWidth(tableView.frame) / 2
            
            func sizeText(text: String) -> CGFloat {
                let attributedString = NSAttributedString.headerAttributedString(text)
                let size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString,
                    withConstraints: CGSizeMake(cellWidth - kBQSTSimpleCellInsets.left - kBQSTSimpleCellInsets.right, CGFloat.max),
                    limitedToNumberOfLines: 0)
                
                return ceil(size.height + kBQSTSimpleCellInsets.bottom + kBQSTSimpleCellInsets.top)
            }
            
            return max(sizeText(items[0]), sizeText(items[1]))
        case .Body:
            switch self.parsedResponse!.contentType {
            case .GIF, .JPEG, .PNG:
                let size = (self.parsedResponse!.object as UIImage).size
                return min(size.height, 100)
            case .HTML:
                return CGRectGetHeight(tableView.frame) - 70
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch self.responseSectionAtIndex(indexPath.section) {
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
}
