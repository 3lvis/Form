//
//  NSString+HYPFormula.m
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPFormula.h"

@implementation NSString (HYPFormula)

- (NSString *)hyp_processValues:(NSDictionary *)values
{
    NSMutableString *mutableString = [self mutableCopy];
    NSArray *sortedKeysArray = [[values allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return a.length < b.length;
    }];

    for (NSString *key in sortedKeysArray) {
        id value = values[key];

        if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
            value = [value stringValue];
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }

    return [mutableString copy];
}

- (id)hyp_runFormulaWithDictionary:(NSDictionary *)dictionary
{
    NSString *formula = [[self hyp_processValues:dictionary] sanitize];

    if ([formula rangeOfString:@". "].location != NSNotFound) return nil;

    if ([self isStringFormula:[dictionary allValues]]) return formula;

    if (![formula isValidExpression]) return nil;

    NSExpression *expression = [NSExpression expressionWithFormat:formula];
    id value = [expression expressionValueWithObject:nil context:nil];

    return value;
}

@end

#pragma mark - Private categories

@implementation NSString (HYPFormulaTest)

- (NSString *)sanitize
{
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
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"(1234567890)"];
    NSCharacterSet *verboseSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890.,+-*/%() "];
    char firstCharacter = [string characterAtIndex:0];
    char lastCharacter  = [string characterAtIndex:string.length-1];

    if (![[string stringByTrimmingCharactersInSet:verboseSet] isEqualToString:@""]) {
        return NO;
    }

    if (![set characterIsMember:lastCharacter]) {
        return NO;
    }

    if (![set characterIsMember:firstCharacter]) {
        return NO;
    }

    return YES;
}

- (BOOL)isStringFormula:(NSArray *)values
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890.,+-*/%() "];

    for (id value in values) {
        if ([value isKindOfClass:[NSString class]]) {
            return (![[value stringByTrimmingCharactersInSet:set] isEqualToString:@""]);
        }
    }

    return NO;
}

@end
