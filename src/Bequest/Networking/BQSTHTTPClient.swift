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

public enum BQSTJSONResult {
    case Success ([NSObject:AnyObject])
    case Failure (NSError?)
    
    // MARK: JSON serializing
    
    public static func JSONObjectForData(data: NSData, options: NSJSONReadingOptions = .AllowFragments) -> BQSTJSONResult {
        
        var error : NSError?
        var object = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error) as? [NSObject:AnyObject]
        
        if object != nil {
            return .Success(object!)
        } else {
            return .Failure(error)
        }
    }
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
            
        request.response { (_, URLResponse : NSHTTPURLResponse?, object: AnyObject?, error: NSError?) in
            if let data = object as? NSData {
                
                // Try to interpret the result as a JSON object
                let JSON = BQSTJSONResult.JSONObjectForData(data, options: nil)
                
                switch JSON {
                case .Success(let dict):
                    response(URLRequest, URLResponse, dict, nil)
                    return
                default:
                    break
                }
                
                // Try to interpret the result as a String
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    response(URLRequest, URLResponse, string, nil)
                    return
                }
                
                // Base case: we have only a blob of data
                response(URLRequest, URLResponse, data, nil)
            } else {
                response(URLRequest, URLResponse, nil, error)
            }
        }
    }
}
