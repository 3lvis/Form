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

- (id)hyp_runFormula
{
    NSString *formula = self;
    formula = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];

    if ([formula rangeOfString:@". "].location != NSNotFound) {
        return nil;
    }

    NSExpression *expression = [NSExpression expressionWithFormat:formula];
    id value = [expression expressionValueWithObject:nil context:nil];
    return value;
}

- (id)hyp_runFormulaWithDictionary:(NSDictionary *)dictionary
{
    NSString *formula = [self hyp_processValues:dictionary];
    return [formula hyp_runFormula];
}

@end
