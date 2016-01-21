//
//  ReachabilityMonitoring-Objc.m
//  ELReachability
//
//  Created by Brandon Sneed on 4/2/15.
//  Copyright (c) 2015 Set Direction. All rights reserved.
//

#import "ReachabilityMonitoring-Objc.h"
@import SystemConfiguration;

static void objc_ReachabilityCallback(SCNetworkReachabilityRef networkReachability, SCNetworkReachabilityFlags flags, void *info)
{
    // this has the pointer to our swift callback block/closure.
    dispatch_block_t block = (__bridge dispatch_block_t)info;
    block();
}

extern BOOL objc_startMonitoring(SCNetworkReachabilityRef reachability, dispatch_block_t callback) {
    SCNetworkReachabilityContext context = {0, NULL, NULL, NULL, NULL};
    if (callback) {
        context.info = (__bridge void *)callback;
        context.retain = &CFRetain;
        context.release = &CFRelease;
    }

    if (SCNetworkReachabilitySetCallback(reachability, &objc_ReachabilityCallback, &context)) {
        if (SCNetworkReachabilitySetDispatchQueue(reachability, dispatch_get_main_queue())) {
            // success!  carry on.
            return YES;
        }

        // if we got here, we were unable to set the queue, so ditch the callback.
        SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
    }

    return NO;
}

extern BOOL objc_stopMonitoring(SCNetworkReachabilityRef reachability) {
    SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
    return YES;
}
