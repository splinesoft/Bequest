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

class BQSTResponseController : UITableViewController, UITableViewDelegate {
    
    private var request : NSURLRequest?
    private var response : NSHTTPURLResponse?
    private var parsedResponse : BQSTHTTPResponse?
    private let dataSource : SSExpandingDataSource = {
        let dataSource = SSExpandingDataSource(items: nil)
        dataSource.removeAllSections()
        dataSource.rowAnimation = .Fade

        dataSource.cellCreationBlock = { (item, tableView, indexPath) in
            if indexPath.section == 0 {
                return BQSTHeaderCell(forTableView: tableView as UITableView)
            }
            
            return BQSTResponseCell(forTableView: tableView as UITableView)
        }
        
        dataSource.collapsedSectionCountBlock = { (section, sectionIndex) in
            if sectionIndex == 0 {
                return 3
            }
            
            return 0
        }
        
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
    
    func toggleHeaders() {
        self.dataSource.toggleSectionAtIndex(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Response"
        
        self.view.backgroundColor = UIColor.blackColor()

        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        
        self.tableView.registerClass(BQSTTableHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: BQSTTableHeaderFooterView.identifier())
        
        if (response?.statusCode != nil) {
            self.title = self.title! + " (\(response!.statusCode))"
        }
        
        dataSource.cellConfigureBlock = { (cell, items, collectionView, indexPath) in
            switch indexPath.section {
            case 0:
                (cell as BQSTHeaderCell).configureWithValues(items as [String])
            case 1:
                (cell as BQSTResponseCell).configureWithResponse(self.parsedResponse!)
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
                headers.addObject([key, response!.allHeaderFields[key]!])
            }
            
            dataSource.appendSection(SSSection(items: headers))
        }
        
        // Response object
        dataSource.appendSection(SSSection(numberOfItems: 1))
        
        dataSource.tableView = self.tableView
    }
    
    /// MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 44
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let header = BQSTTableHeaderFooterView(reuseIdentifier: BQSTTableHeaderFooterView.identifier())
            
            header.button?.removeTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            header.button?.setTitle("Headers (\(self.dataSource.numberOfItemsInSection(0)))", forState:.Normal)
            header.button?.addTarget(self, action: Selector("toggleHeaders"), forControlEvents: UIControlEvents.TouchUpInside)
            
            return header
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.section == 0 {
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
        }
        
        switch self.parsedResponse!.contentType! {
        case .GIF, .JPEG, .PNG:
            let size = (self.parsedResponse!.object as UIImage).size
            return min(size.height, 100)
        case .HTML:
            return CGRectGetHeight(tableView.frame) - 110
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            switch self.parsedResponse!.contentType! {
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
        }

    }
}
