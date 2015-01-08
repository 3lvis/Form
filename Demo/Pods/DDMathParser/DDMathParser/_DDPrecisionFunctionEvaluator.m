//
//  _DDPrecisionFunctionEvaluator.m
//  DDMathParser
//
//  Created by Dave DeLong on 10/20/12.
//
//

#import "_DDPrecisionFunctionEvaluator.h"
#import "DDExpression.h"
#import "DDMathEvaluator+Private.h"
#import "DDMathOperator.h"
#import "_DDDecimalFunctions.h"

@implementation _DDPrecisionFunctionEvaluator

- (DDExpression *)add:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
	
	NSNumber *secondValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(secondValue);
    
    NSDecimal decimal = DDDecimalAdd([firstValue decimalValue], [secondValue decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
    return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)subtract:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
	NSNumber *secondValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(secondValue);
    NSDecimal decimal = DDDecimalSubtract([firstValue decimalValue], [secondValue decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)multiply:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
	NSNumber *secondValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(secondValue);
    NSDecimal decimal = DDDecimalMultiply([firstValue decimalValue], [secondValue decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)divide:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
	NSNumber *secondValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(secondValue);
    NSDecimal decimal = DDDecimalDivide([firstValue decimalValue], [secondValue decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)mod:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
	NSNumber *secondValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(secondValue);
    NSDecimal decimal = DDDecimalMod([firstValue decimalValue], [secondValue decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
    return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)negate:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
    NSDecimal decimal = [firstValue decimalValue];
    DDDecimalNegate(&decimal);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)factorial:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *firstValue = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(firstValue);
    
    NSNumber *result = nil;
    NSDecimal decimal = [firstValue decimalValue];
    if (DDDecimalIsInteger(decimal)) {
        if (DDDecimalIsNegative(decimal) == NO) {
            NSDecimal total = DDDecimalOne();
            NSDecimal one = DDDecimalOne();
            while (NSDecimalCompare(&decimal, &one) == NSOrderedDescending /* decimal > 1 */) {
                total = DDDecimalMultiply(total, decimal);
                decimal = DDDecimalSubtract(decimal, one);
            }
            result = [NSDecimalNumber decimalNumberWithDecimal:total];
        } else {
            result = @(NAN);
        }
    } else {
        result = @(tgamma([firstValue doubleValue]+1));
    }
    
    return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)pow:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *base = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(base);
	NSNumber *exponent = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(exponent);
    
    NSDecimal decimal = DDDecimalPower([base decimalValue], [exponent decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)nthroot:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *base = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(base);
	NSNumber *root = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(root);
    
    NSDecimal exponent = DDDecimalInverse([root decimalValue]);
    NSDecimal decimal = DDDecimalPower([base decimalValue], exponent);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

/**
 binary and, or, not, xor
 are not implemented with NSDecimal equivalents
 */

- (DDExpression *)rshift:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *first = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(first);
	NSNumber *second = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(second);
    NSDecimal decimal = DDDecimalRightShift([first decimalValue], [second decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)lshift:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(2);
	NSNumber *first = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(first);
	NSNumber *second = [[self evaluator] evaluateExpression:[arguments objectAtIndex:1] withSubstitutions:variables error:error];
	RETURN_IF_NIL(second);
    NSDecimal decimal = DDDecimalLeftShift([first decimalValue], [second decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)average:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_GTOE_N_ARGS(2);
    DDExpression *sumExpression = [self sum:arguments variables:variables error:error];
	RETURN_IF_NIL(sumExpression);
    
    NSDecimal sum = [[sumExpression number] decimalValue];
    NSDecimal count = DDDecimalFromInteger([arguments count]);
    NSDecimal decimal = DDDecimalDivide(sum, count);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sum:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_GTOE_N_ARGS(1);
    NSDecimal sum = DDDecimalZero();
	for (DDExpression *e in arguments) {
        NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
        RETURN_IF_NIL(n);
        sum = DDDecimalAdd(sum, [n decimalValue]);
	}
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:sum];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)count:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_GTOE_N_ARGS(1);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithMantissa:[arguments count] exponent:0 isNegative:NO]];
}

/**
 min and max do not need to be implemented in terms of NSDecimal
 */

- (DDExpression *)median:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_GTOE_N_ARGS(2);
	NSMutableArray *evaluatedNumbers = [NSMutableArray array];
	for (DDExpression *e in arguments) {
        NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
        RETURN_IF_NIL(n);
		[evaluatedNumbers addObject:n];
	}
	[evaluatedNumbers sortUsingSelector:@selector(compare:)];
	
	NSNumber *median = nil;
	if (([evaluatedNumbers count] % 2) == 1) {
		NSUInteger index = floor([evaluatedNumbers count] / 2);
		median = [evaluatedNumbers objectAtIndex:index];
	} else {
		NSUInteger lowIndex = floor([evaluatedNumbers count] / 2);
		NSUInteger highIndex = ceil([evaluatedNumbers count] / 2);
        NSNumber *low = [evaluatedNumbers objectAtIndex:lowIndex];
        NSNumber *high = [evaluatedNumbers objectAtIndex:highIndex];
        NSDecimal decimal = DDDecimalAverage2([low decimalValue], [high decimalValue]);
        median = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	}
	return [DDExpression numberExpressionWithNumber:median];
}

