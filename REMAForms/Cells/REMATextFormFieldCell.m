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

    [self setTypeWithJSONValue:field.typeString];

    self.textField.hidden = (field.sectionSeparator);
    self.textField.validator = [self.field validator];
    self.textField.formatter = [self.field formatter];
    self.textField.rawText = field.fieldValue;
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
    CGFloat marginX = 10.0f;
    CGFloat marginTop = 30.0f;
    CGFloat marginBotton = 10.0f;

    CGRect frame = self.frame;
    frame.origin.x = marginX;
    frame.origin.y = marginTop;
    frame.size.width = CGRectGetWidth(frame) - (marginX * 2);
    frame.size.height = CGRectGetHeight(frame) - marginTop - marginBotton;

    return frame;
}

- (CGRect)frameForHeadingLabel
{
    CGFloat marginX = 10.0f;
    CGFloat marginTop = 10.0f;

    CGRect frame = self.frame;
    frame.origin.x = marginX;
    frame.origin.y = marginTop;
    frame.size.width = CGRectGetWidth(frame) - (marginX * 2);
    frame.size.height = 20.0f;

    return frame;
}

#pragma mark - Private methods

- (void)setTypeWithJSONValue:(NSString *)type
{
    REMATextFieldType textFieldType;
    if ([type isEqualToString:@"name"]) {
        textFieldType = REMATextFieldTypeName;
    } else if ([type isEqualToString:@"username"]) {
        textFieldType = REMATextFieldTypeUsername;
    } else if ([type isEqualToString:@"phone"]) {
        textFieldType = REMATextFieldTypePhoneNumber;
    } else if ([type isEqualToString:@"number"]) {
        textFieldType = REMATextFieldTypeNumber;
    } else if ([type isEqualToString:@"address"]) {
        textFieldType = REMATextFieldTypeAddress;
    } else if ([type isEqualToString:@"email"]) {
        textFieldType = REMATextFieldTypeEmail;
    } else if ([type isEqualToString:@"date"]) {
        textFieldType = REMATextFieldTypeDate;
    } else {
        textFieldType = REMATextFieldTypeDefault;
    }

    [self.textField setTextFieldType:textFieldType];
}

@end
