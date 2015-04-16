#import "FORMNameInputValidator.h"

@implementation FORMNameInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range {
    BOOL valid = [super validateReplacementString:string withText:text withRange:range];

    if (!valid) return valid;

    if (!string) {
        return (text.length > 0);
    }

    NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];

    BOOL allowString = ([letterCharacterSet isSupersetOfSet:stringSet] ||
                        [whitespaceCharacterSet isSupersetOfSet:stringSet] ||
                        [delimiterSet isSupersetOfSet:stringSet]);
    if (allowString) return YES;

    return NO;
}

@end
