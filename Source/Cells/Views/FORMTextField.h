@import UIKit;

#import "FORMInputValidator.h"
#import "FORMFormatter.h"

typedef NS_ENUM(NSInteger, FORMTextFieldType) {
    FORMTextFieldTypeDefault = 0,
    FORMTextFieldTypeName,
    FORMTextFieldTypeUsername,
    FORMTextFieldTypePhoneNumber,
    FORMTextFieldTypeNumber,
    FORMTextFieldTypeFloat,
    FORMTextFieldTypeAddress,
    FORMTextFieldTypeEmail,
    FORMTextFieldTypePassword,
    FORMTextFieldTypeSelect,
    FORMTextFieldTypeDate,
    FORMTextFieldTypeUnknown
};

typedef NS_ENUM(NSInteger, FORMTextFieldInputType) {
    FORMTextFieldInputTypeDefault = 0,
    FORMTextFieldInputTypeName,
    FORMTextFieldInputTypeUsername,
    FORMTextFieldInputTypePhoneNumber,
    FORMTextFieldInputTypeNumber,
    FORMTextFieldInputTypeFloat,
    FORMTextFieldInputTypeAddress,
    FORMTextFieldInputTypeEmail,
    FORMTextFieldInputTypePassword,
    FORMTextFieldInputTypeUnknown
};

@protocol FORMTextFieldDelegate;

@interface FORMTextField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic) FORMInputValidator *inputValidator;
@property (nonatomic) FORMFormatter *formatter;

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic) FORMTextFieldType type;
@property (nonatomic, copy) NSString *inputTypeString;
@property (nonatomic) FORMTextFieldInputType inputType;
@property (nonatomic, copy) NSString *info;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;

@property (nonatomic, weak) id <FORMTextFieldDelegate> textFieldDelegate;

- (void)setCustomFont:(UIFont *)font  UI_APPEARANCE_SELECTOR;
- (void)setBorderWidth:(CGFloat)borderWidth UI_APPEARANCE_SELECTOR;
- (void)setBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

@end

@protocol FORMTextFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(FORMTextField *)textField;

- (void)textFormFieldDidEndEditing:(FORMTextField *)textField;

- (void)textFormField:(FORMTextField *)textField didUpdateWithText:(NSString *)text;

- (void)textFormFieldDidReturn:(FORMTextField *)textField;

@end
