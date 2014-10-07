//
//  REMATextFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextFormFieldCell.h"

#import "REMATextFormField.h"
#import "REMAFormFieldHeadingLabel.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"

static const CGFloat REMATextFormFieldCellMarginX = 10.0f;

static const CGFloat REMATextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat REMATextFormFieldCellLabelHeight = 20.0f;

static const CGFloat REMATextFormFieldCellTextFieldMarginTop = 30.0f;
static const CGFloat REMATextFormFieldCellTextFieldMarginBottom = 10.0f;

@interface REMATextFormFieldCell ()

@property (nonatomic, strong) REMATextFormField *textField;
@property (nonatomic, strong) REMAFormFieldHeadingLabel *headingLabel;

@end

@implementation REMATextFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];
    [self.contentView addSubview:self.textField];

    return self;
}

#pragma mark - Getters

- (REMAFormFieldHeadingLabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[REMAFormFieldHeadingLabel alloc] initWithFrame:[self frameForHeadingLabel]];

    return _headingLabel;
}

- (REMATextFormField *)textField
{
    if (_textField) return _textField;

    _textField = [[REMATextFormField alloc] initWithFrame:[self frameForTextField]];

    return _textField;
}

#pragma mark - Private headers

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(REMAFormField *)field
{
    self.headingLabel.hidden = (field.sectionSeparator);
    self.headingLabel.text = field.title;

    self.textField.hidden = (field.sectionSeparator);
    self.textField.validator = [self.field validator];
    self.textField.formatter = [self.field formatter];
    self.textField.rawText = field.fieldValue;
    self.textField.typeString = field.typeString;
}

- (void)validate
{
    NSLog(@"validation in progress");
}

#pragma mark - Private methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headingLabel.frame = [self frameForHeadingLabel];
    self.textField.frame = [self frameForTextField];
}

- (CGRect)frameForTextField
{
    CGFloat marginX = REMATextFormFieldCellMarginX;
    CGFloat marginTop = REMATextFormFieldCellTextFieldMarginTop;
    CGFloat marginBotton = REMATextFormFieldCellTextFieldMarginBottom;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
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
