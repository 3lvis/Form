//
//  REMATextFieldTypeManager.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPTextFieldTypeManager.h"

@implementation HYPTextFieldTypeManager

- (void)setUpType:(REMATextFieldType)type forTextField:(UITextField *)textField
{
    switch (type) {
        case REMATextFieldTypeDefault     : [self setupDefaultTextField:textField]; break;
        case REMATextFieldTypeName        : [self setupNameTextField:textField]; break;
        case REMATextFieldTypeUsername    : [self setupUsernameTextField:textField]; break;
        case REMATextFieldTypePhoneNumber : [self setupPhoneNumberTextField:textField]; break;
        case REMATextFieldTypeNumber      : [self setupNumberTextField:textField]; break;
        case REMATextFieldTypeAddress     : [self setupAddressTextField:textField]; break;
        case REMATextFieldTypeEmail       : [self setupEmailTextField:textField]; break;
        case REMATextFieldTypePassword    : [self setupPasswordTextField:textField]; break;

        case REMATextFieldTypeDropdown:
        case REMATextFieldTypeDate:
            [self setupDefaultTextField:textField];
            break;
    }
}

#pragma mark - REMATextFieldType

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
