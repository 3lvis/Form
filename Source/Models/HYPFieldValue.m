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
    if (!identifier) return NO;

    if ([self.valueID isKindOfClass:[NSString class]]) {
        return [self.valueID isEqualToString:identifier];
    } else if ([self.valueID isKindOfClass:[NSNumber class]]) {
        return [self.valueID isEqualToNumber:identifier];
    } else {
        abort();
    }

    return NO;
}

@end
