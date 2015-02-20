@import Foundation;

typedef NS_ENUM(NSInteger, HYPFormValidationType) {
    HYPFormValidationTypeUnknown = 0,
    HYPFormValidationTypePassed = 1,
    HYPFormValidationTypeTooShort,
    HYPFormValidationTypeTooLong,
    HYPFormValidationTypeValueMissing,
    HYPFormValidationTypeInvalidFormat,
    HYPFormValidationTypeInvalidEmail,
    HYPFormValidationTypeInvalidSSN,
    HYPFormValidationTypeInvalidPostalCode,
    HYPFormValidationTypeInvalidBankAccount,
    HYPFormValidationTypeCustom
};

@interface HYPValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (HYPFormValidationType)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
