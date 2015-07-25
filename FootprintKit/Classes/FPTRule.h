//
//  FPTUser.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTRemoteManagedObject.h"

@class FPTUser;

@interface FPTRule : FPTRemoteManagedObject

@property (nonatomic) NSString *host;
@property (nonatomic) NSNumber *threshold;
@property (nonatomic) FPTUser *user;

@end
