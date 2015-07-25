//
//  FPTTag.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import CoreData;

@interface FPTTag : NSManagedObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *remoteID;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSSet *posts;

@end


@interface FPTTag (CoreDataGeneratedAccessors)

- (void)addPostsObject:(NSManagedObject *)value;
- (void)removePostsObject:(NSManagedObject *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
