//
//  REMATextField.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextFormField.h"

#import "UIColor+Colors.h"
#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"
#import "REMATextFieldTypeManager.h"

@interface REMATextFormField () <UITextFieldDelegate>

@end

@implementation REMATextFormField

@synthesize rawText = _rawText;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    self.layer.cornerRadius = 5.0f;

    self.delegate = self;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.font = [UIFont REMATextFieldFont];
    self.textColor = [UIColor colorFromHex:@"455C73"];

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 20.0f)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self addTarget:self
             action:@selector(updateLabelUsingContentsOfTextField:)
   forControlEvents:UIControlEventEditingChanged];

    return self;
}

#pragma mark - Setters

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    if (enabled) {
        self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    } else {
        self.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];
        self.layer.borderColor = [UIColor colorFromHex:@"DEDEDE"].CGColor;
    }
}

- (void)setRawText:(NSString *)rawText
{
    _rawText = rawText;

    if (self.formatter) {
        self.text = [self.formatter formatString:rawText reverse:NO];
    } else {
        self.text = rawText;
    }
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;

    if (valid) {
        self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    } else {
        self.backgroundColor = [UIColor remaFieldBackgroundInvalid];
        self.layer.borderColor = [UIColor colorFromHex:@"EC3031"].CGColor;
    }
}

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;

    REMATextFieldType type;
    if ([typeString isEqualToString:@"name"]) {
        type = REMATextFieldTypeName;
    } else if ([typeString isEqualToString:@"username"]) {
        type = REMATextFieldTypeUsername;
    } else if ([typeString isEqualToString:@"phone"]) {
        type = REMATextFieldTypePhoneNumber;
    } else if ([typeString isEqualToString:@"number"]) {
        type = REMATextFieldTypeNumber;
    } else if ([typeString isEqualToString:@"address"]) {
        type = REMATextFieldTypeAddress;
    } else if ([typeString isEqualToString:@"email"]) {
        type = REMATextFieldTypeEmail;
    } else if ([typeString isEqualToString:@"date"]) {
        type = REMATextFieldTypeDate;
    } else if ([typeString isEqualToString:@"select"]) {
        type = REMATextFieldTypeDropdown;
    } else {
        type = REMATextFieldTypeDefault;
    }

    self.type = type;
}

- (void)setType:(REMATextFieldType)type
{
    _type = type;

    REMATextFieldTypeManager *typeManager = [[REMATextFieldTypeManager alloc] init];
    [typeManager setUpType:type forTextField:self];
}

#pragma mark - Getters

- (NSString *)rawText
{
    if (self.formatter) {
        return [self.formatter formatString:_rawText reverse:YES];
    }

    return _rawText;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(REMATextFormField *)textField
{
    BOOL selectable = (textField.type == REMATextFieldTypeDropdown || textField.type == REMATextFieldTypeDate);

    if (selectable) {
        if ([self.formFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
            [self.formFieldDelegate textFormFieldDidBeginEditing:self];
        }
    }

    return !selectable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;

    if (self.validator) {
        self.valid = [self.validator validateText:self.rawText];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (!string.length) {
        self.rawText = resultString;

        if ([self.formFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
            [self.formFieldDelegate textFormField:self didUpdateWithText:self.rawText];
        }

        return NO;
    }

    if ([string characterAtIndex:0] == 10) {
        [self resignFirstResponder];
        return NO;
    }

    BOOL valid = YES;

    if (self.validator) {
        valid = [self.validator validateReplacementString:string withText:self.rawText];
    }

    if (valid) {
        self.rawText = resultString;

        if ([self.formFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
            [self.formFieldDelegate textFormField:self didUpdateWithText:self.rawText];
        }

        return NO;
    }

    return valid;
}

#pragma mark - Notifications

- (void)updateLabelUsingContentsOfTextField:(UITextField *)textField
{
    if (!self.isValid) {
        self.valid = YES;
    }
}

@end
