//
// REMAFormSection.m
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormSection.h"
#import "REMAFormField.h"

@implementation REMAFormSection

- (REMAFormSectionType)typeFromTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"picture"]) {
        return REMAFormSectionTypePicture;
    }

    return REMAFormSectionTypeDefault;
}

- (NSUInteger)breakpoints
{
    __block NSUInteger breakpoints;
    [self.fields enumerateObjectsUsingBlock:^(REMAFormField *field, NSUInteger fieldIndex, BOOL *stop) {
        CGFloat size = 0;
        size = size + [field.size floatValue];
        breakpoints = ceil(size/100) - 1;
    }];

    return breakpoints;
}

@end
