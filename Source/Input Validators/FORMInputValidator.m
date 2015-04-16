#import "FORMInputValidator.h"
#import "FORMNumberInputValidator.h"

@implementation FORMInputValidator

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text withRange:(NSRange)range {
    BOOL shouldSkipValidations = (text.length == 0 || string.length == 0 || !self.validation);
    if (shouldSkipValidations) return YES;

    NSUInteger textLength = [text length];

    if (string.length > 0) {
        textLength++;
    }

    BOOL valid = YES;

    if (self.validation.maximumLength) {
        valid = (textLength <= [self.validation.maximumLength unsignedIntegerValue]);
    }

    if (self.validation.maximumValue && text) {
        NSMutableString *newString = [[NSMutableString alloc] initWithString:text];
        [newString insertString:string atIndex:range.location];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSNumber *newValue = [formatter numberFromString:newString];
        NSNumber *maxValue = self.validation.maximumValue;

        BOOL eligibleForCompare = (newValue && maxValue);
        if (eligibleForCompare) valid = ([newValue floatValue] <= [maxValue floatValue]);
    }

    return valid;
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:format options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

@end
