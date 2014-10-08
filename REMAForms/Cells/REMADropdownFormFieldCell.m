//
//  REMADropdownFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADropdownFormFieldCell.h"

static const CGFloat REMADropdownFormIconWidth = 38.0f;

@interface REMADropdownFormFieldCell ()

@property (nonatomic, strong) REMATextFormField *textField;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation REMADropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.iconImageView];

    return self;
}

#pragma mark - Getters

- (REMATextFormField *)textField
{
    if (_textField) return _textField;

    _textField = [[REMATextFormField alloc] initWithFrame:[self frameForTextField]];

    return _textField;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    _iconImageView = [[UIImageView alloc] initWithFrame:[self frameForIconImageView]];
    _iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];
    _iconImageView.contentMode = UIViewContentModeRight;
    _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconImageView;
}

#pragma mark - Private headers

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(REMAFormField *)field
{
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

    self.textField.frame = [self frameForTextField];
    self.iconImageView.frame = [self frameForIconImageView];
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

- (CGRect)frameForIconImageView
{
    CGRect frame = [self frameForTextField];
    frame.origin.x = frame.size.width - REMADropdownFormIconWidth;
    frame.size.width = REMADropdownFormIconWidth;

    return frame;
}

@end
