//
//  BQSTNavigationController.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

class BQSTNavigationController : UINavigationController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.visibleViewController.preferredStatusBarStyle()
    }

    override func shouldAutorotate() -> Bool {
        return self.visibleViewController.shouldAutorotate()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.visibleViewController.supportedInterfaceOrientations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationBar.opaque = false
        self.navigationBar.translucent = true
        self.navigationBar.tintColor = UIColor.BQSTRedColor()
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.BQSTRedColor(),
            NSFontAttributeName : UIFont.BQSTFont(20),
        ]
    }
}
