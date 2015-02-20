#import "HYPPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation HYPPostalCodeValidator

- (HYPFormValidationType)validateFieldValue:(id)fieldValue
{
    BOOL postalCodeIsValid = ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]);

    if (!postalCodeIsValid) {
        return HYPFormValidationTypeInvalidPostalCode;
    } else {
        return HYPFormValidationTypePassed;
    }
}

@end
