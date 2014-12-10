#import "HYPFloatInputValidator.h"

@implementation HYPFloatInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range
{
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    BOOL hasDelimiter = ([text containsString:@","] || [text containsString:@"."]);
    BOOL stringIsNilOrComma = (!string || [string isEqualToString:@","]);

    if (hasDelimiter && stringIsNilOrComma) return NO;

    NSCharacterSet *floatSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890,"];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    return [floatSet isSupersetOfSet:stringSet];
}

@end
