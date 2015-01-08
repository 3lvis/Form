//
//  DDMathEvaluator.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTypes.h"

@class DDMathOperatorSet;
@class DDExpression;

typedef DDMathFunction (^DDFunctionResolver)(NSString *);
typedef NSNumber* (^DDVariableResolver)(NSString *);

@interface DDMathEvaluator : NSObject

@property (nonatomic) BOOL usesHighPrecisionEvaluation; // default is NO
@property (nonatomic) BOOL resolvesFunctionsAsVariables; // default is NO
@property (nonatomic, strong) DDMathOperatorSet *operatorSet;

@property (nonatomic) DDAngleMeasurementMode angleMeasurementMode; // default is Radians
@property (nonatomic, copy) DDFunctionResolver functionResolver;
@property (nonatomic, copy) DDVariableResolver variableResolver;

+ (instancetype)defaultMathEvaluator;

- (BOOL)registerFunction:(DDMathFunction)function forName:(NSString *)functionName;
- (NSArray *)registeredFunctions;

- (NSNumber *)evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)substitutions;
- (NSNumber *)evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error;

- (NSNumber *)evaluateExpression:(DDExpression *)expression withSubstitutions:(NSDictionary *)substitutions error:(NSError **)error;

- (BOOL)addAlias:(NSString *)alias forFunctionName:(NSString *)functionName;
- (void)removeAlias:(NSString *)alias;

@end

@interface DDMathEvaluator (Deprecated)

+ (id)sharedMathEvaluator __attribute__((deprecated("Use +defaultMathEvaluator instead")));

- (void)unregisterFunctionWithName:(NSString *)functionName __attribute__((deprecated("You should almost never need to unregister a function")));

- (void)addRewriteRule:(NSString *)rule forExpressionsMatchingTemplate:(NSString *)templateString condition:(NSString *)condition __attribute__((deprecated("Use -[DDExpressionRewriter addRewriteRule:forExpressionsMatchingTemplate:condition:] instead")));

- (DDExpression *)expressionByRewritingExpression:(DDExpression *)expression __attribute__((deprecated("Use -[DDExpressionRewriter expressionByRewritingExpression:withEvaluator:] instead")));

@end
