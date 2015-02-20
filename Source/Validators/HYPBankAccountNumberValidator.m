#import "HYPBankAccountNumberValidator.h"

#import "HYPNorwegianAccountNumber.h"

@implementation HYPBankAccountNumberValidator

- (HYPFormValidationResultType)validateFieldValue:(id)fieldValue
{
    HYPFormValidationResultType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationResultTypePassed) return superValidation;

    NSString *accountNumber = (NSString *)fieldValue;
    BOOL validationPassed = [HYPNorwegianAccountNumber validateWithString:accountNumber];

    if (!validationPassed) {
        return HYPFormValidationResultTypeInvalidBankAccount;
    } else {
        return HYPFormValidationResultTypePassed;
    }
}

@end
