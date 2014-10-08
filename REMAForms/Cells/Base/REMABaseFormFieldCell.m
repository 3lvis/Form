//
//  REMABaseFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseFormFieldCell.h"

static const CGFloat REMATextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat REMATextFormFieldCellLabelHeight = 20.0f;

@implementation REMABaseFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];

    return self;
}

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

#pragma mark - Getters

- (REMAFormFieldHeadingLabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[REMAFormFieldHeadingLabel alloc] initWithFrame:[self frameForHeadingLabel]];

    return _headingLabel;
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

#pragma mark - Private Methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headingLabel.frame = [self frameForHeadingLabel];
}

- (CGRect)frameForHeadingLabel
{
    CGFloat marginX = REMATextFormFieldCellMarginX;
    CGFloat marginTop = REMATextFormFieldCellLabelMarginTop;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = REMATextFormFieldCellLabelHeight;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

@end
