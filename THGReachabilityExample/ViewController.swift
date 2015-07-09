//
//  ViewController.swift
//  THGReachabilityExample
//
//  Created by Sam Grover on 4/6/15.
//  Copyright (c) 2015 Set Direction. All rights reserved.
//

import UIKit
import THGReachability

class ViewController: UIViewController {
    let theInternets: Reachability?
    let theHost: Reachability?
    let hostname = "walmart.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up a callback
        if let theInternets = theInternets, theHost = theHost {
            theInternets.startMonitoring { (reachable) -> Void in
                print("Internet reachability: \(reachable.isReachable)")
                print("Using cellular: \(reachable.isCellular)")
                theInternets.stopMonitoring()
            }
            
            theHost.startMonitoring { (reachable) -> Void in
                print("Host reachability: \(reachable.isReachable)")
                theHost.stopMonitoring()
            }
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        // Create a Reachability instance
        theInternets = Reachability.reachabilityForInternetConnection()
        theHost = Reachability.reachabilityForHostname(hostname)
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func checkReachability(sender: AnyObject) {
        if let theInternets = theInternets, theHost = theHost {

            // BUG: This asserts because of the class design. We need to make the API
            // not allow sync calls while monitoring, but the monitoring callback is not always called
            // It seems that the monitoring callback is not called for Internet/Cellular connections until
            // the connection changes, whereas for hosts, it is always called at least once        if let theInternets = theInternets, theHost = theHost {

            print("Reachability to internet: \(theInternets.reachable.isReachable)")
            print("Reachability to host: \(theHost.reachable.isReachable)")
            print("Using cellular: \(theInternets.reachable.isCellular)")
        }
    }
    
    @IBAction func testHostSync() {
        // Synchronous check
        if let theHost = theHost {
            print("Reachability to host \(hostname): \(theHost.reachable.isReachable)")
        }
    }
}
