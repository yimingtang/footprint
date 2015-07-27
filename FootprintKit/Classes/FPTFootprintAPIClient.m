//
//  FPTFootprintAPIClient.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTFootprintAPIClient.h"
#import "FPTDefines.h"
#import "FPTUser.h"
#import "NSString+FootprintKit.h"

@implementation FPTFootprintAPIClient

+ (instancetype)sharedClient {
    static FPTFootprintAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FPTFootprintAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kFPTAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // NOTE: Should use JSON?
        // _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}


- (NSURLSessionDataTask *)signUpWithUsername:(NSString *)username
                                    password:(NSString *)password
                                     success:(FPTFootprintAPIClientSuccessBlock)success
                                     failure:(FPTFootprintAPIClientFailureBlock)failure
{
    NSDictionary *parameters = @{
        @"userName": username,
        @"password": [password fpk_MD5Digest],
    };
    
    return [self POST:@"user/register.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"[FPTFootprintAPIClient] Sign Up Succeeded: %@", responseObject);
        
        __weak NSManagedObjectContext *context = [FPTUser mainQueueContext];
        [context performBlockAndWait:^{
            NSDictionary *dictionary = responseObject;
            FPTUser *user = [FPTUser objectWithDictionary:dictionary];
            user.accessToken = [dictionary objectForKey:@"token"];
            [FPTUser setCurrentUser:user];
        }];
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[FPTFootprintAPIClient] Sign Up Failed: %@", error.description);
        
        if (failure) {
            failure(task, error);
        }
    }];
}


- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username
                                    password:(NSString *)password
                                     success:(FPTFootprintAPIClientSuccessBlock)success
                                     failure:(FPTFootprintAPIClientFailureBlock)failure
{
    NSDictionary *parameters = @{
        @"userName": username,
        @"password": [password fpk_MD5Digest],
    };
    
    return [self POST:@"user/login.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"[FPTFootprintAPIClient] Sign In Succeeded: %@", responseObject);
        
        __weak NSManagedObjectContext *context = [CDKUser mainContext];
        [context performBlockAndWait:^{
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            CDKUser *user = [CDKUser objectWithDictionary:[dictionary objectForKey:@"user"]];
            user.accessToken = [dictionary objectForKey:@"access_token"];
            [user save];
            
            [self changeUser:user];
            [CDKUser setCurrentUser:user];
        }];
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[FPTFootprintAPIClient] Sign In Failed: %@", error.description);
        
        if (failure) {
            failure(task, error);
        }
    }];
}


- (NSURLSessionDataTask *)getGlobalFootprintsWithSuccess:(FPTFootprintAPIClientSuccessBlock)success
                                                 failure:(FPTFootprintAPIClientFailureBlock)failure
{
    NSDictionary *parameters = @{
        @"token": [[FPTUser currentUser] accessToken],
    };
    
    return [self GET:@"footprint/discover.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"[FPTFootprintAPIClient] Get Global Footprints Succeeded: %@", responseObject);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[FPTFootprintAPIClient] Get Global Footprints Failed: %@", error.description);
        
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
