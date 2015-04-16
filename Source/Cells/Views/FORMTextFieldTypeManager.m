#import "FORMTextFieldTypeManager.h"

@implementation FORMTextFieldTypeManager

- (void)setUpType:(FORMTextFieldInputType)type forTextField:(UITextField *)textField {
    switch (type) {
        case FORMTextFieldInputTypeDefault     : [self setupDefaultTextField:textField]; break;
        case FORMTextFieldInputTypeName        : [self setupNameTextField:textField]; break;
        case FORMTextFieldInputTypeUsername    : [self setupUsernameTextField:textField]; break;
        case FORMTextFieldInputTypePhoneNumber : [self setupPhoneNumberTextField:textField]; break;
        case FORMTextFieldInputTypeNumber      : [self setupNumberTextField:textField]; break;
        case FORMTextFieldInputTypeFloat       : [self setupNumberTextField:textField]; break;
        case FORMTextFieldInputTypeAddress     : [self setupAddressTextField:textField]; break;
        case FORMTextFieldInputTypeEmail       : [self setupEmailTextField:textField]; break;
        case FORMTextFieldInputTypePassword    : [self setupPasswordTextField:textField]; break;

        case FORMTextFieldInputTypeUnknown:
            abort();
    }
}

#pragma mark - FORMTextFieldType

- (void)setupDefaultTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupNameTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupUsernameTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupPhoneNumberTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupNumberTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.secureTextEntry = NO;
}

- (void)setupAddressTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = NO;
}

- (void)setupEmailTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.secureTextEntry = NO;
}

- (void)setupPasswordTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;
}

@end
