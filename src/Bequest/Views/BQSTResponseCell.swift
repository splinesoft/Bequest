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

class BQSTResponseCell : SSBaseCollectionCell {
    
    private var webView: WKWebView?
    private var imageView: UIImageView?
    private var response: BQSTHTTPResponse?
    private var segmentControl: UISegmentedControl?
    private var textView: UITextView?
    
    override func configureCell() {
        super.configureCell()
        
        self.segmentControl = UISegmentedControl()
        self.segmentControl?.tintColor = UIColor.BQSTRedColor()
        self.segmentControl?.apportionsSegmentWidthsByContent = false
        self.segmentControl!.addTarget(self, action: Selector("segmentControlChanged:"), forControlEvents: .ValueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.response != nil {
            switch self.response!.contentType! {
            case .GIF, .PNG, .JPEG:
                self.imageView!.frame = self.contentView.bounds
            case .HTML:
                self.segmentControl!.sizeToFit()
                self.segmentControl!.frame = CGRectMake(floor((CGRectGetWidth(self.contentView.frame) - 150) / 2),
                    4, 150, 30)
                let contentRect = CGRectMake(0, 44,
                    CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 44)
                
                self.textView!.frame = contentRect
                self.webView!.frame = contentRect
            default:
                break;
            }
        }
    }
    
    func segmentControlChanged(segmentControl: UISegmentedControl) {        
        if response!.contentType! == .HTML {
            if segmentControl.selectedSegmentIndex == 0 {
                self.webView?.removeFromSuperview()
                self.contentView.addSubview(self.textView!)
            } else {
                self.textView?.removeFromSuperview()
                self.contentView.addSubview(self.webView!)
            }
            
            self.setNeedsLayout()
        }
    }
    
    func configureWithResponse(response: BQSTHTTPResponse) {
        self.response = response
        
        self.imageView?.removeFromSuperview()
        self.webView?.removeFromSuperview()
        self.segmentControl?.removeFromSuperview()
        self.textView?.removeFromSuperview()
        
        switch response.contentType! {
        case .GIF, .PNG, .JPEG:
            
            if imageView == nil {
                self.imageView = UIImageView(image: response.object as? UIImage)
                self.imageView!.contentMode = .ScaleAspectFit
            } else {
                imageView!.image = response.object as? UIImage
            }
            
            self.contentView.addSubview(self.imageView!)
            
        case .HTML:
            
            self.segmentControl!.removeAllSegments()
            self.segmentControl!.insertSegmentWithTitle("Raw", atIndex: 0, animated: false)
            self.segmentControl!.insertSegmentWithTitle("Preview", atIndex: 1, animated: false)
            self.segmentControl!.selectedSegmentIndex = 0
            
            if webView == nil {
                self.webView = WKWebView(frame: self.contentView.frame,
                    configuration: WKWebViewConfiguration())
            }
            
            if textView == nil {
                self.textView = UITextView(frame: self.contentView.frame)
                self.textView!.font = UIFont.BQSTMonoFont(16)
                self.textView!.textColor = UIColor.BQSTRedColor()
                self.textView!.editable = false
            }
            
            self.contentView.addSubview(self.segmentControl!)
            self.contentView.addSubview(self.textView!)
            self.setNeedsLayout()
            
            textView!.text = response.object as String
            webView!.loadHTMLString(response.object as String, baseURL: nil)
            
        default:
            break
        }
    }
}
