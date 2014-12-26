//
//  String+BQSTAdditions.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/26/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation

func BQSTLocalizedString(key: String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
}
