#import "FORMPostalCodeInputValidator.h"

@implementation FORMPostalCodeInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range {
    return [super validateReplacementString:string withText:text withRange:range];
}

@end
