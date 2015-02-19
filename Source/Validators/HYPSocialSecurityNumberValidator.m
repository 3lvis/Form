#import "HYPSocialSecurityNumberValidator.h"

#import "HYPNorwegianSSN.h"

@implementation HYPSocialSecurityNumberValidator

- (HYPFormValidation)validateFieldValue:(id)fieldValue
{
    HYPFormValidation superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationPassed) return superValidation;

    NSString *SSNString = (NSString *)fieldValue;
    if (![HYPNorwegianSSN validateWithString:SSNString]) {
        return HYPFormValidationInvalidSSN;
    } else {
        return HYPFormValidationPassed;
    }
}

@end
