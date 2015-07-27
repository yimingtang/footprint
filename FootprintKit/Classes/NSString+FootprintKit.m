//
//  NSString+FootprintKit.m
//  Footprint
//
//  Created by Yiming Tang on 7/26/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "NSString+FootprintKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (FootprintKit)

+ (NSString *)fpk_UUIDString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}


- (NSString *)fpk_MD5Digest {
    const char *cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];
    for(NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
