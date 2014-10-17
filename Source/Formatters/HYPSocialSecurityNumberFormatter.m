//
//  HYPSocialSecurityNumberFormatter.m
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPSocialSecurityNumberFormatter.h"

@implementation HYPSocialSecurityNumberFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse
{
    string = [super formatString:string reverse:reverse];
    if (!string) return nil;

    if (reverse) {
        return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];

    if ([mutableString length] > 6 && ![[mutableString substringWithRange:NSMakeRange(6,1)] isEqualToString:@" "]) {
        [mutableString insertString:@" " atIndex:6];
    }

    if ([mutableString length] > 10 && ![[mutableString substringWithRange:NSMakeRange(10,1)] isEqualToString:@" "]) {
        [mutableString insertString:@" " atIndex:10];
    }

    return [mutableString copy];
}

@end
