//
//  BQSTRequestManager.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

private let _sharedManager = BQSTRequestManager()
private let kBQSTDefaultURL = NSURL(string: "http://splinesoft.net")!

extension BQSTRequestRow {
    static func rowFromTextField(textField : UITextField) -> BQSTRequestRow {
        if let row = BQSTRequestRow(rawValue: textField.tag) {
            return row
        }
        
        return .NumRows // not a great default value
    }
}

class BQSTRequestManager : NSObject, UITextFieldDelegate {
    
    private let mutableRequest : NSMutableURLRequest = NSMutableURLRequest(URL: kBQSTDefaultURL,
        cachePolicy: .ReloadIgnoringLocalCacheData,
        timeoutInterval: 30)
    
    internal var currentRequest : NSURLRequest {
        get {
            return mutableRequest.copy() as! NSURLRequest
        }
    }
    
    class var sharedManager : BQSTRequestManager! {
        return _sharedManager
    }
    
    func valueForRow(row: BQSTRequestRow) -> String? {
        switch row {
        case .URL:
            return mutableRequest.URL?.absoluteString ?? kBQSTDefaultURL.absoluteString
        case .Method:
            return mutableRequest.HTTPMethod ?? "GET"
        default:
            break
        }
        
        return nil
    }
    
    /// MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        let text = textField.text
        
        switch (BQSTRequestRow.rowFromTextField(textField)) {
        case .URL:
            mutableRequest.URL = NSURL(string: text)
        case .Method:
            mutableRequest.HTTPMethod = text
        default:
            break
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}
