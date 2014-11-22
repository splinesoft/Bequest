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
            var URL : NSURL?
            
            beforeEach { URL = NSURL(string: "http://google.com")! }
            
            it("is initializable") {
                let client = BQSTHTTPClient()
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
                    var receivedResponse = false
                    
                    BQSTHTTPClient.request(URL!) {
                        (req, resp : NSHTTPURLResponse?, _, _) in
                        
                        receivedResponse = true
                        expect(resp).toNot(beNil())
                        expect(resp!.statusCode == 200).to(beTruthy())
                    }
                    
                    expect(receivedResponse).toEventually(beTrue(), timeout: 30, pollInterval: 0.75)
                }
            }
        }
    }
}
