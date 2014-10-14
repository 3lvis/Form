//
//  NSString+HYPFormula.m
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPFormula.h"

@implementation NSString (HYPFormula)

- (NSString *)processValues:(NSDictionary *)values
{
    __block NSMutableString *mutableString = [self mutableCopy];

    [values enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {

        if (![value isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"%@", value];
        }

        [mutableString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,mutableString.length)];
    }];

    return [mutableString copy];
}

- (id)runFormula
{
    NSExpression *expression = [NSExpression expressionWithFormat:self];
    id value = [expression expressionValueWithObject:nil context:nil];
    return value;
}

- (id)runFormulaWithDictionary:(NSDictionary *)dictionary
{
    NSString *formula = [self processValues:dictionary];
    return [formula runFormula];
}

@end
