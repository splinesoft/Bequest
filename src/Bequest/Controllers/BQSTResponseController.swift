//
//  BQSTResponseController.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

class BQSTResponseController : UIViewController {
    
    private let _request : NSURLRequest
    private let _response : BQSTHTTPResponse
    
    required init(request: NSURLRequest, response: BQSTHTTPResponse) {
        _request = request
        _response = response
        super.init()
    }
    
    /// This crap with default values is just crap
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        _request = NSURLRequest()
        _response = BQSTHTTPResponse(contentType: nil, object: 0)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        _request = NSURLRequest()
        _response = BQSTHTTPResponse(contentType: nil, object: 0)
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Response"
        self.view.backgroundColor = UIColor.blackColor()
    }
}
