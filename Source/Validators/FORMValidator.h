@import Foundation;

#import "FORMFieldValidation.h"

typedef NS_ENUM(NSInteger, FORMValidationResultType) {
    FORMValidationResultTypeValid = 0,
    FORMValidationResultTypeInvalid,
    FORMValidationResultTypeInvalidValue,
    FORMValidationResultTypeInvalidBankAccount,
    FORMValidationResultTypeInvalidFormat,
    FORMValidationResultTypeInvalidPostalCode,
    FORMValidationResultTypeInvalidSSN,
    FORMValidationResultTypeInvalidTooLong,
    FORMValidationResultTypeInvalidTooShort,
    FORMValidationResultTypeInvalidValueMissing
};

@interface FORMValidator : NSObject

- (instancetype)initWithValidation:(FORMFieldValidation *)validation NS_DESIGNATED_INITIALIZER;

- (FORMValidationResultType)validateFieldValue:(id)fieldValue;

- (FORMValidationResultType)validateFieldValue:(id)fieldValue
                            withDependentValue:(id)dependentValue
                                withComparator:(NSString *)comparator;

+ (Class)classForKey:(NSString *)key andType:(NSString *)type;

@end
