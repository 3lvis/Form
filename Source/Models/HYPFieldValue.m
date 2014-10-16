//
//  HYPFieldValue.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldValue.h"

@implementation HYPFieldValue

- (BOOL)identifierIsEqualTo:(id)identifier
{
    if (![self.id isKindOfClass:[identifier class]]) return NO;

    if ([self.id isKindOfClass:[NSString class]]) {
        return [self.id isEqualToString:identifier];
    } else if ([self.id isKindOfClass:[NSNumber class]]) {
        return [self.id isEqualToNumber:identifier];
    } else {
        abort();
    }

    return NO;
}

@end
