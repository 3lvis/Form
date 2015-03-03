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

@protocol HYPTextFieldDelegate;

@interface FORMTextField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic, strong) FORMInputValidator *inputValidator;
@property (nonatomic, strong) FORMFormatter *formatter;

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic) FORMTextFieldType type;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;

@property (nonatomic, weak) id <HYPTextFieldDelegate> textFieldDelegate;

- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

@end

@protocol HYPTextFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(FORMTextField *)textField;

- (void)textFormFieldDidEndEditing:(FORMTextField *)textField;

- (void)textFormField:(FORMTextField *)textField didUpdateWithText:(NSString *)text;

- (void)textFormFieldDidReturn:(FORMTextField *)textField;

@end
