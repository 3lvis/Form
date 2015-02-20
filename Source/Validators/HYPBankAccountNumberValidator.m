#import "HYPBankAccountNumberValidator.h"

#import "HYPNorwegianAccountNumber.h"

@implementation HYPBankAccountNumberValidator

- (HYPFormValidationType)validateFieldValue:(id)fieldValue
{
    HYPFormValidationType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationTypePassed) return superValidation;

    NSString *accountNumber = (NSString *)fieldValue;
    BOOL validationPassed = [HYPNorwegianAccountNumber validateWithString:accountNumber];

    if (!validationPassed) {
        return HYPFormValidationTypeInvalidBankAccount;
    } else {
        return HYPFormValidationTypePassed;
    }
}

@end
