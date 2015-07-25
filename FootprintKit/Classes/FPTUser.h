//
//  FPTUser.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTRemoteManagedObject.h"

extern NSString *const kFPTCurrentUserChangedNotificationName;

@interface FPTUser : FPTRemoteManagedObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSSet *rules;
@property (nonatomic) NSSet *footprints;

+ (FPTUser *)currentUser;
+ (void)setCurrentUser:(FPTUser *)user;

@end


@class FPTFootprint;

@interface FPTUser (CoreDataGeneratedAccessors)

- (void)addRulesObject:(NSManagedObject *)value;
- (void)removeRulesObject:(NSManagedObject *)value;
- (void)addRules:(NSSet *)values;
- (void)removeRules:(NSSet *)values;

- (void)addFootprintsObject:(FPTFootprint *)value;
- (void)removeFootprintsObject:(FPTFootprint *)value;
- (void)addFootprints:(NSSet *)values;
- (void)removeFootprints:(NSSet *)values;

@end
