//
//  BQSTHTTPResponse.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/24/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

// MARK: JSON serializing

public typealias BQSTJSONResponse = [NSObject:AnyObject]

public enum BQSTJSONResult {
    case Success (BQSTJSONResponse)
    case Failure (NSError?)
    
    public static func resultForData(data: NSData, options: NSJSONReadingOptions = .AllowFragments) -> BQSTJSONResult {
        
        var error: NSError?
        var object = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error) as? BQSTJSONResponse
        
        if object != nil {
            return .Success(object!)
        } else {
            return .Failure(error)
        }
    }
}

// MARK: Response serializing

public let BQSTHeaderContentType: String = "Content-Type"

// More than we'll ever know what to do with: https://en.wikipedia.org/wiki/Internet_media_type
public enum BQSTResponseContentType: String {
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
    
    // Som
    case Unknown = "net.splinesoft.Unknown"
    
    public var description: String {
        return self.rawValue
    }
}

public struct BQSTHTTPResponse {
    var contentType: BQSTResponseContentType // The interpreted content type
    var object: AnyObject // The serialized object, or raw NSData if serializing failed
    
    public static func serializeResponse(response: NSHTTPURLResponse?, data: NSData) -> BQSTHTTPResponse {
        var serializedResponse = BQSTHTTPResponse(contentType: .Unknown, object: data)
        
        if let headers = response?.allHeaderFields {
            
            if let contentTypeRaw = headers[BQSTHeaderContentType] as? String {
                
                // e.g. Content-Type: "application/json; charset=ISO-8859-1"
                let contentTypeComponents = contentTypeRaw.componentsSeparatedByString(";")
                
                if let contentType = BQSTResponseContentType(rawValue: contentTypeComponents.first as String!) {
                    
                    serializedResponse.contentType = contentType
                    
                    println("content-type: \(contentTypeRaw)")
                    
                    switch contentType {
                    case .JSON:
                        let JSONObject = BQSTJSONResult.resultForData(data, options: .AllowFragments)
                        
                        switch JSONObject {
                        case .Success(let dict):
                            serializedResponse.object = dict
                        default:
                            break
                        }
                        
                    case .XML:
                        
                        break
                        
                    case .GIF, .PNG, .JPEG:
                        
                        if let image = UIImage(data: data) {
                            serializedResponse.object = image
                        }
                        
                    case .TXT, .HTML:
                        
                        serializedResponse.object = data.BQSTString(contentType: contentTypeRaw)
                        
                    default:
                        
                        break
                    }
                }
            }
        }
        
        return serializedResponse
    }
}
