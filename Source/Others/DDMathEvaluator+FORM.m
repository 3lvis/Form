//
//  DDMathEvaluator+FORM.m
//  FORM
//
//  Created by Christoffer Winterkvist on 1/9/15.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

#import "DDMathEvaluator+FORM.h"
#import "DDExpression.h"
#import "_DDVariableExpression.h"

@implementation DDMathEvaluator (FORM)

+ (NSDictionary *)hyp_directoryFunctions {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];

    mutableDictionary[@"equals"] = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {

        if (args.count < 2) {
            *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                         code:DDErrorCodeInvalidNumberOfArguments
                                     userInfo:@{NSLocalizedDescriptionKey : @"Invalid number of variables"
                                                }];
        }

        NSArray *arguments = [args subarrayWithRange:NSMakeRange(1, args.count-1)];
        NSNumber *isEqual = @YES;
        NSString *baseKey = [args[0] variable];
        NSString *baseValue = (variables[baseKey]) ?: baseKey;
        NSString *otherValue;

        for (DDExpression *expression in arguments) {
            if (![expression isKindOfClass:[_DDVariableExpression class]]) {
                isEqual = @NO;
                break;
            }

            otherValue = (variables[expression.variable]) ?: expression.variable;

            if (![baseValue isEqualToString:otherValue]) {
                isEqual = @NO;
                break;
            }
        }

        return [DDExpression numberExpressionWithNumber:isEqual];
    };

    mutableDictionary[@"present"] = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {
        if (args.count != 1) {
            *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                         code:DDErrorCodeInvalidNumberOfArguments
                                     userInfo:@{NSLocalizedDescriptionKey : @"Invalid number of variables"
                                                }];
        }

        NSString *baseKey = [args[0] variable];
        NSString *baseValue = variables[baseKey];
        BOOL baseValueIsPresent = (baseValue || ![baseValue isKindOfClass:[NSNull class]]);
        NSNumber *present = (baseValueIsPresent) ? @YES : @NO;

        return [DDExpression numberExpressionWithNumber:present];
    };

    mutableDictionary[@"missing"] = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {
        if (args.count != 1) {
            *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                         code:DDErrorCodeInvalidNumberOfArguments
                                     userInfo:@{NSLocalizedDescriptionKey : @"Invalid number of variables"
                                                }];
        }

        NSString *baseKey = [args[0] variable];
        NSString *baseValue = variables[baseKey];
        BOOL baseValueIsMissing = (!baseValue || [baseValue isKindOfClass:[NSNull class]]);
        NSNumber *missing = (baseValueIsMissing) ? @YES : @NO;

        return [DDExpression numberExpressionWithNumber:missing];
    };

    return [mutableDictionary copy];
}

@end
