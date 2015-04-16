#import "FORMBankAccountNumberValidator.h"

#import "HYPNorwegianAccountNumber.h"

@implementation FORMBankAccountNumberValidator

- (FORMValidationResultType)validateFieldValue:(id)fieldValue {
    FORMValidationResultType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != FORMValidationResultTypeValid) return superValidation;

    NSString *accountNumber = (NSString *)fieldValue;
    BOOL validationPassed = [HYPNorwegianAccountNumber validateWithString:accountNumber];

    if (!validationPassed) {
        return FORMValidationResultTypeInvalidBankAccount;
    } else {
        return FORMValidationResultTypeValid;
    }
}

@end
