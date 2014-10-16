//
//  HYPTextField.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPTextFormField.h"

#import "UIColor+REMAColors.h"
#import "UIColor+ANDYHex.h"
#import "UIFont+REMAStyles.h"
#import "HYPTextFieldTypeManager.h"

@interface HYPTextFormField () <UITextFieldDelegate>

@property (nonatomic, getter = isModified) BOOL modified;

@end

@implementation HYPTextFormField

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
        self.backgroundColor = [UIColor REMAFieldBackgroundInvalid];
        self.layer.borderColor = [UIColor colorFromHex:@"EC3031"].CGColor;
    }
}

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;

    HYPTextFieldType type;
    if ([typeString isEqualToString:@"name"]) {
        type = HYPTextFieldTypeName;
    } else if ([typeString isEqualToString:@"username"]) {
        type = HYPTextFieldTypeUsername;
    } else if ([typeString isEqualToString:@"phone"]) {
        type = HYPTextFieldTypePhoneNumber;
    } else if ([typeString isEqualToString:@"number"]) {
        type = HYPTextFieldTypeNumber;
    } else if ([typeString isEqualToString:@"float"]) {
        type = HYPTextFieldTypeFloat;
    } else if ([typeString isEqualToString:@"address"]) {
        type = HYPTextFieldTypeAddress;
    } else if ([typeString isEqualToString:@"email"]) {
        type = HYPTextFieldTypeEmail;
    } else if ([typeString isEqualToString:@"date"]) {
        type = HYPTextFieldTypeDate;
    } else if ([typeString isEqualToString:@"select"]) {
        type = HYPTextFieldTypeDropdown;
    } else if ([typeString isEqualToString:@"text"]) {
        type = HYPTextFieldTypeDefault;
    } else if (!typeString.length) {
        type = HYPTextFieldTypeDefault;
    } else {
        type = HYPTextFieldTypeUnknown;
    }

    self.type = type;
}

- (void)setType:(HYPTextFieldType)type
{
    _type = type;

    HYPTextFieldTypeManager *typeManager = [[HYPTextFieldTypeManager alloc] init];
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

- (BOOL)textFieldShouldBeginEditing:(HYPTextFormField *)textField
{
    BOOL selectable = (textField.type == HYPTextFieldTypeDropdown || textField.type == HYPTextFieldTypeDate);

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

    self.modified = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;

    if ([self.formFieldDelegate respondsToSelector:@selector(textFormFieldDidEndEditing:)]) {
        [self.formFieldDelegate textFormFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.modified = YES;

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

    if (self.inputValidator) {
        valid = [self.inputValidator validateReplacementString:string withText:self.rawText];
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

#pragma mark - UIResponder Overwritables

- (BOOL)becomeFirstResponder
{
    if (self.type == HYPTextFieldTypeDropdown || self.type == HYPTextFieldTypeDate) {
        if ([self.formFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
            [self.formFieldDelegate textFormFieldDidBeginEditing:self];
        }
    }

    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    if (self.type == HYPTextFieldTypeDropdown || self.type == HYPTextFieldTypeDate) return NO;

    return [super canBecomeFirstResponder];
}

#pragma mark - Notifications

- (void)updateLabelUsingContentsOfTextField:(UITextField *)textField
{
    if (!self.isValid) {
        self.valid = YES;
    }
}

@end
