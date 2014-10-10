//
//  NSDictionary+HYPSafeValueForKey.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSDictionary+HYPSafeValueForKey.h"

@implementation NSDictionary (HYPSafeValueForKey)

- (id)hyp_safeObjectForKey:(id)key
{
    if (!key) {
        return nil;
    }
    id value = [self valueForKeyPath:key];

    if (value != [NSNull null] && [value isKindOfClass:[NSString class]]) {
        NSString *someValue = value;
        if (someValue.length == 0) {
            return nil;
        }
    }

    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
