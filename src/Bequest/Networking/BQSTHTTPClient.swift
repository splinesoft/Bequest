//
//  BQSTHTTPClient.swift
//  Bequest
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import Alamofire

public typealias BQSTResponseBlock = (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void

public class BQSTHTTPClient {
    
    public class func requestForURL(url : NSURL,
        method      : String,
        headers     : [NSObject : AnyObject],
        parameters  : [String:String]) -> NSURLRequest {
            
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    public class func request(url : NSURL, _ response : BQSTResponseBlock) {
        
        self.request(url, method: nil, headers: nil, parameters: nil, response)
    }
    
    public class func request(url : NSURL, method : String, _ response : BQSTResponseBlock) {
        
        self.request(url, method: method, headers: nil, parameters: nil, response)
    }
    
    public class func request(url: NSURL,
        method: String?,
        headers: [String:String]?,
        parameters: [String:String]?,
        _ response : BQSTResponseBlock) {
            
        let URLRequest = self.requestForURL(url, method: method ?? "GET", headers: headers ?? [:], parameters: parameters ?? [:])
        
        Alamofire.request(URLRequest).response(response)
    }
    
}
