//
//  FPTFootprintAPIClient.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTFootprintAPIClient.h"

static NSString *const FPTFootprintAPIBaseURLString = @"http://120.25.151.196/footprint/";

@implementation FPTFootprintAPIClient

+ (instancetype)sharedClient {
    static FPTFootprintAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FPTFootprintAPIClient alloc] initWithBaseURL:[NSURL URLWithString:FPTFootprintAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
