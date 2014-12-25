//
//  NSURLRequest+Additions.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/24/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation

extension NSURLRequest {
    
    // MARK: NSURLRequest helpers
    
    public class func requestForURL(url: NSURL,
        method: String = "GET",
        headers: [NSObject:AnyObject] = [:],
        parameters: [NSObject:AnyObject] = [:]) -> NSURLRequest {
            
            let request = NSMutableURLRequest(URL: url,
                cachePolicy: .ReloadIgnoringLocalCacheData,
                timeoutInterval: 30)
            
            request.HTTPMethod = method
            request.allHTTPHeaderFields = headers
            
            // ...
            
            return request.copy() as NSURLRequest
    }
}