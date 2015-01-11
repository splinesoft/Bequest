//
//  UIViewController+BQSTAlerts.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/25/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func BQSTShowSimpleErrorAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: BQSTLocalizedString("ALERT_OKAY"), style: .Default, handler: nil)
        controller.addAction(action)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func BQSTShowSimpleErrorAlert(title: String, error: NSError?) {
        println("Request error: \(error)")
        
        let msg: String = (error?.userInfo?[NSUnderlyingErrorKey] as NSError).localizedDescription
            ?? BQSTLocalizedString("REQUEST_RESPONSE_GENERIC_ERROR")
        
        self.BQSTShowSimpleErrorAlert("Request Failed", message: msg)
    }
}
