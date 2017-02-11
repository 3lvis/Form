#import "NSString+HYPFormula.h"

#import "NSString+HYPWordExtractor.h"

@implementation NSString (HYPFormula)

- (NSString *)hyp_processValuesDictionary:(NSDictionary *)valuesDictionary;
{
    NSArray *variables = [self hyp_variables];
    BOOL isNumberFormula = [self isNumberFormulaWithValuesDictionary:valuesDictionary];
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
                value = (isNumberFormula) ? @"0" : @"";
            }
        } else if ([value isKindOfClass:[NSNull class]]) {
            value = (isNumberFormula) ? @"0" : @"";
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }

    BOOL numberOfFoundIsDifferentThanNumberOfValues = (foundCount < variables.count);
    if (numberOfFoundIsDifferentThanNumberOfValues) return nil;

    return [mutableString copy];
}

- (id)hyp_runFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary
{
    NSString *cleanString = [self removeStrayDots];
    BOOL isNumberFormula = [cleanString isNumberFormulaWithValuesDictionary:valuesDictionary];
    NSString *processedFormula = [cleanString hyp_processValuesDictionary:valuesDictionary];
    id value = nil;

    if (isNumberFormula) {
        NSString *formula = [processedFormula sanitize];
        if ([formula rangeOfString:@". "].location != NSNotFound||
            [formula rangeOfString:@".."].location != NSNotFound) return nil;

        NSExpression *expression = [NSExpression expressionWithFormat:formula];
        value = [expression expressionValueWithObject:nil context:nil];
    } else {
        value = processedFormula;
    }

    return value;
}

#pragma mark - Private methods

- (NSString *)removeStrayDots
{
    NSMutableString *sanitizedString = [self mutableCopy];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    NSString *variable;
    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:set intoString:&variable]) {
            NSArray *components = [variable componentsSeparatedByString:@"."];
            NSUInteger numberOfOccurrences = [components count] - 1;
            if (numberOfOccurrences > 1) {
                NSMutableString *newString = [NSMutableString new];
                for (NSString *component in components) {
                    if ([component isEqual:[components lastObject]]) {
                        [newString appendString:@"."];
                    }
                    [newString appendString:component];
                }
                [sanitizedString replaceOccurrencesOfString:variable
                                                 withString:newString
                                                    options:NSCaseInsensitiveSearch
                                                      range:NSMakeRange(0, self.length)];
            }
        }
        if (scanner.scanLocation < self.length) scanner.scanLocation++;
    }

    return sanitizedString;
}

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

- (BOOL)isNumberFormulaWithValuesDictionary:(NSDictionary *)valuesDictionary
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890.,+-*/\%()"];
    BOOL isNumberFormula = NO;
    NSArray *values = [valuesDictionary allValues];

    for (id value in values) {
        if ([value isKindOfClass:[NSNumber class]] ||
            ([value isKindOfClass:[NSString class]] && [value length] > 0 &&
             [[value stringByTrimmingCharactersInSet:set] length] == 0)) {
            isNumberFormula = YES;
            break;
        }
    }

    return isNumberFormula;
}

@end
