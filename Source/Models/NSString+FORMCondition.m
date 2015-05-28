#import "NSString+FORMCondition.h"

#import "DDMathEvaluator+FORM.h"
@import HYPMathParser.DDExpression;

@implementation NSString (FORMCondition)

- (BOOL)evaluateWithValues:(NSDictionary *)values error:(NSError **)error {
    DDMathEvaluator *evaluator = [DDMathEvaluator defaultMathEvaluator];

    NSDictionary *functionDictonary = [DDMathEvaluator hyp_directoryFunctionsWithError:error];
    [functionDictonary enumerateKeysAndObjectsUsingBlock:^(id key, id function, BOOL *stop) {
        [evaluator registerFunction:function forName:key];
    }];

    BOOL evaluatedResult = NO;

    DDExpression *expression = [DDExpression expressionFromString:self error:error];
    if (values) {
        NSNumber *result = [evaluator evaluateExpression:expression
                                       withSubstitutions:values
                                                   error:error];
        evaluatedResult = [result boolValue];
    }

    return evaluatedResult;
}

@end
