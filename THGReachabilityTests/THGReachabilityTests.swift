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

class THGReachabilityTests: XCTestCase {
    
    /**
     Assumes internet connection is available for testing.
    */
    func testSynchronousReachable() {
        let theInternets = Reachability.reachabilityForInternetConnection()
        let isReachable = theInternets.reachable.isReachable
        XCTAssertTrue(isReachable)
    }
}
