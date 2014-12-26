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
    
    private func setUpRequest(url: String, method: String) {
        tester().clearTextFromAndThenEnterText(url, intoViewWithAccessibilityLabel: "URL")
        tester().clearTextFromAndThenEnterText(method, intoViewWithAccessibilityLabel: "Method")
    }
    
    override func beforeAll() {
        super.beforeAll()
        KIFTestActor.setDefaultTimeout(20)
    }
    
    override func afterAll() {
        super.afterAll()
    }
    
    func testEmptyMethod() {
        self.setUpRequest("http://splinesoft.net", method: "")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().tapViewWithAccessibilityLabel("Darn")
    }
    
    func testEmptyURL() {
        self.setUpRequest("", method: "GET")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().tapViewWithAccessibilityLabel("Darn")
    }
    
    func testSimpleRequest() {
        self.setUpRequest("http://httpbin.org/get", method: "GET")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testCustomURLAndMethod() {
        self.setUpRequest("http://httpbin.org/post", method: "POST")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testCustomURLAndInvalidMethod() {
        self.setUpRequest("http://httpbin.org/post", method: "NOT-POST")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [405]")
        tester().tapViewWithAccessibilityLabel("Back")
    }
    
    func testRefreshingResponse() {
        self.setUpRequest("https://google.com", method: "GET")
        tester().tapViewWithAccessibilityLabel("Send")
        tester().waitForViewWithAccessibilityLabel("Response [200]")
        tester().swipeViewWithAccessibilityLabel("Response", inDirection: .Down)
        tester().swipeViewWithAccessibilityLabel("Response", inDirection: .Down)
        tester().waitForAbsenceOfViewWithAccessibilityLabel("Refresh")
        tester().tapViewWithAccessibilityLabel("Back")
    }
}
