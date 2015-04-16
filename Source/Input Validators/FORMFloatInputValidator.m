#import "FORMFloatInputValidator.h"
#import "NSString+HYPContainsString.h"

@implementation FORMFloatInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range {
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    BOOL hasDelimiter = ([text hyp_containsString:@","] || [text hyp_containsString:@"."]);
    BOOL stringIsNilOrComma = (!string || [string isEqualToString:@","]);

    if (hasDelimiter && stringIsNilOrComma) return NO;

    NSCharacterSet *floatSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890,"];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    return [floatSet isSupersetOfSet:stringSet];
}

@end
