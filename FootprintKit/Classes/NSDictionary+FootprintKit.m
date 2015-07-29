//
//  NSDictionary+FootprintKit.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "NSDictionary+FootprintKit.h"

@implementation NSDictionary (FootprintKit)

- (id)fpk_safeObjectForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
