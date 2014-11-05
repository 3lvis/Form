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

    if ([self.fieldValueID isKindOfClass:[NSString class]]) {
        return [self.fieldValueID isEqualToString:identifier];
    } else if ([self.fieldValueID isKindOfClass:[NSNumber class]]) {
        return [self.fieldValueID isEqualToNumber:identifier];
    } else {
        abort();
    }

    return NO;
}

@end
