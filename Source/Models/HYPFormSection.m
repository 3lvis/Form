//
// HYPFormSection.m
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormSection.h"
#import "HYPFormField.h"

@implementation HYPFormSection

- (HYPFormSectionType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"picture"]) {
        return HYPFormSectionTypePicture;
    }

    return HYPFormSectionTypeDefault;
}

- (NSUInteger)breakpoints
{
    __block NSUInteger breakpoints;
    [self.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *stop) {
        CGFloat size = 0;
        size = size + [field.size floatValue];
        breakpoints = ceil(size/100) - 1;
    }];

    return breakpoints;
}

@end
