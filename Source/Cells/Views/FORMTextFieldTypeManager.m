#import "FORMTextFieldTypeManager.h"

@implementation FORMTextFieldTypeManager

- (void)setUpType:(FORMTextFieldType)type forTextField:(UITextField *)textField
{
    switch (type) {
        case FORMTextFieldTypeDefault     : [self setupDefaultTextField:textField]; break;
        case FORMTextFieldTypeName        : [self setupNameTextField:textField]; break;
        case FORMTextFieldTypeUsername    : [self setupUsernameTextField:textField]; break;
        case FORMTextFieldTypePhoneNumber : [self setupPhoneNumberTextField:textField]; break;
        case FORMTextFieldTypeNumber      : [self setupNumberTextField:textField]; break;
        case FORMTextFieldTypeFloat       : [self setupNumberTextField:textField]; break;
        case FORMTextFieldTypeAddress     : [self setupAddressTextField:textField]; break;
        case FORMTextFieldTypeEmail       : [self setupEmailTextField:textField]; break;
        case FORMTextFieldTypePassword    : [self setupPasswordTextField:textField]; break;

        case FORMTextFieldTypeSelect:
        case FORMTextFieldTypeDate:
            [self setupDefaultTextField:textField];
            break;

        case FORMTextFieldTypeUnknown:
            abort();
    }
}

#pragma mark - FORMTextFieldType

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
