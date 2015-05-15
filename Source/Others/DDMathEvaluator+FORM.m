#import "DDMathEvaluator+FORM.h"
#import "DDExpression.h"
#import "_DDVariableExpression.h"
@import HYPMathParser._DDVariableExpression;

@implementation DDMathEvaluator (FORM)

+ (NSDictionary *)hyp_directoryFunctions {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];

    mutableDictionary[@"equals"] = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {

        if (args.count < 2) {
            *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                         code:DDErrorCodeInvalidNumberOfArguments
                                     userInfo:@{NSLocalizedDescriptionKey : @"Invalid number of variables"}];
        }

        NSArray *arguments = [args subarrayWithRange:NSMakeRange(1, args.count-1)];
        NSNumber *isEqual = @YES;
        NSString *baseKey = [args[0] variable];
        id baseValue = (variables[baseKey]) ?: baseKey;
        id otherValue;

        for (DDExpression *expression in arguments) {
            if (![expression isKindOfClass:[_DDVariableExpression class]]) {
                isEqual = @NO;
                break;
            }

            otherValue = (variables[expression.variable]) ?: expression.variable;

            if (![baseValue isEqual:otherValue]) {
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
        BOOL isEmptyString = ([baseValue isKindOfClass:[NSString class]] && [baseValue length] < 1);
        NSNumber *present = (baseValueIsPresent && !isEmptyString) ? @YES : @NO;

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
        BOOL isEmptyString = ([baseValue isKindOfClass:[NSString class]] && [baseValue length] < 1);
        NSNumber *missing = (baseValueIsMissing || isEmptyString) ? @YES : @NO;

        return [DDExpression numberExpressionWithNumber:missing];
    };

    return [mutableDictionary copy];
}

@end
