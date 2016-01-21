//
//  ELReachabilityTests.swift
//  ELReachabilityTests
//
//  Created by Sam Grover on 8/13/15.
//  Copyright © 2015 The Holy Grail. All rights reserved.
//

import XCTest
@testable import ELReachability

class ELReachabilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testSynchronousReachableInternet() {
        if let theInternets = NetworkStatus.networkStatusForInternetConnection() {
            XCTAssertTrue(theInternets.isReachable())
        } else {
            XCTAssert(false, "Failed")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
