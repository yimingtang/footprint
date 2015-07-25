//
//  FPTUser.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import CoreData;

@interface FPTUser : NSManagedObject

@property (nonatomic, retain) NSNumber *remoteID;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSSet *rules;
@property (nonatomic, retain) NSSet *footprints;

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
