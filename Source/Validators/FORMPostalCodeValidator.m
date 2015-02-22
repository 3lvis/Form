#import "FORMPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation FORMPostalCodeValidator

- (FORMValidationResultType)validateFieldValue:(id)fieldValue
{
    BOOL postalCodeIsValid = ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]);

    if (!postalCodeIsValid) {
        return FORMValidationResultTypeInvalidPostalCode;
    } else {
        return FORMValidationResultTypePassed;
    }
}

@end
