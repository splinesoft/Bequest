//
//  BQSTHTTPClientTests.swift
//  BequestTests
//
//  Created by Jonathan Hersh on 11/19/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import UIKit
import XCTest
import Quick
import Nimble

class BQSTHTTPClientTests: QuickSpec {

    private func BQSTExpectHTTPResponse(closure: (() -> Void) -> Void) {
        var receivedResponse = false

        closure {
            receivedResponse = true
        }

        expect(receivedResponse).toEventually(beTrue(), timeout: 10, pollInterval: 0.25)
        return
    }

    private func BQSTURLForMethod(method: String) -> NSURL {
        return NSURL(string: "http://httpbin.org/" + method.lowercaseString)!
    }

    override func spec() {

        describe("BQSTHTTPClient") {
            var URL: NSURL?
            var client: BQSTHTTPClient?

            beforeEach {
                URL = self.BQSTURLForMethod("GET")
                client = BQSTHTTPClient()
            }

            it("is initializable") {
                expect(client).toNot(beNil())
            }

            context("when creating NSURLRequest objects") {

                it("can create simple NSURLRequest objects") {
                    let URLRequest: NSURLRequest = NSURLRequest.requestForURL(URL!,
                        method: "GET", headers: [:], parameters: [:]);

                    expect(URLRequest).toNot(beNil())
                    expect(URLRequest.URL!).to(equal(URL))
                }

                it("can create a POST request") {
                    let URLRequest: NSURLRequest = NSURLRequest.requestForURL(URL!, method: "POST", headers: [:], parameters: [:])

                    expect(URLRequest.HTTPMethod).to(equal("POST"))
                }
            }

            context("when sending simple HTTP requests") {

                it("makes successful GET requests") {
                    self.BQSTExpectHTTPResponse { (completion: () -> Void) in

                        BQSTHTTPClient.request(URL!) { (_, resp: NSHTTPURLResponse?, _, _) in

                            expect(resp).toNot(beNil())
                            expect(resp?.statusCode).to(equal(200))
                            completion()
                        }
                        return
                    }
                }

                it("makes successful POST requests") {
                    self.BQSTExpectHTTPResponse { (completion: () -> Void) in

                        BQSTHTTPClient.request(self.BQSTURLForMethod("POST"), method: .POST) {
                            (req, resp: NSHTTPURLResponse?, _, _) in

                            expect(resp).toNot(beNil())
                            expect(resp?.statusCode).to(equal(200))
                            completion()
                        }
                        return
                    }
                }

                it("reports download progress") {
                    var receivedSomeProgress = false

                    let progress: BQSTProgressBlock = {
                        (_, progress: NSProgress) in

                        if progress.completedUnitCount > 0 {
                            receivedSomeProgress = true
                        }
                    }

                    BQSTHTTPClient.request(self.BQSTURLForMethod("GET"),
                        method: "GET",
                        headers: nil,
                        parameters: nil,
                        progress: progress) { (_, _, _, _) in }

                    expect(receivedSomeProgress).toEventually(beTrue(), timeout: 5, pollInterval: 0.75)
                }

                it("can serialize an image response") {
                    self.BQSTExpectHTTPResponse { (completion: () -> Void) in

                        BQSTHTTPClient.request(NSURL(string: "http://splinesoft.net/img/jhoviform.png")!) {
                            (_, _, object: BQSTHTTPResponse?, _) in

                            expect(object).toNot(beNil())
                            expect(object!.contentType).to(equal(BQSTResponseContentType.PNG))
                            expect(object!.object as? UIImage).toNot(beNil())
                            completion()
                        }
                        return
                    }
                }
            }

            context("when sending JSON requests") {
                it("can parse a JSON object") {
                    /*
                    {
                    "one": "two",
                    "key": "value"
                    }
                    */

                    self.BQSTExpectHTTPResponse { (completion: () -> Void) in

                        BQSTHTTPClient.request(NSURL(string: "http://jsonplaceholder.typicode.com/posts/1")!,
                            method: .GET) { (req, resp: NSHTTPURLResponse?, object: BQSTHTTPResponse?, _) in

                            expect(resp).toNot(beNil())
                            expect(object).toNot(beNil())
                            expect(resp?.statusCode).to(equal(200));
                            expect(object!.contentType).to(equal(BQSTResponseContentType.JSON));

                            if let dict = object!.object as? BQSTJSONResponse {
                                expect(dict.count).to(equal(4))
                            } else {
                                XCTFail("Failed to parse JSON object")
                            }

                            completion()
                        }
                        return
                    }
                }
            }
        }
    }
}
