#import "HYPSocialSecurityNumberValidator.h"

#import "HYPNorwegianSSN.h"

@implementation HYPSocialSecurityNumberValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    if (![super validateFieldValue:fieldValue]) return NO;

    NSString *ssn = (NSString *)fieldValue;
    return [HYPNorwegianSSN validateWithString:ssn];
}

@end
