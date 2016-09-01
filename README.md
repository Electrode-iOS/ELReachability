# ELReachability

[![Version](https://img.shields.io/badge/version-v1.0.0-blue.svg)](https://github.com/Electrode-iOS/ELReachability/releases/latest)
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

## License

The MIT License (MIT)

Copyright (c) 2015-2016 Walmart, WalmartLabs, and other Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
