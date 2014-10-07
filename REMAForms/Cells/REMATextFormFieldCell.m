//
//  REMATextFormFieldCell.m
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"

@interface REMATextFormFieldCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *headingLabel;

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

- (UILabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[UILabel alloc] initWithFrame:[self frameForHeadingLabel]];
    _headingLabel.font = [UIFont REMASmallSize];
    _headingLabel.textColor = [UIColor colorFromHex:@"28649C"];

    return _headingLabel;
}

- (UITextField *)textField
{
    if (_textField) return _textField;

    _textField = [[UITextField alloc] initWithFrame:[self frameForTextField]];
    _textField.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    _textField.layer.cornerRadius = 5;
    _textField.delegate = self;
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textField.font = [UIFont REMATextFieldFont];

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 20.0f)];
    _textField.leftView = paddingView;
    _textField.leftViewMode = UITextFieldViewModeAlways;

    return _textField;
}

#pragma mark - Private headers

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;

    if (disabled) {
        self.textField.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];
        self.textField.layer.borderColor = [UIColor colorFromHex:@"DEDEDE"].CGColor;
    } else {
        self.textField.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.textField.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    }
}

- (void)updateWithField:(REMAFormField *)field
{
    self.textField.hidden = (field.sectionSeparator);
    self.headingLabel.hidden = (field.sectionSeparator);

    self.headingLabel.text = field.title;

    if ([field.title isEqualToString:@"Etternavn"]) {
        [self updateFieldWithDisabled:YES];
    }
}

- (void)validate
{
    NSLog(@"validation in progress");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
    self.textField.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textField.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.textField.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
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

@end
