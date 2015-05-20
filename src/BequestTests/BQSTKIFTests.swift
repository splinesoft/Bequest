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

class BQSTKIFTests: KIFTestCase {

    private let kBQSTSendKey = BQSTLocalizedString("SEND_REQUEST")
    private let kBQSTAlertKey = BQSTLocalizedString("ALERT_OKAY")

    private var tester: KIFUITestActor {
        get {
            return KIFUITestActor(inFile: __FILE__, atLine: __LINE__, delegate: self)
        }
    }

    private func setUpRequest(url: String, method: String) {
        tester.clearTextFromAndThenEnterText(url, intoViewWithAccessibilityLabel: "URL")
        tester.tapViewWithAccessibilityLabel(count(method) > 0 ? method: "GET")
    }

    override func beforeAll() {
        super.beforeAll()
        KIFTestActor.setDefaultTimeout(20)
    }

    override func afterAll() {
        super.afterAll()
    }

    func testEmptyMethodDefaultsToGET() {
        self.setUpRequest("http://splinesoft.net", method: "")
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.tapViewWithAccessibilityLabel("Back")
    }

    func testEmptyURL() {
        self.setUpRequest("", method: "GET")
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.tapViewWithAccessibilityLabel(kBQSTAlertKey)
    }

    func testSimpleRequest() {
        self.setUpRequest("http://httpbin.org/get", method: "GET")
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.waitForViewWithAccessibilityLabel("Response [200]")
        tester.tapViewWithAccessibilityLabel("Back")
    }

    func testCustomURLAndMethod() {
        self.setUpRequest("http://httpbin.org/post", method: "POST")
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.waitForViewWithAccessibilityLabel("Response [200]")
        tester.tapViewWithAccessibilityLabel("Back")
    }

    func testCustomMethodRequest() {
        tester.clearTextFromAndThenEnterText("http://splinesoft.net", intoViewWithAccessibilityLabel: "URL")
        tester.scrollViewWithAccessibilityIdentifier(BQSTLocalizedString("REQUEST_METHOD"), byFractionOfSizeHorizontal: -1, vertical: 0)
        tester.clearTextFromAndThenEnterText("HEAD", intoViewWithAccessibilityLabel: BQSTLocalizedString("REQUEST_METHOD_CUSTOM"))
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.waitForViewWithAccessibilityLabel("Response [200]")
        tester.tapViewWithAccessibilityLabel("Back")
    }

    func testRefreshingResponse() {
        self.setUpRequest("https://google.com", method: "GET")
        tester.tapViewWithAccessibilityLabel(kBQSTSendKey)
        tester.waitForViewWithAccessibilityLabel("Response [200]")
        tester.swipeViewWithAccessibilityLabel("Response", inDirection: .Down)
        tester.swipeViewWithAccessibilityLabel("Response", inDirection: .Down)
        tester.waitForAbsenceOfViewWithAccessibilityLabel(BQSTLocalizedString("RESPONSE_REFRESH"))
        tester.tapViewWithAccessibilityLabel("Back")
    }
}
