@import Foundation;

typedef NS_ENUM(NSInteger, FORMValidationResultType) {
    FORMValidationResultTypeNone = 0,
    FORMValidationResultTypePassed,
    FORMValidationResultTypeTooShort,
    FORMValidationResultTypeTooLong,
    FORMValidationResultTypeValueMissing,
    FORMValidationResultTypeInvalidFormat,
    FORMValidationResultTypeInvalidEmail,
    FORMValidationResultTypeInvalidSSN,
    FORMValidationResultTypeInvalidPostalCode,
    FORMValidationResultTypeInvalidBankAccount,
    FORMValidationResultTypeOther
};

@interface FORMValidator : NSObject

- (instancetype)initWithValidations:(NSDictionary *)validations;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
