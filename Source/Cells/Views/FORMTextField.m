#import "FORMTextField.h"

#import "FORMTextFieldCell.h"

#import "FORMTextFieldTypeManager.h"

static const CGFloat FORMTextFieldClearButtonWidth = 30.0f;
static const CGFloat FORMTextFieldClearButtonHeight = 20.0f;

static UIColor *activeBackgroundColor;
static UIColor *activeBorderColor;
static UIColor *inactiveBackgroundColor;
static UIColor *inactiveBorderColor;

static UIColor *enabledBackgroundColor;
static UIColor *enabledBorderColor;
static UIColor *enabledTextColor;
static UIColor *disabledBackgroundColor;
static UIColor *disabledBorderColor;
static UIColor *disabledTextColor;

static UIColor *validBackgroundColor;
static UIColor *validBorderColor;
static UIColor *invalidBackgroundColor;
static UIColor *invalidBorderColor;

static BOOL enabledProperty;

@interface FORMTextField () <UITextFieldDelegate>

@property (nonatomic, getter = isModified) BOOL modified;

@end

@implementation FORMTextField

@synthesize rawText = _rawText;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.delegate = self;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FORMFieldCellLeftMargin, 0.0f)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self addTarget:self action:@selector(textFieldDidUpdate:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];

    self.returnKeyType = UIReturnKeyDone;

    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"ic_mini_clear"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    clearButton.frame = CGRectMake(0.0f, 0.0f, FORMTextFieldClearButtonWidth, FORMTextFieldClearButtonHeight);
    self.rightView = clearButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;

    return self;
}

#pragma mark - Setters

- (NSRange)currentRange {
    NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument
                                          toPosition:self.selectedTextRange.start];
    NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument
                                        toPosition:self.selectedTextRange.end];
    NSRange range = NSMakeRange(startOffset, endOffset-startOffset);

    return range;
}

- (void)setText:(NSString *)text {
    UITextRange *textRange = self.selectedTextRange;
    NSString *newRawText = [self.formatter formatString:text
                                                reverse:YES];
    NSRange range = [self currentRange];

    BOOL didAddText  = (newRawText.length > self.rawText.length);
    BOOL didFormat   = (text.length > super.text.length);
    BOOL cursorAtEnd = (newRawText.length == range.location);

    if ((didAddText && didFormat) || (didAddText && cursorAtEnd)) {
        self.selectedTextRange = textRange;
        [super setText:text];
    } else {
        [super setText:text];
        self.selectedTextRange = textRange;
    }
}

- (void)setRawText:(NSString *)rawText {
    BOOL shouldFormat = (self.formatter && (rawText.length >= _rawText.length ||
                                            ![rawText isEqualToString:_rawText]));

    if (shouldFormat) {
        self.text = [self.formatter formatString:rawText reverse:NO];
    } else {
        self.text = rawText;
    }

    _rawText = rawText;
}

- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;

    FORMTextFieldType type;
    if ([typeString isEqualToString:@"name"]) {
        type = FORMTextFieldTypeName;
    } else if ([typeString isEqualToString:@"username"]) {
        type = FORMTextFieldTypeUsername;
    } else if ([typeString isEqualToString:@"phone"]) {
        type = FORMTextFieldTypePhoneNumber;
    } else if ([typeString isEqualToString:@"number"]) {
        type = FORMTextFieldTypeNumber;
    } else if ([typeString isEqualToString:@"float"]) {
        type = FORMTextFieldTypeFloat;
    } else if ([typeString isEqualToString:@"address"]) {
        type = FORMTextFieldTypeAddress;
    } else if ([typeString isEqualToString:@"email"]) {
        type = FORMTextFieldTypeEmail;
    } else if ([typeString isEqualToString:@"date"]) {
        type = FORMTextFieldTypeDate;
    } else if ([typeString isEqualToString:@"select"]) {
        type = FORMTextFieldTypeSelect;
    } else if ([typeString isEqualToString:@"text"]) {
        type = FORMTextFieldTypeDefault;
    } else if ([typeString isEqualToString:@"password"]) {
        type = FORMTextFieldTypePassword;
    } else if (!typeString.length) {
        type = FORMTextFieldTypeDefault;
    } else {
        type = FORMTextFieldTypeUnknown;
    }

    self.type = type;
}

- (void)setInputTypeString:(NSString *)inputTypeString {
    _inputTypeString = inputTypeString;

    FORMTextFieldInputType inputType;
    if ([inputTypeString isEqualToString:@"name"]) {
        inputType = FORMTextFieldInputTypeName;
    } else if ([inputTypeString isEqualToString:@"username"]) {
        inputType = FORMTextFieldInputTypeUsername;
    } else if ([inputTypeString isEqualToString:@"phone"]) {
        inputType = FORMTextFieldInputTypePhoneNumber;
    } else if ([inputTypeString isEqualToString:@"number"]) {
        inputType = FORMTextFieldInputTypeNumber;
    } else if ([inputTypeString isEqualToString:@"float"]) {
        inputType = FORMTextFieldInputTypeFloat;
    } else if ([inputTypeString isEqualToString:@"address"]) {
        inputType = FORMTextFieldInputTypeAddress;
    } else if ([inputTypeString isEqualToString:@"email"]) {
        inputType = FORMTextFieldInputTypeEmail;
    } else if ([inputTypeString isEqualToString:@"text"]) {
        inputType = FORMTextFieldInputTypeDefault;
    } else if ([inputTypeString isEqualToString:@"password"]) {
        inputType = FORMTextFieldInputTypePassword;
    } else if (!inputTypeString.length) {
        inputType = FORMTextFieldInputTypeDefault;
    } else {
        inputType = FORMTextFieldInputTypeUnknown;
    }

    self.inputType = inputType;
}

