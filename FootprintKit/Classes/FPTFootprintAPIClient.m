//
//  FPTFootprintAPIClient.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

/**
 NOTE: The API design of server side is very ugly. This client is a quick and dirty implementation.
 */

#import "FPTFootprintAPIClient.h"
#import "FPTDefines.h"
#import "FPTUser.h"
#import "NSString+FootprintKit.h"

static NSString *const FPTFootprintAPIClientErrorDomain = @"FPTFootprintAPIClient";

@interface FPTFootprintAPIClient ()

@property (nonatomic) NSString *accessToken;

@end

@implementation FPTFootprintAPIClient

#pragma mark - Accessors

- (NSString *)accessToken {
    if (!_accessToken) {
        _accessToken = @"";
    }
    return _accessToken;
}


#pragma mark - Class Methods

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


#pragma mark - Public

- (NSURLSessionDataTask *)signUpWithUsername:(NSString *)username
                                    password:(NSString *)password
                                     success:(FPTFootprintAPIClientSuccessBlock)success
                                     failure:(FPTFootprintAPIClientFailureBlock)failure
{
    NSDictionary *parameters = @{
        @"userName": username,
        @"password": [password fpk_MD5Digest],
    };
    
    return [self POST:@"user/register.php" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        BOOL succeeded = [responseObject[@"ok"] integerValue] == 1;
        
        if (succeeded) {
            __weak NSManagedObjectContext *context = [FPTUser mainQueueContext];
            [context performBlockAndWait:^{
                NSDictionary *dictionary = responseObject[@"data"];
                if (!dictionary) {
                    return;
                }
                
                FPTUser *user = [FPTUser objectWithDictionary:dictionary];
                user.accessToken = [dictionary objectForKey:@"token"];
                [self changeUser:user];
                [FPTUser setCurrentUser:user];
            }];
            
            if (success) {
                success(task, responseObject);
            }
        } else {
            NSString *errorMessage = responseObject[@"error"];
            if (failure) {
                failure(task, [NSError errorWithDomain:FPTFootprintAPIClientErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}]);
            }
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
    
    return [self POST:@"user/login.php" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        BOOL succeeded = [responseObject[@"ok"] integerValue] == 1;
        
        if (succeeded) {
            NSDictionary *dictionary = responseObject[@"data"];
            __weak NSManagedObjectContext *context = [FPTUser mainQueueContext];
            [context performBlockAndWait:^{
                if (!dictionary) {
                    return;
                }
                
                FPTUser *user = [FPTUser objectWithDictionary:dictionary];
                user.accessToken = [dictionary objectForKey:@"token"];
                [user save];
                [self changeUser:user];
                [FPTUser setCurrentUser:user];
            }];
            
            if (success) {
                success(task, responseObject);
            }
        } else {
            NSString *errorMessage = responseObject[@"error"];
            if (failure) {
                failure(task, [NSError errorWithDomain:FPTFootprintAPIClientErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}]);
            }
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
        @"token": self.accessToken,
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


#pragma mark - Authentication

- (void)userChanged:(NSNotification *)notification {
    [self changeUser:[FPTUser currentUser]];
}


- (void)changeUser:(FPTUser *)user {
    self.accessToken = user.accessToken;
}

@end
