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
public typealias BQSTJSONResponse = [NSObject:AnyObject]

// More than we'll ever know what to do with https://en.wikipedia.org/wiki/Internet_media_type
public enum BQSTResponseContentType : String {
    // Applications
    case JSON = "application/json"
    case XML  = "application/xml"
    case ZIP  = "application/zip"
    case GZIP = "application/gzip"
    
    // Images
    case GIF  = "image/gif"
    case JPEG = "image/jpeg"
    case PNG  = "image/png"
    
    // Text
    case TXT  = "text/plain"
    case HTML = "text/html"
}

public enum BQSTJSONResult {
    case Success (BQSTJSONResponse)
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
        headers     : [NSObject:AnyObject] = [:],
        parameters  : [String:String] = [:]) -> NSURLRequest {
            
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
            
        // ...
        
        return request
    }
    
    // MARK: Response serializing
    
    public class func serializeResponse(response: NSHTTPURLResponse?, data: NSData) -> AnyObject? {
        
        if let headers = response?.allHeaderFields {
            
            if let contentTypeRaw = headers["Content-Type"] as? String {
                
                // e.g. Content-Type: "application/json; charset=ISO-8859-1"
                let contentTypeComponents = contentTypeRaw.componentsSeparatedByString(";")
                
                if let contentType = BQSTResponseContentType(rawValue: contentTypeComponents.first as String!) {
                
                    switch contentType {
                    case .JSON:
                        let JSONObject = BQSTJSONResult.JSONObjectForData(data, options: nil)
                        
                        switch JSONObject {
                        case .Success(let dict):
                            return dict
                        default:
                            break
                        }
                    case .XML:
    //                    let XMLParser = NSXMLParser(data: data)
    //                    
    //                    if XMLParser.parse() {
    //                        
    //                    }
                        
                        break
                    case .GIF, .PNG, .JPEG:
                        
                        if let image = UIImage(data: data) {
                            return image
                        }
                        
                    default:
                        return NSString(data: data, encoding: NSUTF8StringEncoding)
                    }
                }
            }
        }
        
        return data
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
            
        request.response { (request, URLResponse : NSHTTPURLResponse?, object: AnyObject?, error: NSError?) in
            
            if let data = object as? NSData {
                response(URLRequest,
                    URLResponse,
                    self.serializeResponse(URLResponse, data: data),
                    error)
            } else {
                response(URLRequest, URLResponse, nil, error)
            }
        }
    }
}
