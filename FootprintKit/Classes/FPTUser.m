//
//  FPTUser.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "FPTUser.h"
#import "FPTDefines.h"
#import "NSDictionary+FootprintKit.h"

NSString *const kFPTCurrentUserChangedNotificationName = @"FPTCurrentUserChangedNotification";
static FPTUser *__currentUser = nil;

@implementation FPTUser

@dynamic username;
@dynamic rules;
@dynamic footprints;
@synthesize accessToken = _accessToken;

#pragma mark - SSManagedObject

+ (NSString *)entityName {
    return @"FPTUser";
}


- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    self.username = [dictionary safeObjectForKey:@"username"];
}


#pragma mark - Class Methods

+ (FPTUser *)currentUser {
    if (!__currentUser) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *userID = [userDefaults objectForKey:kFPTCurrentUserIDKey];
        if (!userID) {
            return nil;
        }
        
        NSError *error = nil;
        NSString *accessToken = [SSKeychain passwordForService:kFPTKeychainServiceName account:userID.description error:&error];
        if (!accessToken) {
            NSLog(@"[FootprintKit] Failed to get access token: %@", error);
            return nil;
        }
        
        __currentUser = [self existingObjectWithRemoteID:userID];
        __currentUser.accessToken = accessToken;
    }
    return __currentUser;
}


+ (void)setCurrentUser:(FPTUser *)user {
    if (__currentUser) {
        [SSKeychain deletePasswordForService:kFPTKeychainServiceName account:[__currentUser.remoteID description]];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (!user.remoteID || !user.accessToken) {
        __currentUser = nil;
        [userDefaults removeObjectForKey:kFPTCurrentUserIDKey];
    } else {
        NSError *error = nil;
        [SSKeychain setPassword:user.accessToken forService:kFPTKeychainServiceName account:[user.remoteID description] error:&error];
        if (error) {
            NSLog(@"[FootprintKit] Failed to save access token: %@", error);
        }
        
        __currentUser = user;
        [userDefaults setObject:user.remoteID forKey:kFPTCurrentUserIDKey];
    }
    
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFPTCurrentUserChangedNotificationName object:user];
}

@end
