#import "HYPPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation HYPPostalCodeValidator

- (HYPFormValidationResultType)validateFieldValue:(id)fieldValue
{
    BOOL postalCodeIsValid = ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]);

    if (!postalCodeIsValid) {
        return HYPFormValidationResultTypeInvalidPostalCode;
    } else {
        return HYPFormValidationResultTypePassed;
    }
}

@end
