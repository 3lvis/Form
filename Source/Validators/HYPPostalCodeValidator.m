#import "HYPPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation HYPPostalCodeValidator

- (HYPFormValidation)validateFieldValue:(id)fieldValue
{
    BOOL postalCodeIsValid = ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]);

    if (!postalCodeIsValid) {
        return HYPFormValidationInvalidPostalCode;
    } else {
        return HYPFormValidationPassed;
    }
}

@end
