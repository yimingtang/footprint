//
//  FPTUser.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import CoreData;

@class FPTUser;

@interface FPTRule : NSManagedObject

@property (nonatomic) NSNumber *remoteID;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSString *host;
@property (nonatomic) NSNumber *threshold;
@property (nonatomic) FPTUser *user;

@end
