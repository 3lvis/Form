//
//  REMABaseFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseFormFieldCell.h"

@implementation REMABaseFormFieldCell

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    [self updateFieldWithDisabled:disabled];
}

- (void)setField:(REMAFormField *)field
{
    _field = field;

    [self updateWithField:field];
}

#pragma mark - Overwritables

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    abort();
}

- (void)updateWithField:(REMAFormField *)field
{
    abort();
}

- (void)validate
{
    NSLog(@"validation in progress");
}

@end
