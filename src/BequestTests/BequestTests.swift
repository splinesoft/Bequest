//
//  BequestTests.swift
//  BequestTests
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import UIKit
import XCTest

class BequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHTTPClientInitializable() {
        let client = BQSTHTTPClient()
        XCTAssertNotNil(client, "HTTP Client should initialize")
    }
    
}
