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
    
    override func configureCell() {
        super.configureCell()
        
        self.segmentControl = UISegmentedControl()
        self.segmentControl?.tintColor = UIColor.BQSTRedColor()
        self.segmentControl?.apportionsSegmentWidthsByContent = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.response != nil {
            switch self.response!.contentType! {
            case .GIF, .PNG, .JPEG:
                self.imageView!.frame = self.contentView.bounds
            case .HTML:
                self.webView!.frame = self.contentView.bounds
            default:
                break;
            }
        }
    }
    
    func configureWithResponse(response: BQSTHTTPResponse) {
        self.response = response
        
        self.imageView?.removeFromSuperview()
        self.webView?.removeFromSuperview()
        
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
            
            if webView == nil {
                self.webView = WKWebView(frame: self.contentView.frame,
                    configuration: WKWebViewConfiguration())
            }
            
            self.contentView.addSubview(self.webView!)
            
            webView?.loadHTMLString(response.object as String, baseURL: nil)
            
        default:
            break
        }
    }
}
