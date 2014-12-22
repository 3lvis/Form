@import UIKit;

#import "HYPInputValidator.h"
#import "HYPFormatter.h"

typedef NS_ENUM(NSInteger, HYPTextFieldType) {
    HYPTextFieldTypeDefault = 0,
    HYPTextFieldTypeInfo,
    HYPTextFieldTypeName,
    HYPTextFieldTypeUsername,
    HYPTextFieldTypePhoneNumber,
    HYPTextFieldTypeNumber,
    HYPTextFieldTypeFloat,
    HYPTextFieldTypeAddress,
    HYPTextFieldTypeEmail,
    HYPTextFieldTypePassword,
    HYPTextFieldTypeSelect,
    HYPTextFieldTypeDate,
    HYPTextFieldTypeUnknown
};

@protocol HYPTextFieldDelegate;

@interface HYPTextField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic, strong) HYPInputValidator *inputValidator;
@property (nonatomic, strong) HYPFormatter *formatter;

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic) HYPTextFieldType type;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;

@property (nonatomic, weak) id <HYPTextFieldDelegate> textFieldDelegate;

@end

@protocol HYPTextFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(HYPTextField *)textField;

- (void)textFormFieldDidEndEditing:(HYPTextField *)textField;

- (void)textFormField:(HYPTextField *)textField didUpdateWithText:(NSString *)text;

- (void)textFormFieldDidReturn:(HYPTextField *)textField;

@end
