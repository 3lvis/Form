//
//  DDMathEvaluator.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/17/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "DDMathParser.h"
#import "DDMathEvaluator.h"
#import "DDMathEvaluator+Private.h"
#import "DDMathStringTokenizer.h"
#import "DDParser.h"
#import "DDMathParserMacros.h"
#import "DDExpression.h"
#import "_DDFunctionEvaluator.h"
#import "_DDPrecisionFunctionEvaluator.h"
#import "DDExpressionRewriter.h"
#import <objc/runtime.h>


@implementation DDMathEvaluator {
	NSMutableDictionary * _functionMap;
    _DDFunctionEvaluator *_functionEvaluator;
}

+ (instancetype)defaultMathEvaluator {
    static DDMathEvaluator * _defaultEvaluator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		_defaultEvaluator = [[DDMathEvaluator alloc] init];
    });
	return _defaultEvaluator;
}

- (id)init {
	self = [super init];
	if (self) {
        _functionMap = [[NSMutableDictionary alloc] init];
        _angleMeasurementMode = DDAngleMeasurementModeRadians;
        _functionEvaluator = [[_DDFunctionEvaluator alloc] initWithMathEvaluator:self];
        _operatorSet = [DDMathOperatorSet defaultOperatorSet];
        
        NSDictionary *aliases = [[self class] _standardAliases];
        for (NSString *alias in aliases) {
            NSString *function = [aliases objectForKey:alias];
            [self addAlias:alias forFunctionName:function];
        }
	}
	return self;
}

#pragma mark - Properties

- (void)setUsesHighPrecisionEvaluation:(BOOL)usesHighPrecisionEvaluation {
    if (usesHighPrecisionEvaluation != _usesHighPrecisionEvaluation) {
        _usesHighPrecisionEvaluation = usesHighPrecisionEvaluation;
        
        if (_usesHighPrecisionEvaluation) {
            _functionEvaluator = [[_DDPrecisionFunctionEvaluator alloc] initWithMathEvaluator:self];
        } else {
            _functionEvaluator = [[_DDFunctionEvaluator alloc] initWithMathEvaluator:self];
        }
    }
}

#pragma mark - Functions

- (BOOL)registerFunction:(DDMathFunction)function forName:(NSString *)functionName {
    functionName = [functionName lowercaseString];
    
    // we cannot re-register a standard function
    if ([_DDFunctionEvaluator isStandardFunction:functionName]) {
        return NO;
    }
    
    // we cannot register something that is already registered
    if ([_functionMap objectForKey:functionName] != nil) {
        return NO;
    }
    
    function = [function copy];
    [_functionMap setObject:function forKey:functionName];
    
    return YES;
}

- (void)unregisterFunctionWithName:(NSString *)functionName {
    functionName = [functionName lowercaseString];
    [_functionMap removeObjectForKey:functionName];
}

- (NSArray *)registeredFunctions {
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObjectsFromArray:[[_DDFunctionEvaluator standardFunctions] array]];
    [array addObjectsFromArray:[_functionMap allKeys]];
    
    [array sortUsingSelector:@selector(compare:)];
    
    return array;
}

#pragma mark - Lazy Resolution

- (DDExpression *)resolveFunction:(_DDFunctionExpression *)functionExpression variables:(NSDictionary *)variables error:(NSError **)error {
    NSString *functionName = [functionExpression function];
    
    DDExpression *e = nil;
    DDMathFunction function = [_functionMap objectForKey:functionName];
    
    if (function == nil && [self resolvesFunctionsAsVariables]) {
        // see if we have a variable value with the same name as the function
        id variableValue = [variables objectForKey:functionName];
        NSNumber *n = [self _evaluateValue:variableValue withSubstitutions:variables error:error];
        if (n == nil) {
            n = [self variableWithName:functionName];
        }
        if (n != nil) {
            e = [DDExpression numberExpressionWithNumber:n];
        }
    }
    
    if (e == nil && function == nil && _functionResolver != nil) {
        function = _functionResolver(functionName);
    }
    
    if (e == nil && function != nil) {
        e = function([functionExpression arguments], variables, self, error);
    }
    
	if (e == nil && error != nil && *error == nil) {
        *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                     code:DDErrorCodeUnresolvedFunction
                                 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"unable to resolve function: %@", functionName],
                                            DDUnknownFunctionKey: functionName}];
	}
	return e;
}

- (id)variableWithName:(NSString *)variableName {
    id value = nil;
    if (_variableResolver != nil) {
        value = _variableResolver(variableName);
    }
    return value;
}

#pragma mark - Aliases

- (BOOL)addAlias:(NSString *)alias forFunctionName:(NSString *)functionName {
    alias = [alias lowercaseString];
    
	//we can't add an alias for a function that already exists
    if ([_DDFunctionEvaluator isStandardFunction:alias]) {
        return NO;
    }
    
    if ([_functionMap objectForKey:alias] != nil) {
        return NO;
    }
    
    DDMathFunction function = ^DDExpression* (NSArray *args, NSDictionary *vars, DDMathEvaluator *eval, NSError **error) {
        DDExpression *e = [DDExpression functionExpressionWithFunction:functionName arguments:args error:error];
        NSNumber *n = [eval evaluateExpression:e withSubstitutions:vars error:error];
        return [DDExpression numberExpressionWithNumber:n];
    };
    
    function = [function copy];
    [_functionMap setObject:function forKey:alias];
    
    return YES;
}

