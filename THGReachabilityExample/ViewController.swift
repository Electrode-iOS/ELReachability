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
    let theInternets: Reachability
    let theHost: Reachability
    let hostname = "walmart.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theInternets.startMonitoring { (reachable) -> Void in
            println("Internet reachability: \(reachable.isReachable)")
            println("Using celular: \(reachable.isCellular)")
        }
        
        theHost.startMonitoring { (reachable) -> Void in
            println("Host reachability: \(reachable.isReachable)")
        }
        
        println("Reachability to host \(hostname): \(theHost.reachable.isReachable)")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        theInternets = Reachability.reachabilityForInternetConnection()
        theHost = Reachability.reachabilityForHostname(hostname)
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func checkReachability(sender: AnyObject) {
        println("Reachability to internet: \(theInternets.reachable.isReachable)")
        println("Reachability to host: \(theHost.reachable.isReachable)")
        println("Using celular: \(theInternets.reachable.isCellular)")
    }
}
