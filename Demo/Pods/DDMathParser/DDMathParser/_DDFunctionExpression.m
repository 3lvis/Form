//
//  _DDFunctionExpression.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathParser.h"
#import "_DDFunctionExpression.h"
#import "DDMathEvaluator.h"
#import "DDMathEvaluator+Private.h"
#import "_DDNumberExpression.h"
#import "_DDVariableExpression.h"
#import "DDMathParserMacros.h"

@interface DDExpression ()

- (void)_setParentExpression:(DDExpression *)parent;

@end

@implementation _DDFunctionExpression {
	NSString *_function;
	NSArray *_arguments;
}

- (id)initWithFunction:(NSString *)f arguments:(NSArray *)a error:(NSError **)error {
	self = [super init];
	if (self) {
		for (id arg in a) {
			if ([arg isKindOfClass:[DDExpression class]] == NO) {
				if (error != nil) {
                    *error = ERR(DDErrorCodeInvalidArgument, @"function arguments must be DDExpression objects");
				}
				return nil;
			}
		}
		
		_function = [f copy];
		_arguments = [a copy];
        for (DDExpression *argument in _arguments) {
            [argument _setParentExpression:self];
        }
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *f = [aDecoder decodeObjectForKey:@"function"];
    NSArray *a = [aDecoder decodeObjectForKey:@"arguments"];
    return [self initWithFunction:f arguments:a error:NULL];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self function] forKey:@"function"];
    [aCoder encodeObject:[self arguments] forKey:@"arguments"];
}

- (id)copyWithZone:(NSZone *)zone {
    NSMutableArray *newArguments = [NSMutableArray array];
    for (id<NSCopying> arg in [self arguments]) {
        [newArguments addObject:[arg copyWithZone:zone]];
    }
    
    return [[[self class] alloc] initWithFunction:[self function] arguments:newArguments error:nil];
}

- (DDExpressionType)expressionType { return DDExpressionTypeFunction; }

- (NSString *)function { return [_function lowercaseString]; }
- (NSArray *)arguments { return _arguments; }

- (DDExpression *)simplifiedExpressionWithEvaluator:(DDMathEvaluator *)evaluator error:(NSError **)error {
	BOOL canSimplify = YES;
    
    NSMutableArray *newSubexpressions = [NSMutableArray array];
	for (DDExpression * e in [self arguments]) {
		DDExpression * a = [e simplifiedExpressionWithEvaluator:evaluator error:error];
		if (!a) { return nil; }
        canSimplify &= [a expressionType] == DDExpressionTypeNumber;
        [newSubexpressions addObject:a];
	}
	
	if (canSimplify) {
		if (evaluator == nil) { evaluator = [DDMathEvaluator defaultMathEvaluator]; }
		
        id result = [evaluator evaluateExpression:self withSubstitutions:nil error:error];
		
		if ([result isKindOfClass:[_DDNumberExpression class]]) {
			return result;
		} else if ([result isKindOfClass:[NSNumber class]]) {
			return [DDExpression numberExpressionWithNumber:result];
		}		
	}
	
	return [DDExpression functionExpressionWithFunction:[self function] arguments:newSubexpressions error:error];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@(%@)", [self function], [[[self arguments] valueForKey:@"description"] componentsJoinedByString:@","]];
}

@end
