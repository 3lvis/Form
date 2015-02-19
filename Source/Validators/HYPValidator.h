@import Foundation;

typedef NS_ENUM(NSInteger, HYPFormValidation) {
    HYPFormValidationUnknown = 0,
    HYPFormValidationPassed = 1,
    HYPFormValidationTooShort,
    HYPFormValidationTooLong,
    HYPFormValidationValueMissing,
    HYPFormValidationInvalidFormat,
    HYPFormValidationInvalidEmail,
    HYPFormValidationInvalidSSN,
    HYPFormValidationInvalidPostalCode,
    HYPFormValidationInvalidBankAccount,
    HYPFormValidationCustom
};

@interface HYPValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (BOOL)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
