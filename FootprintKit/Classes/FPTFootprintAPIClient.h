//
//  FPTFootprintAPIClient.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import AFNetworking;

typedef void (^FPTFootprintAPIClientSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^FPTFootprintAPIClientFailureBlock)(NSURLSessionDataTask *task, NSError *error);


@class FPTUser;
@class FPTFootprint;

@interface FPTFootprintAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

// User
- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username password:(NSString *)password success:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;
- (NSURLSessionDataTask *)signUpWithUsername:(NSString *)username password:(NSString *)password success:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;

// Footprint
- (NSURLSessionDataTask *)getGlobalFootprintsWithSuccess:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;
- (NSURLSessionDataTask *)getFootprintsWithUser:(FPTUser *)user success:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;
- (NSURLSessionDataTask *)createFootprint:(FPTFootprint *)footprint success:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;
- (NSURLSessionDataTask *)deleteFootprint:(FPTFootprint *)footprint success:(FPTFootprintAPIClientSuccessBlock)success failure:(FPTFootprintAPIClientFailureBlock)failure;

// Rule




@end
