//
//  NSData+BQSTAdditions.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/24/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation

extension NSStringEncoding {
    
    static func stringEncodingFromCharset(charset: String) -> NSStringEncoding? {
        let charString = NSMutableString(string: charset.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        charString.replaceOccurrencesOfString("charset=",
            withString: "",
            options: .CaseInsensitiveSearch,
            range: NSMakeRange(0, charString.length))
        
        switch charString {
        case "utf-8":
            return NSUTF8StringEncoding
        case "ascii":
            return NSASCIIStringEncoding
        case "iso-8859-1":
            return NSISOLatin1StringEncoding
        default:
            return nil
        }
    }
}

extension NSData {
    
    func BQSTStringByGuessingEncoding() -> NSString? {
        var convertedString: NSString?
        var usedLossy: ObjCBool = false
        let encodingOptions = [
            NSStringEncodingDetectionSuggestedEncodingsKey : [NSUTF8StringEncoding, NSASCIIStringEncoding, NSUTF16StringEncoding]
        ]
        
        let encoding = NSString.stringEncodingForData(self,
            encodingOptions: encodingOptions,
            convertedString: &convertedString,
            usedLossyConversion: &usedLossy)
        
        return convertedString
    }

    func BQSTString(#contentType: String?) -> String {
        var string: NSString?
        
        if let contentTypeComponents = contentType?.componentsSeparatedByString(";") {
            if contentTypeComponents.count > 1 {
                var charset = contentTypeComponents[1]
                if let parsedEncoding = NSStringEncoding.stringEncodingFromCharset(charset) {
                    string = NSString(data: self, encoding: parsedEncoding)
                }
            }
        }
        
        if string == nil {
            string = self.BQSTStringByGuessingEncoding()
        }
        
        return string ?? ""
    }
    
}
