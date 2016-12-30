//
//  ELReachabilityTests.swift
//  ELReachabilityTests
//
//  Created by Sam Grover on 8/13/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import XCTest
import SystemConfiguration
@testable import ELReachability

class ELReachabilityTests: XCTestCase {
    // Examples of various "real world" flag combinations.
    let offlineFlags: SCNetworkReachabilityFlags = []
    let notConnectedFlags: SCNetworkReachabilityFlags = [.reachable, .connectionRequired]
    let transientFlags: SCNetworkReachabilityFlags = [.reachable, .transientConnection]
    let cellularFlags: SCNetworkReachabilityFlags = [.reachable, .isWWAN]
    let wifiFlags: SCNetworkReachabilityFlags = [.reachable]

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

    // MARK: NetworkConnection Tests

    func testConnectionWhenNotReachable() {
        XCTAssertNil(NetworkConnection(flags: offlineFlags), "Connection should be nil when offline")
        XCTAssertNil(NetworkConnection(flags: notConnectedFlags), "Connection should be nil when not connected")
        XCTAssertNil(NetworkConnection(flags: transientFlags), "Connection should be nil when transient")
    }

    func testConnectionWhenReachable() {
        XCTAssertEqual(NetworkConnection(flags: cellularFlags), .cellular, "Connection should be `cellular` when connected via Cellular")
        XCTAssertEqual(NetworkConnection(flags: wifiFlags), .wifi, "Connection should be `wifi` when connected via WiFi")
    }

    // MARK: NetworkStatusInterpreter Tests

    func testInterpreterWhenNotReachable() {
        let offline = NetworkStatusInterpreter(flags: offlineFlags)
        XCTAssertFalse(offline.isReachable, "Status should be not-reachable when offline")
        XCTAssertNil(offline.connection, "Connection should be nil when offline")
        XCTAssertFalse(offline.isCellular, "`isCellular` should be false when offline")
        XCTAssertFalse(offline.isWiFi, "`isWiFi` should be false when offline")

        let notConnected = NetworkStatusInterpreter(flags: notConnectedFlags)
        XCTAssertFalse(notConnected.isReachable, "Status should be not-reachable when not connected")
        XCTAssertNil(notConnected.connection, "Connection should be nil when not connected")
        XCTAssertFalse(notConnected.isCellular, "`isCellular` should be false when not connected")
        XCTAssertFalse(notConnected.isWiFi, "`isWiFi` should be false when not connected")

        let transient = NetworkStatusInterpreter(flags: transientFlags)
        XCTAssertFalse(transient.isReachable, "Status should be not-reachable when transient")
        XCTAssertNil(transient.connection, "Connection should be nil when transient")
        XCTAssertFalse(transient.isCellular, "`isCellular` should be false when transient")
        XCTAssertFalse(transient.isWiFi, "`isWiFi` should be false when transient")
    }

    func testInterpreterWhenReachable() {
        let cellular = NetworkStatusInterpreter(flags: cellularFlags)
        XCTAssertTrue(cellular.isReachable, "Status should be reachable when connected via Cellular")
        XCTAssertEqual(cellular.connection, .cellular, "Connection should be `cellular` when connected via Cellular")
        XCTAssertTrue(cellular.isCellular, "`isCellular` should be true when connected via Cellular")
        XCTAssertFalse(cellular.isWiFi, "`isWiFi` should be false when connected via Cellular")

        let wifi = NetworkStatusInterpreter(flags: wifiFlags)
        XCTAssertTrue(wifi.isReachable, "Status should be reachable when connected via WiFi")
        XCTAssertEqual(wifi.connection, .wifi, "Connection should be `wifi` when connected via WiFi")
        XCTAssertTrue(wifi.isWiFi, "`isWiFi` should true when connected via WiFi")
        XCTAssertFalse(wifi.isCellular, "`isCellular` should be false when connected via WiFi")
    }
}
