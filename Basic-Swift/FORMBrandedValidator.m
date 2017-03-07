#import "FORMBrandedValidator.h"

@implementation FORMBrandedValidator

- (FORMValidationResultType)validateFieldValue:(id)fieldValue {
    FORMValidationResultType superValidation = [super validateFieldValue:fieldValue];
    if (superValidation != FORMValidationResultTypeValid) return superValidation;

    return FORMValidationResultTypeInvalid;
}

@end
