//
//  ViewController.swift
//  THGNetworkExample
//
//  Created by Sam Grover on 8/13/15.
//  Copyright © 2015 The Holy Grail. All rights reserved.
//

import UIKit
import THGNetwork

class ViewController: UIViewController {
    let theInternets: NetworkStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up a callback
        if let theInternets = theInternets {
            theInternets.startNetworkStatusMonitoring { (reachable) -> Void in
                print("[Callback] Is Reachable: \(reachable.isReachable)")
                print("[Callback] Is Cellular : \(reachable.isCellular)")
                print("[Callback] Is WiFi : \(reachable.isWiFi)")
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        theInternets = NetworkStatus.networkStatusForInternetConnection()
        
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkNetworkStatus() {
        if let theInternets = theInternets {
            print("[Synchronous] Is Reachable: \(theInternets.isReachable())")
            print("[Synchronous] Is Cellular : \(theInternets.isCellular())")
            print("[Synchronous] Is WiFi : \(theInternets.isWiFi())")
        }
    }

}

