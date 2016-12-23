//
//  NetworkStatus.swift
//  ELReachability
//
//  Created by Sam Grover on 8/13/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import Foundation
import SystemConfiguration

@_silgen_name("objc_startMonitoring")
internal func objc_startMonitoring(_: SCNetworkReachability, _: ()->()) -> ObjCBool

@_silgen_name("objc_stopMonitoring")
internal func objc_stopMonitoring(_: SCNetworkReachability) -> ObjCBool

/// The network connection enumeration describes the possible connection types that can be identified.
public enum NetworkConnection {
    case cellular, wifi

    init?(flags: SCNetworkReachabilityFlags) {
        if !flags.contains(.reachable) {
            return nil
        }

        // Check that this is not an oddity as per https://github.com/tonymillion/Reachability/blob/master/Reachability.m
        if flags.contains(.connectionRequired) || flags.contains(.transientConnection) {
            return nil
        }

        if flags.contains(.isWWAN) {
            self = .cellular
        } else {
            self = .wifi
        }
    }
}

public struct NetworkStatusInterpreter {
    /// The actual flags reported by the system. This is used to compute if the network is reachable.
    public let flags: SCNetworkReachabilityFlags

    /// The network connection type, or `nil` if the network is not reachable. Note: This property may give false negatives.
    public let connection: NetworkConnection?

    internal init(flags: SCNetworkReachabilityFlags) {
        self.flags = flags
        self.connection = NetworkConnection(flags: flags)
    }

    /// Returns `true` when the network is reachable. `false` otherwise.
    public var isReachable: Bool {
        return connection != nil
    }

    /// Returns `true` when the network is reachable via a cellular connection. `false` otherwise. Note: This check may give false negatives.
    public var isCellular: Bool {
        return connection == .cellular
    }

    /// Returns `true` when the network is reachable via a WiFi connection. `false` otherwise. Note: This check may give false negatives.
    public var isWiFi: Bool {
        return connection == .wifi
    }
}

public typealias NetworkStatusCallbackClosure = (_ networkStatusInterpreter: NetworkStatusInterpreter) -> Void

@objc(ELNetworkStatus)
public final class NetworkStatus: NSObject {
    fileprivate let reachability: SCNetworkReachability

    // MARK: Class methods

    /**
    This method can be used to set up a `NetworkStatus` instance to check if the internet is reachable.
    - returns: The `NetworkStatus` object.
    */
    public class func networkStatusForInternetConnection() -> NetworkStatus? {
        var zeroAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let reachabilityRef = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { (ptr) -> SCNetworkReachability? in
                            return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, ptr)
            })
        }

        if let reachabilityRef = reachabilityRef {
            return NetworkStatus(reachability: reachabilityRef)
        } else {
            return nil
        }
    }

    init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }

    deinit {
        stopNetworkStatusMonitoring()
    }

    // MARK: Asynchronous API methods

    /**
    Call this method to set up a callback for being notified when the network status changes. When you're done, call `stopNetworkStatusMonitoring`.
    Use this if you want notification of changes. For synchronous checks, see `isReachable`.
    - parameter callback: The closure that will be called when reachability changes.
    - returns: `true` if the monitoring was set up. `false` otherwise.
    */
    public func startNetworkStatusMonitoring(_ callback: @escaping NetworkStatusCallbackClosure) -> Bool {
        let monitoringStarted = objc_startMonitoring(reachability) { () -> Void in
            var flags = SCNetworkReachabilityFlags(rawValue:0)
            SCNetworkReachabilityGetFlags(self.reachability, &flags)
            callback(NetworkStatusInterpreter(flags: flags))
        }

        return monitoringStarted.boolValue
    }

    /**
    Call this method to remove any callback associated with an instance.
    */
    public func stopNetworkStatusMonitoring() {
        _ = objc_stopMonitoring(reachability)
    }

    // MARK: Synchronous API methods

    /// The current network connection type, or `nil` if the network is not reachable.
    public var connection: NetworkConnection? {
        return self.networkStatusInterpreter.connection
    }

    /// Returns `true` when the network is reachable. `false` otherwise. Calls corresponding method in `NetworkStatusInterpreter`.
    public func isReachable() -> Bool {
        return self.networkStatusInterpreter.isReachable
    }

    /// Returns `true` when the network is reachable via a cellular connection. `false` otherwise. Calls corresponding method in `NetworkStatusInterpreter`.
    public func isCellular() -> Bool {
        return self.networkStatusInterpreter.isCellular
    }

    /// Returns `true` when the network is reachable via a WiFi connection. `false` otherwise. Calls corresponding method in `NetworkStatusInterpreter`.
    public func isWiFi() -> Bool {
        return self.networkStatusInterpreter.isWiFi
    }

    // MARK: Utilities

    // All synchronous APIs go through here.
    fileprivate var networkStatusInterpreter: NetworkStatusInterpreter {
        var flags = SCNetworkReachabilityFlags(rawValue:0)
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return NetworkStatusInterpreter(flags: flags)
        } else {
            return NetworkStatusInterpreter(flags: SCNetworkReachabilityFlags(rawValue:0))
        }
    }

}
