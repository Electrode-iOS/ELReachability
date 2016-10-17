//
//  ViewController.swift
//  ELReachabilityExample
//
//  Created by Sam Grover on 8/13/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import UIKit
import ELReachability

class ViewController: UIViewController {
    let theInternets: NetworkStatus?

    required init?(coder aDecoder: NSCoder) {
        theInternets = NetworkStatus.networkStatusForInternetConnection()

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up a callback
        theInternets?.startNetworkStatusMonitoring { status in
            guard let connection = status.connection else {
                print("Internet is not reachable")
                return
            }

            switch connection {
            case .cellular:
                print("Internet is reachable via cellular conneciton")
            case .wifi:
                print("Internet is reachable via WiFi conneciton")
            }
        }
    }

    @IBAction func checkNetworkStatus() {
        guard let theInternets = theInternets else {
            return
        }

        guard let connection = theInternets.connection else {
            print("[Synchronous] Internet is not reachable")
            return
        }

        switch connection {
        case .cellular:
            print("[Synchronous] Internet is reachable via cellular conneciton")
        case .wifi:
            print("[Synchronous] Internet is reachable via WiFi conneciton")
        }
    }

}

