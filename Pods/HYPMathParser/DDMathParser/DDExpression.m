//
//  DDExpression.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathParser.h"
#import "DDExpression.h"
#import "DDMathEvaluator.h"
#import "DDMathEvaluator+Private.h"
#import "DDParser.h"

#import "_DDNumberExpression.h"
#import "_DDFunctionExpression.h"
#import "_DDVariableExpression.h"


@implementation DDExpression

+ (id)expressionFromString:(NSString *)expressionString error:(NSError **)error {
    DDParser *parser = [DDParser parserWithString:expressionString error:error];
    return [parser parsedExpressionWithError:error];
}

+ (id)numberExpressionWithNumber:(NSNumber *)number {
	return [[_DDNumberExpression alloc] initWithNumber:number];
}

+ (id)functionExpressionWithFunction:(NSString *)function arguments:(NSArray *)arguments error:(NSError **)error {
	return [[_DDFunctionExpression alloc] initWithFunction:function arguments:arguments error:error];
}

+ (id)variableExpressionWithVariable:(NSString *)variable {
	return [[_DDVariableExpression alloc] initWithVariable:variable];
}

#pragma mark -
#pragma mark Abstract method implementations

- (id)copyWithZone:(NSZone *)zone {
	[NSException raise:NSInternalInconsistencyException format:@"this method should be overridden: %@", NSStringFromSelector(_cmd)];
    return nil;
}

- (DDExpressionType)expressionType {
	[NSException raise:NSInternalInconsistencyException format:@"this method should be overridden: %@", NSStringFromSelector(_cmd)];
	return DDExpressionTypeNumber;
}
- (NSNumber *)evaluateWithSubstitutions:(NSDictionary *)substitutions evaluator:(DDMathEvaluator *)evaluator error:(NSError **)error {
	return [evaluator evaluateExpression:self withSubstitutions:substitutions error:error];
}
- (DDExpression *)simplifiedExpression {
	NSError *error = nil;
	DDExpression *simplified = [self simplifiedExpressionWithEvaluator:[DDMathEvaluator defaultMathEvaluator] error:&error];
	if (error != nil) {
		NSLog(@"error: %@", error);
		return nil;
	}
	return simplified;
}
- (DDExpression *)simplifiedExpressionWithEvaluator:(DDMathEvaluator *)evaluator error:(NSError **)error {
#pragma unused(evaluator, error)
	[NSException raise:NSInvalidArgumentException format:@"this method should be overridden: %@", NSStringFromSelector(_cmd)]; 
	return nil; 
}
- (NSNumber *)number { 
	[NSException raise:NSInternalInconsistencyException format:@"This is not a numeric expression"]; 
	return nil; 
}
- (NSString *)function { 
	[NSException raise:NSInvalidArgumentException format:@"This is not a function expression"]; 
	return nil; 
}
- (NSArray *)arguments { 
	[NSException raise:NSInvalidArgumentException format:@"This is not a function expression"]; 
	return nil; 
}
- (NSString *)variable { 
	[NSException raise:NSInvalidArgumentException format:@"This is not a variable expression"]; 
	return nil; 
}
- (NSUInteger)hash {
    if ([self expressionType] == DDExpressionTypeNumber) {
        return [[self number] hash];
    } else if ([self expressionType] == DDExpressionTypeVariable) {
        return [[self variable] hash];
    } else if ([self expressionType] == DDExpressionTypeFunction) {
        return [[self function] hash];
    }
    return [super hash];
}
- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[DDExpression class]] == NO) { return NO; }
	DDExpression * expression = (DDExpression *)object;
	if ([expression expressionType] != [self expressionType]) { return NO; }
	if ([self expressionType] == DDExpressionTypeNumber) {
		return [[self number] isEqualToNumber:[expression number]];
	}
	if ([self expressionType] == DDExpressionTypeVariable) {
		return [[self variable] isEqual:[expression variable]];
	}
	if ([self expressionType] == DDExpressionTypeFunction) {
		return ([[self function] isEqual:[expression function]] &&
				[[self arguments] isEqual:[expression arguments]]);
	}
	return NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
#pragma unused(aDecoder)
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
#pragma unused(aCoder)
    return;
}

- (void)_setParentExpression:(DDExpression *)parent {
    _parentExpression = parent;
}

@end
