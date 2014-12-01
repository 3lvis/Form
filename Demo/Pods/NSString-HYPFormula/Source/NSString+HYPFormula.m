#import "NSString+HYPFormula.h"

#import "NSString+HYPWordExtractor.h"

@implementation NSString (HYPFormula)

- (NSString *)hyp_processValuesDictionary:(NSDictionary *)valuesDictionary;
{
    NSArray *variables = [self hyp_variables];
    BOOL isStringFormula = [self isStringFormulaWithValuesDictionary:valuesDictionary];
    BOOL moreVariablesThanValues = ([valuesDictionary allKeys].count < variables.count);
    if (moreVariablesThanValues) return nil;

    NSMutableString *mutableString = [self mutableCopy];
    NSArray *sortedKeysArray = [[valuesDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return a.length < b.length;
    }];

    NSInteger foundCount = 0;

    for (NSString *key in sortedKeysArray) {

        BOOL keyWasFoundInFormula = ([self rangeOfString:key].location != NSNotFound);
        if (keyWasFoundInFormula) foundCount++;

        id value = valuesDictionary[key];

        if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
            value = [value stringValue];
        } else if ([value isKindOfClass:[NSString class]]) {
            NSString *stringValue = (NSString *)value;
            if (!stringValue || stringValue.length == 0) {
                value = (isStringFormula) ? @"" : @"0";
            }
        } else if ([value isKindOfClass:[NSNull class]]) {
            value = (isStringFormula) ? @"" : @"0";
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }

    BOOL numberOfFoundIsDifferentThanNumberOfValues = (foundCount < variables.count);
    if (numberOfFoundIsDifferentThanNumberOfValues) return nil;

    return [mutableString copy];
}

- (id)hyp_runFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary
{
    BOOL isStringFormula = [self isStringFormulaWithValuesDictionary:valuesDictionary];
    NSString *processedFormula = [self hyp_processValuesDictionary:valuesDictionary];
    if (isStringFormula) return processedFormula;

    NSString *formula = [processedFormula sanitize];

    if ([formula rangeOfString:@". "].location != NSNotFound) return nil;

    NSExpression *expression = [NSExpression expressionWithFormat:formula];
    id value = [expression expressionValueWithObject:nil context:nil];

    return value;
}

#pragma mark - Private methods

- (NSString *)sanitize
{
    if (![self isValidExpression]) return nil;

    NSString *formula = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSScanner *scanner = [NSScanner scannerWithString:formula];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    NSString *variable;

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:set intoString:&variable]) {
            NSUInteger numberOfOccurrences = [[variable componentsSeparatedByString:@"."] count] - 1;

            if (numberOfOccurrences > 1) {
                NSString *subString = [variable substringToIndex:variable.length-2];
                formula = [formula stringByReplacingOccurrencesOfString:variable withString:subString];
            }
        }

        if (scanner.scanLocation < formula.length) scanner.scanLocation++;
    }

    return formula;
}

- (BOOL)isValidExpression
{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (!string || string.length <= 0) return NO;

    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"(1234567890)"];
    NSCharacterSet *verboseSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890.,+-*/%() "];
    char firstCharacter = [string characterAtIndex:0];
    char lastCharacter  = [string characterAtIndex:string.length-1];

    if (![[string stringByTrimmingCharactersInSet:verboseSet] isEqualToString:@""]) return NO;
    if (![set characterIsMember:lastCharacter]) return NO;
    if (![set characterIsMember:firstCharacter]) return NO;

    return YES;
}

- (BOOL)isStringFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890.,+-*/\%() "];
    BOOL isStringFormula = NO;
    NSArray *values = [valuesDictionary allValues];

    for (id value in values) {
        if ([value isKindOfClass:[NSString class]] &&
            (![[value stringByTrimmingCharactersInSet:set] isEqualToString:@""])) {
            isStringFormula = YES;
            break;
        }
    }

    return isStringFormula;
}

@end
