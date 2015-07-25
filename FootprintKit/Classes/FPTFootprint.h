//
//  FPTFootprint.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTRemoteManagedObject.h"

@class FPTUser;
@class FPTPost;

@interface FPTFootprint : FPTRemoteManagedObject

@property (nonatomic) NSNumber *duration;
@property (nonatomic) NSNumber *manually;
@property (nonatomic) FPTUser *user;
@property (nonatomic) FPTPost *post;

@end
