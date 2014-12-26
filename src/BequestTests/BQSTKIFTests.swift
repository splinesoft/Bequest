//
//  BQSTKIFTests.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/25/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import XCTest
import KIF

class BQSTKIFTests : KIFTestCase {
    
    private func tester() -> KIFUITestActor {
        return KIFUITestActor(inFile: __FILE__, atLine: __LINE__, delegate: self)
    }
    
    override func beforeAll() {
        super.beforeAll()
        KIFTestActor.setDefaultTimeout(20)
    }
    
    override func afterAll() {
        super.afterAll()
    }
    
    func testDefaultRequest() {
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testCustomURL() {
        tester().clearTextFromAndThenEnterText("http://httpbin.org/get", intoViewWithAccessibilityLabel: "URL")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testCustomURLAndMethod() {
        tester().clearTextFromAndThenEnterText("http://httpbin.org/post", intoViewWithAccessibilityLabel: "URL")
        tester().clearTextFromAndThenEnterText("POST", intoViewWithAccessibilityLabel: "Method")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testCustomURLAndInvalidMethod() {
        tester().clearTextFromAndThenEnterText("http://httpbin.org/post", intoViewWithAccessibilityLabel: "URL")
        tester().clearTextFromAndThenEnterText("NOT-POST", intoViewWithAccessibilityLabel: "Method")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [405]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
}