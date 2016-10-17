# ELReachability

[![Version](https://img.shields.io/badge/version-v1.2.0-blue.svg)](https://github.com/Electrode-iOS/ELReachability/releases/latest)
[![Build Status](https://travis-ci.org/Electrode-iOS/ELReachability.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELReachability)

`ELReachability` is a simple Swift API for checking network reachability. `ELReachability` is also designed to work well with, and to utilize other libraries in [Electrode-iOS](https://github.com/Electrode-iOS), or THG for short.

## Usage

`ELReachability` can be used to query the current reachability to the internet or to a particular host. It can also be used to receive callbacks when the reachability changes.

Setting up and checking reachability to the internet

```swift
// Create a Reachability instance
let theInternets = NetworkStatus.networkStatusForInternetConnection()

// Set up a callback
theInternets.startNetworkStatusMonitoring { status in
    guard let connection = status.connection else {
        print("Internet is not reachable")
        return
    }

    switch connection {
        case .cellular:
            print("Internet is reachable via cellular connection")
        case .wifi:
            print("Internet is reachable via WiFi connection")
    }
}

// Synchronous check
switch theInternets.connection {
    case nil:
        print("Internet is not reachable")
    case .cellular?:
        print("Internet is reachable via cellular connection")
    case .wifi?:
        print("Internet is reachable via WiFi connection")
}

// Stop monitoring
theInternets.stopNetworkStatusMonitoring()
```