- (void)removeAlias:(NSString *)alias {
    alias = [alias lowercaseString];
    [_functionMap removeObjectForKey:alias];
}

#pragma mark - Evaluation

- (NSNumber *)evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)substitutions {
	NSError *error = nil;
	NSNumber *returnValue = [self evaluateString:expressionString withSubstitutions:substitutions error:&error];
	if (!returnValue) {
		NSLog(@"error: %@", error);
	}
	return returnValue;
}

- (NSNumber *)evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error {
    DDMathStringTokenizer *tokenizer = [[DDMathStringTokenizer alloc] initWithString:expressionString operatorSet:self.operatorSet error:error];
    if (!tokenizer) { return nil; }
    
    DDParser *parser = [DDParser parserWithTokenizer:tokenizer error:error];
    if (!parser) { return nil; }
    
    DDExpression *expression = [parser parsedExpressionWithError:error];
    if (!expression) { return nil; }
    
    return [self evaluateExpression:expression withSubstitutions:substitutions error:error];
}

- (NSNumber *)evaluateExpression:(DDExpression *)expression withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error {
    if ([expression expressionType] == DDExpressionTypeNumber) {
        return [expression number];
    } else if ([expression expressionType] == DDExpressionTypeVariable) {
        return [self _evaluateVariableExpression:expression withSubstitutions:substitutions error:error];
    } else if ([expression expressionType] == DDExpressionTypeFunction) {
        return [self _evaluateFunctionExpression:(_DDFunctionExpression *)expression withSubstitutions:substitutions error:error];
    }
    return nil;
}

- (NSNumber *)_evaluateVariableExpression:(DDExpression *)e withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error {
	id variableValue = [substitutions objectForKey:[e variable]];
    
    if (variableValue == nil) {
        // the substitutions dictionary was insufficient
        // use the variable resolver (if available)
        variableValue = [self variableWithName:[e variable]];
    }
    
    NSNumber *numberValue = [self _evaluateValue:variableValue withSubstitutions:substitutions error:error];
    if (numberValue == nil && error != nil && *error == nil) {
        *error = [NSError errorWithDomain:DDMathParserErrorDomain
                                     code:DDErrorCodeUnresolvedVariable
                                 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"unable to resolve variable: %@", e],
                                            DDUnknownVariableKey: [e variable]}];
	}
	return numberValue;
    
}

- (NSNumber *)_evaluateFunctionExpression:(_DDFunctionExpression *)e withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error {
    
    id result = [_functionEvaluator evaluateFunction:e variables:substitutions error:error];
    
    if (!result) { return nil; }
    
    NSNumber *numberValue = [self _evaluateValue:result withSubstitutions:substitutions error:error];
    if (numberValue == nil && error != nil && *error == nil) {
        *error = ERR(DDErrorCodeInvalidFunctionReturnType, @"invalid return type from %@ function", [e function]);
    }
    return numberValue;
}

- (NSNumber *)_evaluateValue:(id)value withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error {
    // given an object of unknown type, this evaluates it as best as it can
    if ([value isKindOfClass:[DDExpression class]]) {
        return [self evaluateExpression:value withSubstitutions:substitutions error:error];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [self evaluateString:value withSubstitutions:substitutions error:error];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}

#pragma mark - Built-In Functions

+ (NSDictionary *)_standardAliases {
    static dispatch_once_t onceToken;
    static NSDictionary *standardAliases = nil;
    dispatch_once(&onceToken, ^{
        standardAliases = @{@"avg": @"average",
                            @"mean": @"average",
                            @"trunc": @"floor",
                            @"modulo": @"mod",
                            @"\u03C0": @"pi", // π
                            @"tau_2": @"pi",
                            @"\u03C4": @"tau", // τ
                            @"\u03D5": @"phi", // ϕ
                            
                            @"vers": @"versin",
                            @"ver": @"versin",
                            @"vercos": @"vercosin",
                            @"cvs": @"coversin",
                            @"chord": @"crd"};
    });
    return standardAliases;
}

#pragma mark - Deprecated Methods

+ (id)sharedMathEvaluator {
    return [self defaultMathEvaluator];
}

- (DDExpression *)expressionByRewritingExpression:(DDExpression *)expression {
    return [[DDExpressionRewriter defaultRewriter] expressionByRewritingExpression:expression withEvaluator:self];
}

- (void)addRewriteRule:(NSString *)rule forExpressionsMatchingTemplate:(NSString *)templateString condition:(NSString *)condition {
    [[DDExpressionRewriter defaultRewriter] addRewriteRule:rule forExpressionsMatchingTemplate:templateString condition:condition];
}

@end
