# ELReachability

[![Version](https://img.shields.io/badge/version-v1.1.0-blue.svg)](https://github.com/Electrode-iOS/ELReachability/releases/latest)
[![Build Status](https://travis-ci.org/Electrode-iOS/ELReachability.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELReachability)

`ELReachability` is a simple Swift API for checking network reachability. `ELReachability` is also designed to work well with, and to utilize other libraries in [Electrode-iOS](https://github.com/Electrode-iOS), or THG for short.

## Usage

`ELReachability` can be used to query the current reachability to the internet or to a particular host. It can also be used to receive callbacks when the reachability changes.

Setting up and checking reachability to the internet

```Swift
// Create a Reachability instance
let theInternets = NetworkStatus.networkStatusForInternetConnection()

// Set up a callback
theInternets.startNetworkStatusMonitoring { (reachable) -> Void in
    println("Internet reachability: \(reachable.isReachable)")
    println("Using celular: \(reachable.isCellular)")
}

// Synchronous check
println("Reachability to internet: \(theInternets.reachable.isReachable)")

// Stop monitoring
theInternets.stopNetworkStatusMonitoring()
```
