#import "HYPSocialSecurityNumberValidator.h"

#import "HYPNorwegianSSN.h"

@implementation HYPSocialSecurityNumberValidator

- (HYPFormValidationType)validateFieldValue:(id)fieldValue
{
    HYPFormValidationType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationTypePassed) return superValidation;

    NSString *SSNString = (NSString *)fieldValue;
    if (![HYPNorwegianSSN validateWithString:SSNString]) {
        return HYPFormValidationTypeInvalidSSN;
    } else {
        return HYPFormValidationTypePassed;
    }
}

@end
