//
//  REMATextField.m
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextFormField.h"

#import "UIColor+Colors.h"
#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"

@interface REMATextFormField () <UITextFieldDelegate>

@end

@implementation REMATextFormField

@synthesize rawText = _rawText;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    self.layer.cornerRadius = 5;
    self.delegate = self;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.font = [UIFont REMATextFieldFont];

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

- (void)setFailed:(BOOL)failed
{
    _failed = failed;

    if (failed) {
        self.textColor = [UIColor remaFieldForeground];
    }
}

- (void)setTextFieldType:(REMATextFieldType)textFieldType
{
    _textFieldType = textFieldType;

    switch (textFieldType) {
        case REMATextFieldTypeDefault     : [self setupDefaultTextField]; break;
        case REMATextFieldTypeName        : [self setupNameTextField]; break;
        case REMATextFieldTypeUsername    : [self setupUsernameTextField]; break;
        case REMATextFieldTypePhoneNumber : [self setupPhoneNumberTextField]; break;
        case REMATextFieldTypeNumber      : [self setupNumberTextField]; break;
        case REMATextFieldTypeAddress     : [self setupAddressTextField]; break;
        case REMATextFieldTypeEmail       : [self setupEmailTextField]; break;
        case REMATextFieldTypePassword    : [self setupPasswordTextField]; break;

        case REMATextFieldTypeDropdown:
        case REMATextFieldTypeDate:
            [self setupDefaultTextField];
            break;
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) return YES;

    if ((int)[string characterAtIndex:0] == 10) {
        [self resignFirstResponder];
        return NO;
    }

    BOOL valid = YES;

    if (self.validator) {
        valid = [self.validator validateReplacementString:string withText:self.rawText];
    }

    return valid;
}

#pragma mark - Notifications

- (void)updateLabelUsingContentsOfTextField:(UITextField *)textField
{
    if (self.failed) {
        self.failed = NO;
    }

    if (!self.isValid) {
        self.valid = YES;
    }
}

#pragma mark - REMATextFieldType

- (void)setupDefaultTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.secureTextEntry = NO;
}

- (void)setupNameTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeDefault;
    self.secureTextEntry = NO;
}

- (void)setupUsernameTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeNamePhonePad;
    self.secureTextEntry = NO;
}

- (void)setupPhoneNumberTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypePhonePad;
    self.secureTextEntry = NO;

}

- (void)setupNumberTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.secureTextEntry = NO;
}

- (void)setupAddressTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.secureTextEntry = NO;
}

- (void)setupEmailTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.secureTextEntry = NO;
}

- (void)setupPasswordTextField
{
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.secureTextEntry = YES;
}

@end
