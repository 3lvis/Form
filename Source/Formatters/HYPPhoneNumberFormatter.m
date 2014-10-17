//
//  HYPPhoneNumberFormatter.m
//
//  Created by Christoffer Winterkvist on 9/23/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPPhoneNumberFormatter.h"

@implementation HYPPhoneNumberFormatter

- (NSString *)formatString:(NSString *)string reverse:(BOOL)reverse
{
    string = [super formatString:string reverse:reverse];
    if (!string) return nil;

    if (reverse) {
        return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];

    if ([mutableString length] > 3 && ![[mutableString substringWithRange:NSMakeRange(3,1)] isEqualToString:@" "]) {
        [mutableString insertString:@" " atIndex:3];
    }

    if ([mutableString length] > 6 && ![[mutableString substringWithRange:NSMakeRange(6,1)] isEqualToString:@" "]) {
        [mutableString insertString:@" " atIndex:6];
    }

    return [mutableString copy];
}

@end
