//
//  FPTFootprint.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import CoreData;

@class FPTUser;
@class FPTPost;

@interface FPTFootprint : NSManagedObject

@property (nonatomic) NSNumber *remoteID;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSNumber *duration;
@property (nonatomic) NSNumber *manually;
@property (nonatomic) FPTUser *user;
@property (nonatomic) FPTPost *post;

@end
