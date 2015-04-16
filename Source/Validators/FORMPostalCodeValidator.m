#import "FORMPostalCodeValidator.h"
#import "FORMPostalCodeManager.h"

@implementation FORMPostalCodeValidator

- (FORMValidationResultType)validateFieldValue:(id)fieldValue {
    BOOL postalCodeIsValid = ([[FORMPostalCodeManager sharedManager] validatePostalCode:fieldValue]);

    if (!postalCodeIsValid) {
        return FORMValidationResultTypeInvalidPostalCode;
    } else {
        return FORMValidationResultTypeValid;
    }
}

@end
