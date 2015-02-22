#import "FORMSocialSecurityNumberValidator.h"

#import "HYPNorwegianSSN.h"

@implementation FORMSocialSecurityNumberValidator

- (FORMValidationResultType)validateFieldValue:(id)fieldValue
{
    FORMValidationResultType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != FORMValidationResultTypePassed) return superValidation;

    NSString *SSNString = (NSString *)fieldValue;
    if (![HYPNorwegianSSN validateWithString:SSNString]) {
        return FORMValidationResultTypeInvalidSSN;
    } else {
        return FORMValidationResultTypePassed;
    }
}

@end
