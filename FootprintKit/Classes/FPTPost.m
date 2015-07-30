//
//  FPTPost.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTPost.h"

@implementation FPTPost

#pragma mark - Accessors

@dynamic title;
@dynamic url;
@dynamic footprints;
@dynamic tags;
@dynamic remoteID;

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    
    self.url = dictionary[@"url"];
    self.title = dictionary[@"title"];
}

@end
