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
    
    private func BQSTExpectHTTPResponse(closure : (() -> Void) -> Void) {
        var receivedResponse = false
        
        closure {
            receivedResponse = true
        }
        
        expect(receivedResponse).toEventually(beTrue(), timeout: 10, pollInterval: 0.75)
    }
    
    private func BQSTURLForMethod(method : String) -> NSURL {
        return NSURL(string: "http://httpbin.org/" + method.lowercaseString)!
    }
    
    override func spec() {
        
        describe("BQSTHTTPClient") {
            var URL : NSURL?
            var client : BQSTHTTPClient?
            
            beforeEach {
                URL = self.BQSTURLForMethod("GET")
                client = BQSTHTTPClient()
            }
            
            it("is initializable") {
                expect(client).toNot(beNil())
            }
            
            context("when creating NSURLRequest objects") {
                
                it("can create simple NSURLRequest objects") {
                    let URLRequest : NSURLRequest = BQSTHTTPClient.requestForURL(URL!,
                        method: "GET", headers: [:], parameters: [:]);
                    
                    expect(URLRequest).toNot(beNil())
                    expect(URLRequest.URL.isEqual(URL)).to(beTruthy())
                }
                
                it("can create a POST request") {
                    let URLRequest : NSURLRequest = BQSTHTTPClient.requestForURL(URL!, method: "POST", headers: [:], parameters: [:])
                    
                    expect(URLRequest.HTTPMethod == "POST").to(beTruthy())
                }
            }
            
            context("when sending simple HTTP requests") {
               
                it("makes successful GET requests") {
                    self.BQSTExpectHTTPResponse { (completion : () -> Void) in
                    
                        BQSTHTTPClient.request(URL!) { (req, resp : NSHTTPURLResponse?, _, _) in
                            
                            expect(resp).toNot(beNil())
                            expect(resp!.statusCode == 200).to(beTruthy())
                            completion()
                        }
                    }
                }
                
                it("makes successful POST requests") {
                    self.BQSTExpectHTTPResponse { (completion : () -> Void) in
                        
                        BQSTHTTPClient.request(self.BQSTURLForMethod("POST"), method: .POST) {
                            (req, resp : NSHTTPURLResponse?, _, _) in
                            
                            expect(resp).toNot(beNil())
                            expect(resp!.statusCode == 200).to(beTruthy())
                            completion()
                        }
                    }
                }
                
                it("reports download progress") {
                    var receivedSomeProgress = false
                    
                    let progress : BQSTProgressBlock = {
                        (_, progress : Float) in
                        
                        if progress > 0 {
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
            }
            
            context("when sending JSON requests") {
                it("can parse a JSON object") {
                    /*
                    {
                    "one": "two",
                    "key": "value"
                    }
                    */
                    
                    self.BQSTExpectHTTPResponse { (completion : () -> Void) in
                        
                        BQSTHTTPClient.request(NSURL(string: "http://echo.jsontest.com/key/value/one/two")!,
                            method: .GET) { (req, resp : NSHTTPURLResponse?, object : AnyObject?, _) in
                            
                            expect(resp).toNot(beNil())
                            expect(object).toNot(beNil())
                            expect(resp!.statusCode == 200).to(beTruthy())
                                
                            var error : NSError?
                            let JSONResult = BQSTJSONResult.JSONObjectForData(object as NSData, options: nil)
                                
                            switch JSONResult {
                            case .Success(let dict):
                                expect(dict.count > 0).to(beTrue())
                                expect(dict["one"] as? String == "two").to(beTrue())
                                expect(dict["key"] as? String == "value").to(beTrue())
                            
                            case .Failure(let error):
                                XCTFail("Failed to parse JSON object with \(error)")
                            }
                            
                            completion()
                        }
                    }
                }
            }
        }
    }
}
