//
//  FPTFootprint.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTFootprint.h"
#import "FPTUser.h"
#import "FPTPost.h"

@implementation FPTFootprint

@dynamic duration;
@dynamic manually;
@dynamic user;
@dynamic post;
@dynamic remoteID;

#pragma mark - SSRemoteManagedObejct

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });

    self.manually = [numberFormatter numberFromString:dictionary[@"initiative"]];
    self.createdAt = [[self class] parseDate:dictionary[@"timestamp"]];
    
    if (dictionary[@"userId"]) {
        NSNumber *remoteID = [numberFormatter numberFromString:dictionary[@"userId"]];
        self.user = [FPTUser objectWithDictionary:@{@"userId": remoteID} context:self.managedObjectContext];
    }
    
    if (dictionary[@"foot"]) {
        self.post = [FPTPost objectWithDictionary:dictionary[@"foot"] context:self.managedObjectContext];
    }
}

@end
