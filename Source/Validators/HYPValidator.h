@import Foundation;

typedef NS_ENUM(NSInteger, HYPFormValidationResultType) {
    HYPFormValidationResultTypeNone = 0,
    HYPFormValidationResultTypePassed,
    HYPFormValidationResultTypeTooShort,
    HYPFormValidationResultTypeTooLong,
    HYPFormValidationResultTypeValueMissing,
    HYPFormValidationResultTypeInvalidFormat,
    HYPFormValidationResultTypeInvalidEmail,
    HYPFormValidationResultTypeInvalidSSN,
    HYPFormValidationResultTypeInvalidPostalCode,
    HYPFormValidationResultTypeInvalidBankAccount,
    HYPFormValidationResultTypeOther
};

@interface HYPValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (HYPFormValidationResultType)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
