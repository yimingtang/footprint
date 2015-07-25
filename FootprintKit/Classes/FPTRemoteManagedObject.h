//
//  FPTRemoteManagedObject.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import <SSDataKit/SSRemoteManagedObject.h>

@interface FPTRemoteManagedObject : SSRemoteManagedObject

- (void)create;
- (void)createWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)update;
- (void)updateWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
