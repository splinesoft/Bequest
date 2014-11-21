//
//  BequestTests.swift
//  BequestTests
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import UIKit
import XCTest
import Quick
import Nimble

class BequestTests : QuickSpec {
    
    override func spec() {
        describe("an HTTP client") {
            it("is initializable") {
                let client = BQSTHTTPClient()
                expect(client).toNot(beNil())
            }
        }
    }
}
