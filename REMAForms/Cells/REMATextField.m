//
//  REMATextField.m

//
//  Created by Christoffer Winterkvist on 5/13/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextField.h"

#import "REMAObserverCenter.h"
#import "UIFont+Styles.h"
#import "UIColor+Colors.h"

@interface REMATextField ()

@property (nonatomic) BOOL addedContent;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation REMATextField

@synthesize text = _text;
@synthesize placeholder = _placeholder;
@synthesize rawText = _rawText;

#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:REMAUnfocusAllTextfieldsNotification
                                                  object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                         label:nil
                     validIcon:nil
                 textFieldType:REMATextFieldTypeDefault
                    cornerType:REMATextFieldCornerFull];
}

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
{
    return [self initWithFrame:frame
                         label:label
                     validIcon:nil
                 textFieldType:REMATextFieldTypeDefault
                    cornerType:REMATextFieldCornerFull];
}

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                textFieldType:(REMATextFieldType)textFieldType
{
    return [self initWithFrame:frame
                         label:label
                     validIcon:nil
                 textFieldType:textFieldType
                    cornerType:REMATextFieldCornerFull];
}

- (instancetype)initWithFrame:(CGRect)frame
                   cornerType:(REMATextFieldCornerType)cornerType
{
    return [self initWithFrame:frame
                         label:nil
                     validIcon:nil
                 textFieldType:REMATextFieldTypeDefault
                    cornerType:cornerType];
}

- (instancetype)initWithFrame:(CGRect)frame
                    validIcon:(UIImage *)validIcon
                textFieldType:(REMATextFieldType)textFieldType
                   cornerType:(REMATextFieldCornerType)cornerType
{
    return [self initWithFrame:frame
                         label:nil
                     validIcon:validIcon
                 textFieldType:textFieldType
                    cornerType:cornerType];
}

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                   cornerType:(REMATextFieldCornerType)cornerType
{
    return [self initWithFrame:frame
                         label:label
                     validIcon:nil
                 textFieldType:REMATextFieldTypeDefault
                    cornerType:cornerType];
}

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                    validIcon:(UIImage *)validIcon
                textFieldType:(REMATextFieldType)textFieldType
                   cornerType:(REMATextFieldCornerType)cornerType
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.validIcon = validIcon;
    self.cornerType = cornerType;
    self.textFieldType = textFieldType;
    [self addSubview:self.textField];
    self.label.text = label;

    if (validIcon) {
        self.iconImageView.image = validIcon;
        [self addSubview:self.iconImageView];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing)
                                                 name:REMAUnfocusAllTextfieldsNotification
                                               object:nil];

    [self.textField addTarget:self
                       action:@selector(updateLabelUsingContentsOfTextField:)
             forControlEvents:UIControlEventEditingChanged];

    return self;
}

#pragma mark - Getters

- (UITextField *)textField
{
    if (_textField) return _textField;

    CGRect textFieldFrame = self.frame;
    CGFloat offset = (self.validIcon) ? 35.0f : 10.0f;
    textFieldFrame.size.width -= offset;
    textFieldFrame.origin.x = offset;
    textFieldFrame.origin.y = 2.0f;

    _textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clipsToBounds = NO;
    _textField.font = [UIFont REMATextFieldFont];
    _textField.textColor = [UIColor remaFieldForeground];
    _textField.delegate = self;
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _textField;
}

- (NSString *)text
{
    _text = self.textField.text;

    return _text;
}

- (NSString *)placeholder
{
    _placeholder = self.textField.placeholder;

    return _placeholder;
}

- (NSString *)rawText
{
    if (self.formatter) {
        return [self.formatter formatString:_rawText reverse:YES];
    }

    return _rawText;
}

#pragma mark - Setter

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

- (void)setText:(NSString *)text
{
    _text = text;

    self.textField.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    self.textField.placeholder = placeholder;
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

- (void)setDisabled:(BOOL)disabled
{
    [super setDisabled:disabled];

    if (disabled) {
        self.textField.textColor = [UIColor remaFieldForegroundDisabled];
    } else {
        self.textField.textColor = [UIColor remaFieldForeground];
    }

    [self setNeedsDisplay];
}

- (void)setFailed:(BOOL)failed
{
    [super setFailed:failed];

    if (failed) {
        self.textField.textColor = [UIColor remaFieldForeground];
    }
}

#pragma mark - Notifications

- (void)endEditing
{
    [self.textField resignFirstResponder];
}

- (void)updateLabelUsingContentsOfTextField:(UITextField *)textField
{
    self.addedContent = YES;

    BOOL needsRedisplay = NO;
    if (self.failed || self.isValid) {
        needsRedisplay = YES;
    }

    if (self.failed) {
        self.failed = NO;
    }

    if (!self.isValid) {
        self.valid = YES;
    }

    if (needsRedisplay) {
        [self setNeedsDisplay];
    }

    if ([self.delegate respondsToSelector:@selector(textFieldDidUpdate:)]) {
        [self.delegate textFieldDidUpdate:self];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.isDisabled) {
        return NO;
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }

    self.active = YES;
    [self setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }

    self.active = NO;
    [self setNeedsDisplay];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) return YES;

    // Dismiss keyboard on return
    if ((int)[string characterAtIndex:0] == 10) {
        [self endEditing];
        return NO;
    }

    BOOL valid = YES;

    if (self.validator) {
        valid = [self.validator validateReplacementString:string withText:self.rawText];
    }

    if (valid) {
        valid = (!self.isDisabled);
    }

    return valid;
}

#pragma mark - REMATextFieldType

- (void)setupDefaultTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.secureTextEntry = NO;
}

- (void)setupNameTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.secureTextEntry = NO;
}

- (void)setupUsernameTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.textField.secureTextEntry = NO;
}

- (void)setupPhoneNumberTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    self.textField.secureTextEntry = NO;

}

- (void)setupNumberTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.secureTextEntry = NO;
}

- (void)setupAddressTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.secureTextEntry = NO;
}

- (void)setupEmailTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField.secureTextEntry = NO;
}

- (void)setupPasswordTextField
{
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.secureTextEntry = YES;
}

@end
