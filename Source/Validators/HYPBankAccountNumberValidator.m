#import "HYPBankAccountNumberValidator.h"

#import "HYPNorwegianAccountNumber.h"

@implementation HYPBankAccountNumberValidator

- (HYPFormValidation)validateFieldValue:(id)fieldValue
{
    HYPFormValidation superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationPassed) return superValidation;

    NSString *accountNumber = (NSString *)fieldValue;
    BOOL validationPassed = [HYPNorwegianAccountNumber validateWithString:accountNumber];

    if (!validationPassed) {
        return HYPFormValidationInvalidBankAccount;
    } else {
        return HYPFormValidationPassed;
    }
}

@end
