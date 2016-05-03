#import "FORMFloatInputValidator.h"
#import "NSString+HYPContainsString.h"

@implementation FORMFloatInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range {
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    NSString *decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];

    BOOL hasDelimiter = ([text hyp_containsString:@","] || [text hyp_containsString:@"."]);
    BOOL stringIsNilOrDecimalSeparator = (!string || [string isEqualToString:decimalSeparator]);

    if (hasDelimiter && stringIsNilOrDecimalSeparator) return NO;

    NSCharacterSet *floatSet = [NSCharacterSet characterSetWithCharactersInString: [NSString stringWithFormat:@"1234567890%@", decimalSeparator]];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    return [floatSet isSupersetOfSet:stringSet];
}

@end
