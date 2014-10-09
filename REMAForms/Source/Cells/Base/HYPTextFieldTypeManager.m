//
//  HYPTextFieldTypeManager.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPTextFieldTypeManager.h"

@implementation HYPTextFieldTypeManager

- (void)setUpType:(HYPTextFieldType)type forTextField:(UITextField *)textField
{
    switch (type) {
        case HYPTextFieldTypeDefault     : [self setupDefaultTextField:textField]; break;
        case HYPTextFieldTypeName        : [self setupNameTextField:textField]; break;
        case HYPTextFieldTypeUsername    : [self setupUsernameTextField:textField]; break;
        case HYPTextFieldTypePhoneNumber : [self setupPhoneNumberTextField:textField]; break;
        case HYPTextFieldTypeNumber      : [self setupNumberTextField:textField]; break;
        case HYPTextFieldTypeAddress     : [self setupAddressTextField:textField]; break;
        case HYPTextFieldTypeEmail       : [self setupEmailTextField:textField]; break;
        case HYPTextFieldTypePassword    : [self setupPasswordTextField:textField]; break;

        case HYPTextFieldTypeDropdown:
        case HYPTextFieldTypeDate:
            [self setupDefaultTextField:textField];
            break;
    }
}

#pragma mark - HYPTextFieldType

- (void)setupDefaultTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupNameTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupUsernameTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupPhoneNumberTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupNumberTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.secureTextEntry = NO;
}

- (void)setupAddressTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = NO;
}

- (void)setupEmailTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.secureTextEntry = NO;
}

- (void)setupPasswordTextField:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;
}

@end
