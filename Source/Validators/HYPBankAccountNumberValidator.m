#import "HYPBankAccountNumberValidator.h"

#import "HYPNorwegianAccountNumber.h"

@implementation HYPBankAccountNumberValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    if (![super validateFieldValue:fieldValue]) return NO;

    NSString *accountNumber = (NSString *)fieldValue;
    return [HYPNorwegianAccountNumber validateWithString:accountNumber];
}

@end
