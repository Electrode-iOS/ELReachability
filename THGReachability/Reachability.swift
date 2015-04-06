//
//  Reachability.swift
//  ReachReach
//
//  Created by Sam Grover on 3/30/15.
//  Copyright (c) 2015 Set Direction. All rights reserved.
//

import Foundation
import SystemConfiguration

@asmname("objc_startMonitoring")
internal func objc_startMonitoring(SCNetworkReachability!, dispatch_block_t!) -> ObjCBool

@asmname("objc_stopMonitoring")
internal func objc_stopMonitoring(SCNetworkReachability!) -> ObjCBool

public struct Reachable {
    /// The actual flags reported by the system. This is used to compute if the network is reachable.
    public let flags: SCNetworkReachabilityFlags
    
    /// Returns `true` when the network is reachable. `false` otherwise.
    public var isReachable: Bool {
        var isReachable = flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsReachable) != 0
        
        // Check that this is not an oddity as per https://github.com/tonymillion/Reachability/blob/master/Reachability.m
        var testcase = SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)
        if flags & testcase == testcase {
            isReachable = false
        }
        return isReachable
    }
    
    /// Returns `true` when the network is reachable via a cellular connection. `false` otherwise. Note: This check may give false negatives.
    public var isCellular: Bool {
        return flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN) != 0
    }
    
}

public typealias ReachabilityCallbackClosure = (reachable: Reachable) -> Void

@objc(THGReachability)
public final class Reachability {
    private let reachability: SCNetworkReachability
    
    /**
    Use this if you want to do a synchronous check. If you want notification of changes, see `startMonitoring`.
    */
    public var reachable: Reachable {
        var flags: SCNetworkReachabilityFlags = 0
        SCNetworkReachabilityGetFlags(reachability, &flags) != 0
        return Reachable(flags: flags)
    }
    
    init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }
    
    deinit {
        objc_stopMonitoring(reachability)
    }
    
    /**
    Call this method to set up a callback for being notified when the reachability changes. When you're done, call `stopMonitoring`.
    Use this if you want notification of changes. For synchronous checks, see `isReachable`.
    :param: callback The closure that will be called when reachability changes.
    */
    public func startMonitoring(callback: ReachabilityCallbackClosure!) -> Bool {
        var monitoringStarted =  objc_startMonitoring(reachability) { () -> Void in
            if callback != nil {
                var flags: SCNetworkReachabilityFlags = 0
                SCNetworkReachabilityGetFlags(self.reachability, &flags)
                callback(reachable: Reachable(flags: flags))
            }
        }
        
        return monitoringStarted.boolValue
    }

    /**
    Call this method to remove any callback associated with an instance.
    */
    public func stopMonitoring() {
        objc_stopMonitoring(reachability)
    }
    
    /**
    This method can be used to set up a `Reachability` instance to check if the internet is reachable.
    :returns: The `Reachability` object.
    */
    public class func reachabilityForInternetConnection() -> Reachability {
        var zeroAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let ref = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0)).takeRetainedValue()
        }
        
        return Reachability(reachability: ref)
    }
    
    /**
    This method can be used to set up a `Reachability` instance to check if a particular host is reachable.
    :param: hostname The name of the host, e.g. google.com
    :returns: The `Reachability` object.
    */
    public class func reachabilityForHostname(hostname: String) -> Reachability {
        let ref = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostname as NSString).UTF8String).takeRetainedValue()
        return Reachability(reachability: ref)
    }
}
