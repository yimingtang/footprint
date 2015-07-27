//
//  NSString+FootprintKit.h
//  Footprint
//
//  Created by Yiming Tang on 7/26/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import Foundation;

@interface NSString (FootprintKit)

+ (NSString *)fpk_UUIDString;
- (NSString *)fpk_MD5Digest;

@end
