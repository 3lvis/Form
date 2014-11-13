#import "HYPPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation HYPPostalCodeValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    return ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]) ?: NO;
}

@end