- (DDExpression *)stddev:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_GTOE_N_ARGS(2);
	DDExpression *avgExpression = [self average:arguments variables:variables error:error];
	RETURN_IF_NIL(avgExpression);
    
    NSDecimal avg = [[avgExpression number] decimalValue];
    NSDecimal stddev = DDDecimalZero();
    for (DDExpression *e in arguments) {
        NSNumber *argValue = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
        RETURN_IF_NIL(argValue);
        NSDecimal diff = DDDecimalSubtract(avg, [argValue decimalValue]);
        diff = DDDecimalPower(diff, DDDecimalTwo());
        stddev = DDDecimalAdd(stddev, diff);
    }
    stddev = DDDecimalDivide(stddev, DDDecimalFromInteger([arguments count]));
    stddev = DDDecimalSqrt(stddev);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:stddev];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sqrt:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSqrt([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

/**
 random does not need to be implemented in terms of NSDecimal
 */

- (DDExpression *)log:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(n);
    // FIXME: use high precision math
    NSNumber *result = @(log10([n doubleValue]));
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)ln:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(n);
    // FIXME: use high precision math
	return [DDExpression numberExpressionWithNumber:@(log([n doubleValue]))];
}

- (DDExpression *)log2:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(n);
    // FIXME: use high precision math
    NSNumber *result = @(log2([n doubleValue]));
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)exp:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
	NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
	RETURN_IF_NIL(n);
    // FIXME: use high precision math
    NSNumber *result = @(exp([n doubleValue]));
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)ceil:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = [n decimalValue];
    NSDecimalRound(&decimal, &decimal, 0, NSRoundUp);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)abs:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = [n decimalValue];
    if (DDDecimalIsNegative(decimal)) {
        DDDecimalNegate(&decimal);
    }
    
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)floor:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = [n decimalValue];
    NSDecimalRound(&decimal, &decimal, 0, NSRoundDown);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)percent:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
    REQUIRE_N_ARGS(1);
    DDExpression *percentArgument = [arguments objectAtIndex:0];
    DDExpression *percentExpression = [percentArgument parentExpression];
    DDExpression *percentContext = [percentExpression parentExpression];
    
    NSString *parentFunction = [percentContext function];
    DDMathOperator *operatorInfo = [DDMathOperator infoForOperatorFunction:parentFunction];
    
    NSNumber *context = @1;
    
    if ([operatorInfo arity] == DDOperatorArityBinary) {
        if ([parentFunction isEqualToString:DDOperatorAdd] || [parentFunction isEqualToString:DDOperatorMinus]) {
            
            BOOL percentIsRightArgument = ([[percentContext arguments] objectAtIndex:1] == percentExpression);
            
            if (percentIsRightArgument) {
                DDExpression *baseExpression = [[percentContext arguments] objectAtIndex:0];
                context = [[self evaluator] evaluateExpression:baseExpression withSubstitutions:variables error:error];
                
            }
        }
    }
    
    NSNumber *percent = [[self evaluator] evaluateExpression:percentArgument withSubstitutions:variables error:error];
    
    RETURN_IF_NIL(context);
    RETURN_IF_NIL(percent);
    
    NSDecimal decimal = [percent decimalValue];
    NSDecimal oneHundred = DDDecimalFromInteger(100);
    decimal = DDDecimalDivide(decimal, oneHundred);
    decimal = DDDecimalMultiply([context decimalValue], decimal);
    NSNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
    return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSin([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)cos:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCos([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)tan:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalTan([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)asin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAsin([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)acos:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcos([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)atan:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAtan([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)sinh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSinh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)cosh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCosh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)tanh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalTanh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)asinh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAsinh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)acosh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcosh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)atanh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAtanh([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)csc:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCsc([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sec:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSec([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)cotan:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCot([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)acsc:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcsc([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)asec:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAsec([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)acotan:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcot([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)csch:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCsch([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sech:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSech([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)cotanh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCoth([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)acsch:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcsch([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)asech:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAsech([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}

- (DDExpression *)acotanh:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalAcoth([n decimalValue]);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return _DDRTOD([DDExpression numberExpressionWithNumber:result], [self evaluator], error);
}
// more trig functions
- (DDExpression *)versin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCos([n decimalValue]);
    decimal = DDDecimalSubtract(DDDecimalOne(), decimal);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)vercosin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCos([n decimalValue]);
    decimal = DDDecimalAdd(DDDecimalOne(), decimal);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)coversin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSin([n decimalValue]);
    decimal = DDDecimalSubtract(DDDecimalOne(), decimal);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)covercosin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSin([n decimalValue]);
    decimal = DDDecimalAdd(DDDecimalOne(), decimal);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)haversin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [self versin:arguments variables:variables error:error];
    RETURN_IF_NIL(e);
    
    NSDecimal decimal = [[e number] decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalTwo());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)havercosin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [self vercosin:arguments variables:variables error:error];
    RETURN_IF_NIL(e);
    
    NSDecimal decimal = [[e number] decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalTwo());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)hacoversin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [self coversin:arguments variables:variables error:error];
    RETURN_IF_NIL(e);
    
    NSDecimal decimal = [[e number] decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalTwo());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)hacovercosin:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [self covercosin:arguments variables:variables error:error];
    RETURN_IF_NIL(e);
    
    NSDecimal decimal = [[e number] decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalTwo());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)exsec:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCos([n decimalValue]);
    DDDecimalInvert(&decimal);
    decimal = DDDecimalSubtract(decimal, DDDecimalOne());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)excsc:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalSin([n decimalValue]);
    DDDecimalInvert(&decimal);
    decimal = DDDecimalSubtract(decimal, DDDecimalOne());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)crd:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    DDExpression *e = [arguments objectAtIndex:0];
    e = _DDDTOR(e, [self evaluator], error);
    NSNumber *n = [[self evaluator] evaluateExpression:e withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = DDDecimalCos([n decimalValue]);
    decimal = DDDecimalMultiply(DDDecimalTwo(), decimal);
    decimal = DDDecimalDivide(decimal, DDDecimalTwo());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)dtor:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = [n decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalFromInteger(180));
    decimal = DDDecimalMultiply(decimal, DDDecimalPi());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)rtod:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
	REQUIRE_N_ARGS(1);
    NSNumber *n = [[self evaluator] evaluateExpression:[arguments objectAtIndex:0] withSubstitutions:variables error:error];
    RETURN_IF_NIL(n);
    
    NSDecimal decimal = [n decimalValue];
    decimal = DDDecimalDivide(decimal, DDDecimalPi());
    decimal = DDDecimalMultiply(decimal, DDDecimalFromInteger(180));
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}
#pragma mark Constant Functions
- (DDExpression *)phi:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:DDDecimalPhi()];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)pi:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi()];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)pi_2:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi_2()];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)pi_4:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi_4()];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)tau:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalMultiply(DDDecimalTwo(), DDDecimalPi());
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)sqrt2:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalSqrt2();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)e:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalE();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)log2e:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalLog2e();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)log10e:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalLog10e();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)ln2:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalLn2();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}

- (DDExpression *)ln10:(NSArray *)arguments variables:(NSDictionary *)variables error:(NSError **)error {
#pragma unused(variables)
	REQUIRE_N_ARGS(0);
    NSDecimal decimal = DDDecimalLn10();
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return [DDExpression numberExpressionWithNumber:result];
}
/**
 The logical and, or, not, eq, neq, lt, gt, ltoe, and gtoe functions
 don't need to be implemented in terms of NSDecimal
 */

@end
