//
//  HYPBaseFormFieldCell.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPBaseFormFieldCell.h"

static const CGFloat HYPTextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat HYPTextFormFieldCellLabelHeight = 20.0f;
static const CGFloat HYPTextFormFieldIconWidth = 32.0f;
static const CGFloat HYPTextFormFieldIconHeight = 38.0f;

@interface HYPBaseFormFieldCell () <HYPTextFormFieldDelegate>

@end

@implementation HYPBaseFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];
    [self.contentView addSubview:self.iconButton];
    [self.contentView addSubview:self.textField];
    [self.iconButton setImage:nil forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

#pragma mark - Getters

- (UIButton *)iconButton
{
    if (_iconButton) return _iconButton;

    _iconButton = [[UIButton alloc] initWithFrame:[self frameForIconButton]];
    _iconButton.contentMode = UIViewContentModeRight;
    _iconButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconButton;
}

- (HYPFormFieldHeadingLabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[HYPFormFieldHeadingLabel alloc] initWithFrame:[self frameForHeadingLabel]];

    return _headingLabel;
}

- (HYPTextFormField *)textField
{
    if (_textField) return _textField;

    _textField = [[HYPTextFormField alloc] initWithFrame:[self frameForTextField]];
    _textField.formFieldDelegate = self;

    return _textField;
}

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    [self updateFieldWithDisabled:disabled];
}

- (void)setField:(HYPFormField *)field
{
    _field = field;

    self.headingLabel.hidden = (field.sectionSeparator);
    self.headingLabel.text = field.title;

    [self updateWithField:field];
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    abort();
}

- (void)updateWithField:(HYPFormField *)field
{
    abort();
}

- (NSString *)rawTextForField:(HYPFormField *)field
{
    if (field.fieldValue && field.type == HYPFormFieldTypeFloat) {

        NSNumber *value = field.fieldValue;

        if ([field.fieldValue isKindOfClass:[NSString class]]) {
            NSMutableString *fieldValue = [field.fieldValue mutableCopy];
            [fieldValue replaceOccurrencesOfString:@","
                                        withString:@"."
                                           options:NSCaseInsensitiveSearch
                                             range:NSMakeRange(0, [fieldValue length])];
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
            value = [formatter numberFromString:fieldValue];
        }

        return [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }

    return field.fieldValue;
}

#pragma mark - Actions

- (void)focusAction
{
    [self.textField becomeFirstResponder];
}

- (void)clearAction
{
    self.field.fieldValue = nil;
    [self updateWithField:self.field];
    [self.iconButton setImage:nil forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - HYPTextFormFieldDelegate

- (void)textFormFieldDidBeginEditing:(HYPTextFormField *)textField
{
    [self.iconButton setImage:[UIImage imageNamed:@"ic_mini_clear"] forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFormFieldDidEndEditing:(HYPTextFormField *)textField
{
    if (self.textField.rawText) {
        [self.textField setValid:[self.field validate]];
    }

    [self.iconButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.iconButton setImage:nil forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFormField:(HYPTextFormField *)textField didUpdateWithText:(NSString *)text
{
    self.field.fieldValue = text;

    [self.iconButton setImage:[UIImage imageNamed:@"ic_mini_clear"] forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];

    if (!self.textField.valid) {
        [self.textField setValid:[self.field validate]];
    }

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

#pragma mark - Private Methods

- (void)validate
{
    [self.textField setValid:[self.field validate]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headingLabel.frame = [self frameForHeadingLabel];
    self.iconButton.frame = [self frameForIconButton];
    self.textField.frame = [self frameForTextField];
}

- (CGRect)frameForTextField
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPTextFormFieldCellTextFieldMarginTop;
    CGFloat marginBotton = HYPTextFormFieldCellTextFieldMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)frameForHeadingLabel
{
    CGFloat marginX = HYPTextFormFieldCellMarginX + HYPTextFormFieldCellLabelMarginX;
    CGFloat marginTop = HYPTextFormFieldCellLabelMarginTop;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = HYPTextFormFieldCellLabelHeight;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)frameForIconButton
{
    CGFloat x = CGRectGetWidth(self.frame) - HYPTextFormFieldIconWidth - HYPTextFormFieldCellMarginX;
    CGFloat y = HYPTextFormFieldIconHeight - 4;
    CGFloat width = HYPTextFormFieldIconWidth;
    CGFloat height = HYPTextFormFieldIconHeight;
    CGRect  frame = CGRectMake(x, y, width, height);

    return frame;
}

@end
