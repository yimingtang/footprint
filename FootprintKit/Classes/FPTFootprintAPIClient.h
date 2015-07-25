//
//  FPTFootprintAPIClient.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import AFNetworking.AFHTTPSessionManager;

@interface FPTFootprintAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
