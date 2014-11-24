//
//  BQSTHTTPClient.swift
//  Bequest
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Response serializing

public let BQSTHeaderContentType: String = "Content-Type"

// More than we'll ever know what to do with: https://en.wikipedia.org/wiki/Internet_media_type
public enum BQSTResponseContentType: String, Printable {
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
    
    public var description: String {
        return self.rawValue
    }
}

public struct BQSTHTTPResponse {
    var contentType: BQSTResponseContentType? // The interpreted content type
    var object: AnyObject // The serialized object, or raw NSData if serializing failed
    
    public static func serializeResponse(response: NSHTTPURLResponse?, data: NSData) -> BQSTHTTPResponse {
        var serializedResponse = BQSTHTTPResponse(contentType: nil, object: data)
        
        if let headers = response?.allHeaderFields {
            
            if let contentTypeRaw = headers[BQSTHeaderContentType] as? String {
                
                // e.g. Content-Type: "application/json; charset=ISO-8859-1"
                let contentTypeComponents = contentTypeRaw.componentsSeparatedByString(";")
                
                if let contentType = BQSTResponseContentType(rawValue: contentTypeComponents.first as String!) {
                    
                    serializedResponse.contentType = contentType
                    
                    switch contentType {
                    case .JSON:
                        let JSONObject = BQSTJSONResult.resultForData(data, options: nil)
                        
                        switch JSONObject {
                        case .Success(let dict):
                            serializedResponse.object = dict
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
                            serializedResponse.object = image
                        }
                        
                    case .TXT, .HTML:
                        
                        // TODO: charset
                        
                        serializedResponse.object = NSString(data: data, encoding: NSUTF8StringEncoding) ?? ""
                        
                    default:
                        
                        break
                    }
                }
            }
        }
        
        return serializedResponse
    }
}

public typealias BQSTProgressBlock = (NSURLRequest, Float) -> Void
public typealias BQSTResponseBlock = (NSURLRequest, NSHTTPURLResponse?, BQSTHTTPResponse?, NSError?) -> Void

// MARK: JSON serializing

public typealias BQSTJSONResponse = [NSObject:AnyObject]

public enum BQSTJSONResult {
    case Success (BQSTJSONResponse)
    case Failure (NSError?)
    
    public static func resultForData(data: NSData, options: NSJSONReadingOptions = .AllowFragments) -> BQSTJSONResult {
        
        var error: NSError?
        var object = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error) as? [NSObject:AnyObject]
        
        if object != nil {
            return .Success(object!)
        } else {
            return .Failure(error)
        }
    }
}

// MARK: HTTP Client

public class BQSTHTTPClient {
    
    // MARK: NSURLRequest helpers
    
    public class func requestForURL(url: NSURL,
        method: String = "GET",
        headers: [NSObject:AnyObject] = [:],
        parameters: [NSObject:AnyObject] = [:]) -> NSURLRequest {
            
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
            
        // ...
        
        return request
    }
    
    // MARK: HTTP Requests
    
    public class func request(url: NSURL, _ response: BQSTResponseBlock) {
        
        self.request(url, method: nil, headers: nil, parameters: nil, progress: nil, response)
    }
    
    public class func request(url: NSURL, method: Alamofire.Method, _ response: BQSTResponseBlock) {
        
        self.request(url, method: method.rawValue, headers: nil, parameters: nil, progress: nil, response)
    }
    
    public class func request(url: NSURL,
        method: String?,
        headers: [NSObject:AnyObject]?,
        parameters: [String:String]?,
        progress: BQSTProgressBlock?,
        _ response: BQSTResponseBlock) {
            
        let URLRequest = self.requestForURL(url,
            method: method ?? Alamofire.Method.GET.rawValue,
            headers: headers ?? [:],
            parameters: parameters ?? [:])
        
        let request: Alamofire.Request = Alamofire.request(URLRequest)
            
        if progress != nil {
            request.progress(closure: { (_, total, expected) in
                
                progress!(URLRequest, Float(total) / (Float(expected) ?? Float(1)))
                return
            })
        }
            
        request.response { (request: NSURLRequest, URLResponse: NSHTTPURLResponse?, object: AnyObject?, error: NSError?) in
            
            if let data = object as? NSData {
                response(request,
                    URLResponse,
                    BQSTHTTPResponse.serializeResponse(URLResponse, data: data),
                    error)
            } else {
                response(URLRequest, URLResponse, nil, error)
            }
        }
    }
}
