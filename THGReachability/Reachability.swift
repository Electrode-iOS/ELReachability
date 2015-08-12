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
internal func objc_startMonitoring(_: SCNetworkReachability, _: dispatch_block_t) -> ObjCBool

@asmname("objc_stopMonitoring")
internal func objc_stopMonitoring(_: SCNetworkReachability) -> ObjCBool

public struct Reachable {
    /// The actual flags reported by the system. This is used to compute if the network is reachable.
    public let flags: SCNetworkReachabilityFlags
    
    /// Returns `true` when the network is reachable. `false` otherwise.
    public var isReachable: Bool {
        var isReachable = flags.contains(SCNetworkReachabilityFlags.Reachable)
        
        // Check that this is not an oddity as per https://github.com/tonymillion/Reachability/blob/master/Reachability.m
        if flags.contains(SCNetworkReachabilityFlags.ConnectionRequired) || flags.contains(SCNetworkReachabilityFlags.TransientConnection) {
            isReachable = false
        }
        return isReachable
    }
    
    /// Returns `true` when the network is reachable via a cellular connection. `false` otherwise. Note: This check may give false negatives.
    public var isCellular: Bool {
        return flags.contains(SCNetworkReachabilityFlags.IsWWAN)
    }
    
}

public typealias ReachabilityCallbackClosure = (reachable: Reachable) -> Void

@objc(THGReachability)
public final class Reachability: NSObject {
    private let reachability: SCNetworkReachability
    private var isMonitoring = false
    
    /**
    Use this if you want to do a synchronous check. If you want notification of changes, see `startMonitoring`.
    */
    public var reachable: Reachable {
        assert(isMonitoring == false, "Error: Cannot call the synchronous API while monitoring")
        var flags = SCNetworkReachabilityFlags(rawValue:0)
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return Reachable(flags: flags)
        } else {
            return Reachable(flags: SCNetworkReachabilityFlags(rawValue:0))
        }
    }
    
    // TODO: Something is wrong with the class design if i need to do this.
    public var isReachable: Bool {
        return self.reachable.isReachable
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
    - parameter callback: The closure that will be called when reachability changes.
    - returns: `true` if the monitoring was set up. `false` otherwise.
    */
    public func startMonitoring(callback: ReachabilityCallbackClosure) -> Bool {
        let monitoringStarted =  objc_startMonitoring(reachability) { () -> Void in
            var flags = SCNetworkReachabilityFlags(rawValue:0)
            SCNetworkReachabilityGetFlags(self.reachability, &flags)
            callback(reachable: Reachable(flags: flags))            
        }
        
        isMonitoring = monitoringStarted.boolValue
        return isMonitoring
    }

    /**
    Call this method to remove any callback associated with an instance.
    */
    public func stopMonitoring() {
        objc_stopMonitoring(reachability)
        isMonitoring = false
    }
    
    /**
    This method can be used to set up a `Reachability` instance to check if the internet is reachable.
    - returns: The `Reachability` object.
    */
    public class func reachabilityForInternetConnection() -> Reachability? {
        var zeroAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let reachabilityRef = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        if let reachabilityRef = reachabilityRef {
            return Reachability(reachability: reachabilityRef)
        } else {
            return nil
        }
    }
    
    /**
    This method can be used to set up a `Reachability` instance to check if a particular host is reachable.
    - parameter hostname: The name of the host, e.g. google.com
    - returns: The `Reachability` object.
    */
    public class func reachabilityForHostname(hostname: String) -> Reachability? {
        let reachabilityRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostname as NSString).UTF8String)
        if let reachabilityRef = reachabilityRef {
            return Reachability(reachability: reachabilityRef)
        } else {
            return nil
        }
    }
}
