//
//  THGReachabilityTests.swift
//  THGReachabilityTests
//
//  Created by Sam Grover on 4/6/15.
//  Copyright (c) 2015 Set Direction. All rights reserved.
//

import UIKit
import XCTest
import THGReachability

/**
 All tests assume that a working internet connection is available.
*/
class THGReachabilityTests: XCTestCase {
    
    // MARK: Test Hosts
    
    let nonExistantTestHost = "www.sumrandomfakedomain.com"
    let existantTestHost = "www.google.com"
    
    // MARK: Tests
    
    func testSynchronousReachableInternet() {
        if let theInternets = Reachability.reachabilityForInternetConnection() {
            let isReachable = theInternets.reachable.isReachable
            XCTAssertTrue(isReachable)
        } else {
            XCTAssert(false, "Failed")
        }
    }
    
    func testSynchronousReachableHost() {
        if let theHosts = Reachability.reachabilityForHostname(existantTestHost) {
            let isReachable = theHosts.reachable.isReachable
                XCTAssertTrue(isReachable)
        } else {
            XCTAssert(false, "Failed")
        }

    }
    
    func testSynchronousUnreachableHost() {
        if let theHosts = Reachability.reachabilityForHostname(nonExistantTestHost) {
            let isReachable = theHosts.reachable.isReachable
            XCTAssertFalse(isReachable)
        } else {
            XCTAssert(false, "Failed")
        }
    }
    
    
    func testStartMonitoringReachableHost() {
        if let theHosts = Reachability.reachabilityForHostname(existantTestHost) {
            let expectation = expectationWithDescription("Start monitoring called")
            
            theHosts.startMonitoring { (reachable) -> Void in
                XCTAssertTrue(reachable.isReachable)
                expectation.fulfill()
            }
            
            waitForExpectationsWithTimeout(3, handler: nil)
        } else {
            XCTAssert(false, "Failed")
        }
    }
    
    func testStartMonitoringUnreachableHost() {
        if let theHosts = Reachability.reachabilityForHostname(nonExistantTestHost) {
            let expectation = expectationWithDescription("Start monitoring called")
            
            theHosts.startMonitoring { (reachable) -> Void in
                XCTAssertFalse(reachable.isReachable)
                expectation.fulfill()
            }
            
            waitForExpectationsWithTimeout(3, handler: nil)
        } else {
            XCTAssert(false, "Failed")
        }
    }
}
