#import "HYPSocialSecurityNumberValidator.h"

#import "HYPNorwegianSSN.h"

@implementation HYPSocialSecurityNumberValidator

- (HYPFormValidationResultType)validateFieldValue:(id)fieldValue
{
    HYPFormValidationResultType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != HYPFormValidationResultTypePassed) return superValidation;

    NSString *SSNString = (NSString *)fieldValue;
    if (![HYPNorwegianSSN validateWithString:SSNString]) {
        return HYPFormValidationResultTypeInvalidSSN;
    } else {
        return HYPFormValidationResultTypePassed;
    }
}

@end
