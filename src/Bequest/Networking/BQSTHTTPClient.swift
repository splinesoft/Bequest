//
//  BQSTHTTPClient.swift
//  Bequest
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import Alamofire

public typealias BQSTProgressBlock = (NSURLRequest, NSProgress) -> Void
public typealias BQSTResponseBlock = (NSURLRequest, NSHTTPURLResponse?, BQSTHTTPResponse?, NSError?) -> Void

// MARK: HTTP Client

public typealias BQSTRequest = Alamofire.Request

public class BQSTHTTPClient {
    
    // MARK: HTTP Requests
    
    class func request(url: NSURL, _ response: BQSTResponseBlock) -> BQSTRequest {
        
        return self.request(url, method: nil, headers: nil, parameters: nil, progress: nil, response)
    }
    
    class func request(url: NSURL, method: Alamofire.Method, _ response: BQSTResponseBlock) -> BQSTRequest {
        
        return self.request(url, method: method.rawValue, headers: nil, parameters: nil, progress: nil, response)
    }
    
    class func request(url: NSURL,
        method: String?,
        headers: [NSObject:AnyObject]?,
        parameters: [String:String]?,
        progress: BQSTProgressBlock?,
        _ response: BQSTResponseBlock) -> BQSTRequest {
            
        let URLRequest = NSURLRequest.requestForURL(url,
            method: method ?? Alamofire.Method.GET.rawValue,
            headers: headers ?? [:],
            parameters: parameters ?? [:])

        return self.request(URLRequest, progress: progress, response)
    }
    
    class func request(URLRequest: NSURLRequest, progress: BQSTProgressBlock?, _ response: BQSTResponseBlock) -> BQSTRequest {
        
        let request: BQSTRequest = Alamofire.request(URLRequest)
        
        if progress != nil {
            let counter = NSProgress()
            counter.kind = NSProgressFileOperationKindDownloading
            
            request.progress(closure: { (read, completed, expected) in
                
                counter.totalUnitCount = expected
                counter.completedUnitCount = completed
                
                progress!(URLRequest, counter)
                return
            })
        }
        
        request.response {
            (request: NSURLRequest,
            URLResponse: NSHTTPURLResponse?,
            object: AnyObject?,
            error: NSError?) in
            
            if let data = object as? NSData {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    let serializedResponse = BQSTHTTPResponse.serializeResponse(URLResponse, data: data)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        response(request,
                            URLResponse,
                            serializedResponse,
                            error)
                    }
                }
            } else {
                response(URLRequest, URLResponse, nil, error)
            }
        }
        
        return request
    }
}
