//
//  FPTRemoteManagedObject.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTRemoteManagedObject.h"

@implementation FPTRemoteManagedObject

- (void)create {
    [self createWithSuccess:nil failure:nil];
}


- (void)createWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // Subclasses must override this method
}


- (void)update {
    [self updateWithSuccess:nil failure:nil];
}


- (void)updateWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // Subclasses must override this method
}

@end
