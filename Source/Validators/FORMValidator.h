@import Foundation;

#import "FORMFieldValidation.h"

typedef NS_ENUM(NSInteger, FORMValidationResultType) {
    FORMValidationResultTypeNone = 0,
    FORMValidationResultTypeInvalid,
    FORMValidationResultTypeInvalidBankAccount,
    FORMValidationResultTypeInvalidEmail,
    FORMValidationResultTypeInvalidFormat,
    FORMValidationResultTypeInvalidPostalCode,
    FORMValidationResultTypeInvalidSSN,
    FORMValidationResultTypeTooLong,
    FORMValidationResultTypeTooShort,
    FORMValidationResultTypeValid,
    FORMValidationResultTypeValueMissing,
    FORMValidationResultTypeOther
};

@interface FORMValidator : NSObject

- (instancetype)initWithValidation:(FORMFieldValidation *)validation;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue withDependentValue:(id)dependentValue withComparator:(NSString *)comparator;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
