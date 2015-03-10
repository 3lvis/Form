@import Foundation;

#import "FORMFieldValidation.h"

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

typedef NS_ENUM(NSInteger, FORMValidationRule) {
  FORMValidationRuleLessThanOrEqualTo,
  FORMValidationRuleGreaterThan,
  FORMValidationRuleGreaterThanOrEqualTo,
  FORMValidationRuleEqualTo,

@interface FORMValidator : NSObject

- (instancetype)initWithValidation:(FORMFieldValidation *)validation;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
