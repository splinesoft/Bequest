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
        
        let action = UIAlertAction(title: "Darn", style: .Default, handler: nil)
        controller.addAction(action)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
