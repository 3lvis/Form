//
//  _DDRewriteRule.m
//  DDMathParser
//
//  Created by Dave DeLong on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DDMathParser.h"
#import "_DDRewriteRule.h"
#import "DDExpression.h"

@interface _DDRewriteRule ()

- (id)initWithTemplate:(NSString *)string replacementPattern:(NSString *)pattern condition:(NSString *)condition;

@end

@implementation _DDRewriteRule {
    DDExpression *_predicate;
    DDExpression *_pattern;
    DDExpression *_condition;
}

+ (_DDRewriteRule *)rewriteRuleWithTemplate:(NSString *)string replacementPattern:(NSString *)replacement condition:(NSString *)condition {
    return [[self alloc] initWithTemplate:string replacementPattern:replacement condition:condition];
}

- (id)initWithTemplate:(NSString *)string replacementPattern:(NSString *)patternFormat condition:(NSString *)conditionFormat {
    self = [super init];
    if (self) {
        NSError *error = nil;
        _predicate = [DDExpression expressionFromString:string error:&error];
        _pattern = [DDExpression expressionFromString:patternFormat error:&error];
        
        if (!_predicate || !_pattern || [_predicate expressionType] != DDExpressionTypeFunction) {
            NSLog(@"error creating rule: %@", error);
            return nil;
        }
        
        if (conditionFormat) {
            _condition = [DDExpression expressionFromString:conditionFormat error:&error];
        }
    }
    return self;
}

- (BOOL)_ruleExpression:(DDExpression *)rule matchesExpression:(DDExpression *)target withReplacements:(NSMutableDictionary *)replacements {
    if ([rule expressionType] == DDExpressionTypeNumber || [rule expressionType] == DDExpressionTypeVariable) {
        return [target isEqual:rule];
    }
    
    NSString *function = [rule function];
    
    if ([function hasPrefix:DDRuleTemplateAnyExpression]) {
        DDExpression *seenBefore = [replacements objectForKey:function];
        if (seenBefore != nil) {
            return [seenBefore isEqual:target];
        }
        [replacements setObject:target forKey:function];
        return YES;
    }
    
    if ([function hasPrefix:DDRuleTemplateAnyNumber] && [target expressionType] == DDExpressionTypeNumber) {
        DDExpression *seenBefore = [replacements objectForKey:function];
        if (seenBefore != nil) {
            return [seenBefore isEqual:target];
        }
        [replacements setObject:target forKey:function];
        return YES;
    }
    
    if ([function hasPrefix:DDRuleTemplateAnyVariable] && [target expressionType] == DDExpressionTypeVariable) {
        DDExpression *seenBefore = [replacements objectForKey:function];
        if (seenBefore != nil) {
            return [seenBefore isEqual:target];
        }
        [replacements setObject:target forKey:function];
        return YES;
    }
    
    if ([function hasPrefix:DDRuleTemplateAnyFunction] && [target expressionType] == DDExpressionTypeFunction) {
        DDExpression *seenBefore = [replacements objectForKey:function];
        if (seenBefore != nil) {
            return [seenBefore isEqual:target];
        }
        [replacements setObject:target forKey:function];
        return YES;        
    }
    
    if ([rule expressionType] != [target expressionType]) { return NO; }
    
    // the target is a function
    // first match all the arguments
    // then we'll see about matching the functions
    
    NSArray *ruleArgs = [rule arguments];
    NSArray *targetArgs = [target arguments];
    
    if ([ruleArgs count] != [targetArgs count]) { return NO; }
    
    if (![function isEqual:[target function]]) { return NO; }
    
    BOOL argsMatch = YES;
    for (NSUInteger i = 0; i < [ruleArgs count]; ++i) {
        DDExpression *ruleArg = [ruleArgs objectAtIndex:i];
        DDExpression *targetArg = [targetArgs objectAtIndex:i];
        
        argsMatch &= [self _ruleExpression:ruleArg matchesExpression:targetArg withReplacements:replacements];
        
        if (!argsMatch) { break; }
    }
    
    return argsMatch;
}

- (DDExpression *)_expressionByApplyingReplacements:(NSDictionary *)replacements toPattern:(DDExpression *)p {
    if ([p expressionType] == DDExpressionTypeVariable) { return p; }
    if ([p expressionType] == DDExpressionTypeNumber) { return p; }
    
    NSString *pFunction = [p function];
    
    DDExpression *functionReplacement = [replacements objectForKey:pFunction];
    if (functionReplacement) {
        return functionReplacement;
    }
    
    NSMutableArray *replacedArguments = [NSMutableArray array];
    for (DDExpression *patternArgument in [p arguments]) {
        DDExpression *replacementArgument = [self _expressionByApplyingReplacements:replacements toPattern:patternArgument];
        [replacedArguments addObject:replacementArgument];
    }
    
    return [DDExpression functionExpressionWithFunction:pFunction arguments:replacedArguments error:nil];
}

- (BOOL)matchExpression:(DDExpression *)target replacements:(NSMutableDictionary *)replacements evaluator:(DDMathEvaluator *)evaluator {
    BOOL matches = [self _ruleExpression:_predicate matchesExpression:target withReplacements:replacements];
    if (matches && _condition) {
        DDExpression *resolvedCondition = [self _expressionByApplyingReplacements:replacements toPattern:_condition];
        NSError *evalError = nil;
        NSNumber *result = [evaluator evaluateExpression:resolvedCondition withSubstitutions:replacements error:&evalError];
        matches &= [result boolValue];
    }
    return matches;
}

- (BOOL)ruleMatchesExpression:(DDExpression *)target withEvaluator:(DDMathEvaluator *)evaluator {
    return [self matchExpression:target replacements:[NSMutableDictionary dictionary] evaluator:evaluator];
}

- (DDExpression *)expressionByRewritingExpression:(DDExpression *)target withEvaluator:(DDMathEvaluator *)evaluator {
    NSMutableDictionary *replacements = [NSMutableDictionary dictionary];
    if (![self matchExpression:target replacements:replacements evaluator:evaluator]) { return target; }
    
    return [self _expressionByApplyingReplacements:replacements toPattern:_pattern];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@ => %@)", [super description], _predicate, _pattern];
}

@end
