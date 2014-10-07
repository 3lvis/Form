//
//  REMABaseFieldCell.m

//
//  Created by Elvis Nunez on 11/08/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseFieldCollectionCell.h"

@implementation REMABaseFieldCollectionCell

- (void)setCollapsed:(BOOL)collapsed
{
    _collapsed = collapsed;

    [self updateFieldWithCollapsed:collapsed];
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    [self updateFieldWithDisabled:disabled];
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    abort();
}

- (void)updateFieldWithCollapsed:(BOOL)collapsed
{
    abort();
}

- (void)setField:(REMAFormField *)field
{
    _field = field;

    [self updateWithField:field];
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
