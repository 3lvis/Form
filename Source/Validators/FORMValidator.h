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

@interface FORMValidator : NSObject

- (instancetype)initWithValidation:(FORMFieldValidation *)validation;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue;
- (FORMValidationResultType)validateFieldValue:(id)fieldValue withDependentValue:(id)dependentValue withComparator:(NSString *)comparator;
+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