- (void)setInputType:(FORMTextFieldInputType)inputType {
    _inputType = inputType;

    FORMTextFieldTypeManager *typeManager = [FORMTextFieldTypeManager new];
    [typeManager setUpType:inputType forTextField:self];
}

#pragma mark - Getters

- (NSString *)rawText {
    if (self.formatter) {
        return [self.formatter formatString:_rawText reverse:YES];
    }

    return _rawText;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(FORMTextField *)textField {
    BOOL selectable = (textField.type == FORMTextFieldTypeSelect ||
                       textField.type == FORMTextFieldTypeDate);

    if (selectable &&
        [self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFormFieldDidBeginEditing:self];
    }

    return !selectable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.active = YES;
    self.modified = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.active = NO;
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidEndEditing:)]) {
        [self.textFieldDelegate textFormFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string || [string isEqualToString:@"\n"]) return YES;

    BOOL validator = (self.inputValidator &&
                      [self.inputValidator respondsToSelector:@selector(validateReplacementString:withText:withRange:)]);

    if (validator) return [self.inputValidator validateReplacementString:string
                                                                withText:self.rawText withRange:range];

    return YES;
}

#pragma mark - UIResponder Overwritables

- (BOOL)becomeFirstResponder {
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFormFieldDidBeginEditing:self];
    }

    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    BOOL isTextField = (self.type != FORMTextFieldTypeSelect &&
                        self.type != FORMTextFieldTypeDate);

    return (isTextField && self.enabled) ?: [super canBecomeFirstResponder];
}

#pragma mark - Notifications

- (void)textFieldDidUpdate:(UITextField *)textField {
    if (!self.isValid) {
        self.valid = YES;
    }

    self.modified = YES;
    self.rawText = self.text;

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
        [self.textFieldDelegate textFormField:self
                            didUpdateWithText:self.rawText];
    }
}

- (void)textFieldDidReturn:(UITextField *)textField {
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidReturn:)]) {
        [self.textFieldDelegate textFormFieldDidReturn:self];
    }
}

#pragma mark - Actions

- (void)clearButtonAction {
    self.rawText = nil;

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
        [self.textFieldDelegate textFormField:self
                            didUpdateWithText:self.rawText];
    }
}

#pragma mark - Appearance

- (void)setActive:(BOOL)active {
    _active = active;

    if (active) {
        self.backgroundColor = activeBackgroundColor;
        self.layer.borderColor = activeBorderColor.CGColor;
    } else {
        self.backgroundColor = inactiveBackgroundColor;
        self.layer.borderColor = inactiveBorderColor.CGColor;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    enabledProperty = enabled;

    if (enabled) {
        self.backgroundColor = enabledBackgroundColor;
        self.layer.borderColor = enabledBorderColor.CGColor;
        self.textColor = enabledTextColor;
    } else {
        self.backgroundColor = disabledBackgroundColor;
        self.layer.borderColor = disabledBorderColor.CGColor;
        self.textColor = disabledTextColor;
    }
}

- (void)setValid:(BOOL)valid {
    _valid = valid;

    if (!self.isEnabled) return;

    if (valid) {
        self.backgroundColor = validBackgroundColor;
        self.layer.borderColor = validBorderColor.CGColor;
    } else {
        self.backgroundColor = invalidBackgroundColor;
        self.layer.borderColor = invalidBorderColor.CGColor;
    }
}

- (void)setCustomFont:(UIFont *)font {
    self.font = font;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setActiveBackgroundColor:(UIColor *)color {
    activeBackgroundColor = color;
}

- (void)setActiveBorderColor:(UIColor *)color {
    activeBorderColor = color;
}

- (void)setInactiveBackgroundColor:(UIColor *)color {
    inactiveBackgroundColor = color;
}

- (void)setInactiveBorderColor:(UIColor *)color {
    inactiveBorderColor = color;
}

- (void)setEnabledBackgroundColor:(UIColor *)color {
    enabledBackgroundColor = color;
}

- (void)setEnabledBorderColor:(UIColor *)color {
    enabledBorderColor = color;
}

- (void)setEnabledTextColor:(UIColor *)color {
    enabledTextColor = color;
}

- (void)setDisabledBackgroundColor:(UIColor *)color {
    disabledBackgroundColor = color;
}

- (void)setDisabledBorderColor:(UIColor *)color {
    disabledBorderColor = color;
}

- (void)setDisabledTextColor:(UIColor *)color {
    disabledTextColor = color;
    self.enabled = enabledProperty;
}

- (void)setValidBackgroundColor:(UIColor *)color {
    validBackgroundColor = color;
}

- (void)setValidBorderColor:(UIColor *)color {
    validBorderColor = color;
}

- (void)setInvalidBackgroundColor:(UIColor *)color {
    invalidBackgroundColor = color;
}

- (void)setInvalidBorderColor:(UIColor *)color {
    invalidBorderColor = color;
    self.enabled = enabledProperty;
}

@end
