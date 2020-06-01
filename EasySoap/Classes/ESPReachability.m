//
//  ESPReachability.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 05/03/20.
//

#import "ESPReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <sys/socket.h>

@interface ESPReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;

@end

@implementation ESPReachability

- (instancetype)initWithHostname:(NSString *)hostname
{
    self = [super init];
    
    if (self) {
        self.reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, hostname.UTF8String);
    }
    
    return self;
}

- (void)dealloc
{
    if(self.reachabilityRef) {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }
}

- (BOOL)isReachable
{
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    }
    else {
#if DEBUG
        NSLog(@"Error. Could not recover network reachability flags");
#endif
    }
    
    return NO;
}

@end
