//
//  FPTPost.h
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTRemoteManagedObject.h"

@interface FPTPost : FPTRemoteManagedObject

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NSSet *footprints;
@property (nonatomic) NSSet *tags;

@end


@class FPTFootprint;
@class FPTTag;

@interface FPTPost (CoreDataGeneratedAccessors)

- (void)addFootprintsObject:(FPTFootprint *)value;
- (void)removeFootprintsObject:(FPTFootprint *)value;
- (void)addFootprints:(NSSet *)values;
- (void)removeFootprints:(NSSet *)values;

- (void)addTagsObject:(FPTTag *)value;
- (void)removeTagsObject:(FPTTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
