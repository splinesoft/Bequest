//
//  BQSTResponseCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import SSDataSources
import WebKit

class BQSTResponseCell : SSBaseTableCell {
    
    private let webView: WKWebView = {
        return WKWebView(frame: CGRectZero, configuration: WKWebViewConfiguration())
    }()
    
    private let textView: BQSTHTMLTextView = {
        let tv = BQSTHTMLTextView(frame: CGRectZero)
        tv.defaultFont = UIFont.BQSTRawResponseFont()
        tv.editable = false
        return tv
    }()
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(frame: CGRectZero)
        sc.tintColor = UIColor.BQSTRedColor()
        sc.apportionsSegmentWidthsByContent = false
        return sc
    }()
    
    private var response: BQSTHTTPResponse?
    
    override func configureCell() {
        super.configureCell()
        
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        self.segmentControl.addTarget(self, action: Selector("segmentControlChanged:"), forControlEvents: .ValueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.response != nil {
            switch self.response!.contentType {
            case .GIF, .PNG, .JPEG:
                self.imageView?.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(4, 4, 4, 4))
            case .HTML:
                self.segmentControl.frame = CGRectMake(floor((CGRectGetWidth(self.contentView.frame) - 150) / 2),
                    4, 150, 30)
                let contentRect = CGRectMake(0, 44,
                    CGRectGetWidth(self.contentView.frame),
                    CGRectGetHeight(self.contentView.frame) - 44)
                
                self.textView.frame = contentRect
                self.webView.frame = contentRect
            case .JSON, .TXT, .XML:
                self.textView.frame = self.contentView.bounds
            default:
                break;
            }
        }
    }
    
    func segmentControlChanged(segmentControl: UISegmentedControl) {
        switch response!.contentType {
        case .HTML:
            if segmentControl.selectedSegmentIndex == 0 {
                self.webView.removeFromSuperview()
                self.contentView.addSubview(self.textView)
            } else {
                self.textView.removeFromSuperview()
                self.contentView.addSubview(self.webView)
            }
        default:
            break
        }
            
        self.setNeedsLayout()
    }
    
    func configureWithResponse(response: BQSTHTTPResponse) {
        self.response = response
        
        self.webView.removeFromSuperview()
        self.segmentControl.removeFromSuperview()
        self.textView.removeFromSuperview()
        
        switch response.contentType {
        case .GIF, .PNG, .JPEG:
            
            self.imageView?.contentMode = .ScaleAspectFit
            self.imageView?.image = response.object as? UIImage
            
        case .HTML:
            
            self.segmentControl.removeAllSegments()
            self.segmentControl.insertSegmentWithTitle(BQSTLocalizedString("RESPONSE_RAW"), atIndex: 0, animated: false)
            self.segmentControl.insertSegmentWithTitle(BQSTLocalizedString("RESPONSE_PREVIEW"), atIndex: 1, animated: false)
            self.segmentControl.selectedSegmentIndex = 0
            
            self.contentView.addSubview(self.segmentControl)
            self.contentView.addSubview(self.textView)
            
            textView.text = response.object as String
            textView.contentOffset = CGPointZero
            webView.loadHTMLString(response.object as String, baseURL: nil)
            
        case .JSON, .TXT, .XML:
            
            self.contentView.addSubview(self.textView)
            
            textView.text = response.object.description
            textView.contentOffset = CGPointZero
            
        default:
            break
        }
        
        self.setNeedsLayout()
    }
}
