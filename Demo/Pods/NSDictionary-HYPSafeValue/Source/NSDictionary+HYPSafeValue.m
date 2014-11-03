//
//  NSDictionary+HYPSafeValue.m
//
//  Created by Elvis Nunez on 10/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSDictionary+HYPSafeValue.h"

@implementation NSDictionary (HYPSafeValue)

- (id)hyp_safeValueForKey:(id)key
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

- (void)hyp_setSafeValue:(id)value forKey:(id)key
{
    if (value && key) [self setValue:value forKey:key];
}

@end
