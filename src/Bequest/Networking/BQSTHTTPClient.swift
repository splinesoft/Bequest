//
//  BQSTHTTPClient.swift
//  Bequest
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import Alamofire

public typealias BQSTProgressBlock = (NSURLRequest, Float) -> Void
public typealias BQSTResponseBlock = (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void

public struct BQSTJSONResult {
    let JSONObject : AnyObject?
    let error : NSError?
}

public class BQSTHTTPClient {
    
    // MARK: NSURLRequest helpers
    
    public class func requestForURL(url : NSURL,
        method      : String = "GET",
        headers     : [NSObject : AnyObject] = [:],
        parameters  : [String:String] = [:]) -> NSURLRequest {
            
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    // MARK: JSON serializing
    
    public class func JSONObjectForData(data: NSData, options: NSJSONReadingOptions = .AllowFragments) -> BQSTJSONResult {
        
        var error : NSError?
        var object : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error)
        
        return BQSTJSONResult(JSONObject: object, error: error)
    }
    
    // MARK: HTTP Requests
    
    public class func request(url : NSURL, _ response : BQSTResponseBlock) {
        
        self.request(url, method: nil, headers: nil, parameters: nil, progress: nil, response)
    }
    
    public class func request(url : NSURL, method : Alamofire.Method, _ response : BQSTResponseBlock) {
        
        self.request(url, method: method.rawValue, headers: nil, parameters: nil, progress: nil, response)
    }
    
    public class func request(url: NSURL,
        method: String?,
        headers: [NSObject:AnyObject]?,
        parameters: [String:String]?,
        progress: BQSTProgressBlock?,
        _ response : BQSTResponseBlock) {
            
        let URLRequest = self.requestForURL(url, method: method ?? "GET", headers: headers ?? [:], parameters: parameters ?? [:])
        
        let request : Alamofire.Request = Alamofire.request(URLRequest)
            
        request.progress(closure: { (_, total, expected) in
            progress?(URLRequest, Float(total) / (Float(expected) ?? Float(1)))
            return
        })
            
        request.response(response)
    }
}
